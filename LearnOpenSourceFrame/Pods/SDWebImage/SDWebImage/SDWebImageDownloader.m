/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"
#import <ImageIO/ImageIO.h>

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface SDWebImageDownloader ()

@property (strong, nonatomic) NSOperationQueue *downloadQueue;       // 下载操作队列
@property (weak, nonatomic) NSOperation *lastAddedOperation;         // 最后加入的操作
@property (assign, nonatomic) Class operationClass;                  // 操作类
@property (strong, nonatomic) NSMutableDictionary *URLCallbacks;     // URL回调
@property (strong, nonatomic) NSMutableDictionary *HTTPHeaders;      // HTTP头部信息
// This queue is used to serialize the handling of the network responses of all the download operation in a single queue
@property (SDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t barrierQueue;   // 屏蔽队列

@end

@implementation SDWebImageDownloader

/** 该方法主要是集成 SDNetworkActivityIndicator 做网络提示，可以不用 */
+ (void)initialize {
    // Bind SDNetworkActivityIndicator if available (download it here: http://github.com/rs/SDNetworkActivityIndicator )
    // To use it, just add #import "SDNetworkActivityIndicator.h" in addition to the SDWebImage import
    if (NSClassFromString(@"SDNetworkActivityIndicator")) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id activityIndicator = [NSClassFromString(@"SDNetworkActivityIndicator") performSelector:NSSelectorFromString(@"sharedActivityIndicator")];
#pragma clang diagnostic pop

        // Remove observer in case it was previously added.
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:activityIndicator name:SDWebImageDownloadStopNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"startActivity")
                                                     name:SDWebImageDownloadStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:activityIndicator
                                                 selector:NSSelectorFromString(@"stopActivity")
                                                     name:SDWebImageDownloadStopNotification object:nil];
    }
}

/**  */
+ (SDWebImageDownloader *)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

/**  */
- (id)init {
    if ((self = [super init])) {
        _operationClass = [SDWebImageDownloaderOperation class];
        /// 默认可以解压图片
        _shouldDecompressImages = YES;
        /// 下载操作执行顺序 ：队列形式
        _executionOrder = SDWebImageDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        /// 下载队列最大病发数 ：6
        _downloadQueue.maxConcurrentOperationCount = 6;
        _URLCallbacks = [NSMutableDictionary new];
#ifdef SD_WEBP
        _HTTPHeaders = [@{@"Accept": @"image/webp,image/*;q=0.8"} mutableCopy];
#else
        _HTTPHeaders = [@{@"Accept": @"image/*;q=0.8"} mutableCopy];   // ?
#endif
        /// 并发队列
        _barrierQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        /// 下载超时时间 ：15 秒
        _downloadTimeout = 15.0;
    }
    return self;
}

- (void)dealloc {
    [self.downloadQueue cancelAllOperations];   // ?
    SDDispatchQueueRelease(_barrierQueue);   // ?
}

/** 设置HTTP 头部信息，如果value 为空则删除相应的HTTP 头部信息 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    if (value) {
        self.HTTPHeaders[field] = value;
    }
    else {
        [self.HTTPHeaders removeObjectForKey:field];
    }
}

/** 获取HTTP 头部信息 */
- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return self.HTTPHeaders[field];
}

/** 设置下载队列的最大并发数 */
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

/** 获取当前正在下载的操作数量 */
- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;   // ?
}

/** 获取下载队列最大并发数 */
- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}

/**  */
- (void)setOperationClass:(Class)operationClass {
    _operationClass = operationClass ?: [SDWebImageDownloaderOperation class];
}

/** 下载图片，返回可操作的 opration 。。。。。。。 */
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url options:(SDWebImageDownloaderOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock {
    __block SDWebImageDownloaderOperation *operation;
    __weak __typeof(self)wself = self;

    [self addProgressCallback:progressBlock completedBlock:completedBlock forURL:url createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval == 0.0) {
            timeoutInterval = 15.0;
        }

        // In order to prevent from potential duplicate caching (NSURLCache + SDImageCache) we disable the cache for image requests if told otherwise
        /// 创建 request .......
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(options & SDWebImageDownloaderUseNSURLCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData) timeoutInterval:timeoutInterval];   // ?
        request.HTTPShouldHandleCookies = (options & SDWebImageDownloaderHandleCookies);   // ?
        request.HTTPShouldUsePipelining = YES;   // ?
        if (wself.headersFilter) {
            request.allHTTPHeaderFields = wself.headersFilter(url, [wself.HTTPHeaders copy]);
        }
        else {
            request.allHTTPHeaderFields = wself.HTTPHeaders;   // ?
        }
        
        /// 创建 operation
        operation = [[wself.operationClass alloc] initWithRequest:request
                                                          options:options
                                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                             SDWebImageDownloader *sself = wself;
                                                             if (!sself) return;
                                                             __block NSArray *callbacksForURL;
                                                             dispatch_sync(sself.barrierQueue, ^{
                                                                 callbacksForURL = [sself.URLCallbacks[url] copy];
                                                             });
                                                             for (NSDictionary *callbacks in callbacksForURL) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                     SDWebImageDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                                                                     if (callback) callback(receivedSize, expectedSize);
                                                                 });
                                                             }
                                                         }
                                                        completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                            SDWebImageDownloader *sself = wself;
                                                            if (!sself) return;
                                                            __block NSArray *callbacksForURL;
                                                            dispatch_barrier_sync(sself.barrierQueue, ^{
                                                                callbacksForURL = [sself.URLCallbacks[url] copy];
                                                                /// 任务完成后移除回调
                                                                if (finished) {
                                                                    [sself.URLCallbacks removeObjectForKey:url];
                                                                }
                                                            });
                                                            for (NSDictionary *callbacks in callbacksForURL) {
                                                                SDWebImageDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                                                                if (callback) callback(image, data, error, finished);
                                                            }
                                                        }
                                                        cancelled:^{
                                                            SDWebImageDownloader *sself = wself;
                                                            if (!sself) return;
                                                            dispatch_barrier_async(sself.barrierQueue, ^{
                                                                [sself.URLCallbacks removeObjectForKey:url];
                                                            });
                                                        }];
        /// 配置 operation
        operation.shouldDecompressImages = wself.shouldDecompressImages;
        
        if (wself.urlCredential) {
            operation.credential = wself.urlCredential;
        } else if (wself.username && wself.password) {
            operation.credential = [NSURLCredential credentialWithUser:wself.username password:wself.password persistence:NSURLCredentialPersistenceForSession];   // ?
        }
        
        if (options & SDWebImageDownloaderHighPriority) {
            operation.queuePriority = NSOperationQueuePriorityHigh;   // ?
        } else if (options & SDWebImageDownloaderLowPriority) {
            operation.queuePriority = NSOperationQueuePriorityLow;
        }

        /// operation 添加到 downloadQueue
        [wself.downloadQueue addOperation:operation];
        if (wself.executionOrder == SDWebImageDownloaderLIFOExecutionOrder) {
            // Emulate LIFO execution order by systematically adding new operations as last operation's dependency
            /// 通过有组织的将新添加的 operation 作为 上次纪录的最后一个被添加的 operation 的依赖，来模仿后进先出的栈执行顺序
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];

    return operation;
}

/** 为一个URL 添加进度回调（progressBlock），完成回调（completedBlock），无参回调（createCallback） */
- (void)addProgressCallback:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageDownloaderCompletedBlock)completedBlock forURL:(NSURL *)url createCallback:(SDWebImageNoParamsBlock)createCallback {
    // The URL will be used as the key to the callbacks dictionary so it cannot be nil. If it is nil immediately call the completed block with no image or data.
    /// 这里的 URL 会被用作 callbacks 字典的 key，所依这个URL 不能为空，如果为空会马上使用 空的image 或者空的data 调用completed 回调
    if (url == nil) {
        if (completedBlock != nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return;
    }

    dispatch_barrier_sync(self.barrierQueue, ^{   // ?
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [NSMutableArray new];
            first = YES;
        }

        // Handle single download of simultaneous download request for the same URL
        /// 处理对于同一个URL的多个同时进行的下载请求当中的一个
        /// 以下代码添加一个URL 的progressBlock completedBlock 到self.URLCallbacks 字典中
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
        if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;

        if (first) {
            createCallback();
        }
    });
}

/** 设置下载队列的阻塞状态 */
- (void)setSuspended:(BOOL)suspended {
    [self.downloadQueue setSuspended:suspended];   // ?
}

/** 取消所有的下载操作 */
- (void)cancelAllDownloads {
    [self.downloadQueue cancelAllOperations];   // ?
}

@end
