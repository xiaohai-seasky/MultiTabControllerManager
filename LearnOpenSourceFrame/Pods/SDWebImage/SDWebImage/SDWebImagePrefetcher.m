/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImagePrefetcher.h"

@interface SDWebImagePrefetcher ()

@property (strong, nonatomic) SDWebImageManager *manager;                               // manager
@property (strong, nonatomic) NSArray *prefetchURLs;                                    // 要预取的URL
@property (assign, nonatomic) NSUInteger requestedCount;                                // 请求数量
@property (assign, nonatomic) NSUInteger skippedCount;                                  // 跳过的数量
@property (assign, nonatomic) NSUInteger finishedCount;                                 // 完成的数量
@property (assign, nonatomic) NSTimeInterval startedTime;                               // 开始多长时间
@property (copy, nonatomic) SDWebImagePrefetcherCompletionBlock completionBlock;        // 完成回调
@property (copy, nonatomic) SDWebImagePrefetcherProgressBlock progressBlock;            // 进度回调

@end

@implementation SDWebImagePrefetcher

/**  */
+ (SDWebImagePrefetcher *)sharedImagePrefetcher {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

/**  */
- (id)init {
    return [self initWithImageManager:[SDWebImageManager new]];
}

/**  */
- (id)initWithImageManager:(SDWebImageManager *)manager {
    if ((self = [super init])) {
        _manager = manager;
        /// 默认图片下载质量为 低质量
        _options = SDWebImageLowPriority;
        /// 默认操作队列是 主队列
        _prefetcherQueue = dispatch_get_main_queue();
        /// 默认最大并发下载数量 3
        self.maxConcurrentDownloads = 3;
    }
    return self;
}

/** 设置最大并发下载数量 */
- (void)setMaxConcurrentDownloads:(NSUInteger)maxConcurrentDownloads {
    self.manager.imageDownloader.maxConcurrentDownloads = maxConcurrentDownloads;
}

/**  */
- (NSUInteger)maxConcurrentDownloads {
    return self.manager.imageDownloader.maxConcurrentDownloads;
}

/** 从第index 项开始预取 */
- (void)startPrefetchingAtIndex:(NSUInteger)index {
    
    if (index >= self.prefetchURLs.count) return;
    /// 开始对一个URL进行预取，请求数量 ＋1
    self.requestedCount++;
    
    [self.manager downloadImageWithURL:self.prefetchURLs[index] options:self.options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        
        if (!finished) return;
        /// 完成一个URL的预取，完成数量 ＋1
        self.finishedCount++;

        /// 回调预取进度：完成数量 -> 预取URL总数
        if (image) {
            if (self.progressBlock) {
                self.progressBlock(self.finishedCount,[self.prefetchURLs count]);
            }
        }
        else {
            if (self.progressBlock) {
                self.progressBlock(self.finishedCount,[self.prefetchURLs count]);
            }
            // Add last failed
            /// 一个URL的预取失败，跳过数量 ＋1
            self.skippedCount++;
        }
        
        /// 通知代理预取结果
        if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didPrefetchURL:finishedCount:totalCount:)]) {
            [self.delegate imagePrefetcher:self
                            didPrefetchURL:self.prefetchURLs[index]
                             finishedCount:self.finishedCount
                                totalCount:self.prefetchURLs.count
             ];
        }
        
        ///
        if (self.prefetchURLs.count > self.requestedCount) {
            /// 需要预取的URL总数 大于 正在预取的URL数量
            dispatch_async(self.prefetcherQueue, ^{
                [self startPrefetchingAtIndex:self.requestedCount];
            });
        } else if (self.finishedCount == self.requestedCount) {
            /// 预取完成的URL数量 等于 正在预取的URL数量
            [self reportStatus];
            if (self.completionBlock) {
                self.completionBlock(self.finishedCount, self.skippedCount);
                self.completionBlock = nil;
            }
            self.progressBlock = nil;
        }
    }];
}

/** 向代理报告完成状态：完成总数量 -> 跳过数量 */
- (void)reportStatus {
    NSUInteger total = [self.prefetchURLs count];
    if ([self.delegate respondsToSelector:@selector(imagePrefetcher:didFinishWithTotalCount:skippedCount:)]) {
        [self.delegate imagePrefetcher:self
               didFinishWithTotalCount:(total - self.skippedCount)
                          skippedCount:self.skippedCount
         ];
    }
}

/** 对指定的一些URL 进行预取 -> */
- (void)prefetchURLs:(NSArray *)urls {
    [self prefetchURLs:urls progress:nil completed:nil];
}

/** 对指定的一些URL 进行预取，并带有进度回调、完成回调 */
- (void)prefetchURLs:(NSArray *)urls progress:(SDWebImagePrefetcherProgressBlock)progressBlock completed:(SDWebImagePrefetcherCompletionBlock)completionBlock {
    
    /// 预取之前先取消所有预取，避免重复的预取请求
    [self cancelPrefetching]; // Prevent duplicate prefetch request
    self.startedTime = CFAbsoluteTimeGetCurrent();   // ?
    self.prefetchURLs = urls;
    self.completionBlock = completionBlock;
    self.progressBlock = progressBlock;

    if (urls.count == 0) {
        /// 没有要预取的URL
        if (completionBlock) {
            completionBlock(0,0);
        }
    } else {
        // Starts prefetching from the very first image on the list with the max allowed concurrency
        /// 在最大并发数量之内 开始对预取列表中的URL 进行预取
        NSUInteger listCount = self.prefetchURLs.count;
        for (NSUInteger i = 0; i < self.maxConcurrentDownloads && self.requestedCount < listCount; i++) {
            [self startPrefetchingAtIndex:i];
        }
    }
}

/** 取消所有预取 */
- (void)cancelPrefetching {
    self.prefetchURLs = nil;
    self.skippedCount = 0;
    self.requestedCount = 0;
    self.finishedCount = 0;
    [self.manager cancelAll];
}

@end
