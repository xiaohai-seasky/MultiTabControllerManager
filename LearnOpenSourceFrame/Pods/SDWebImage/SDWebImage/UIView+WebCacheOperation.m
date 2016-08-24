/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIView+WebCacheOperation.h"
#import "objc/runtime.h"

static char loadOperationKey;

@implementation UIView (WebCacheOperation)

/** 获取下载操作dic */
- (NSMutableDictionary *)operationDictionary {
    /// 获取到直接返回
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);   // ?
    if (operations) {
        return operations;
    }
    /// 获取为空则创建一个新的dic
    operations = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   // ?
    return operations;
}

/** 为key 设置相应的图片加载操作 */
- (void)sd_setImageLoadOperation:(id)operation forKey:(NSString *)key {
    /// 设置之前先取消该key 对应的操作
    [self sd_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

/** 取消图片加载操作 */
- (void)sd_cancelImageLoadOperationWithKey:(NSString *)key {
    
    // Cancel in progress downloader from queue
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        /// 数组
        if ([operations isKindOfClass:[NSArray class]]) {
            /// 在循环中取消所有的SDWebImageOperation 操作
            for (id <SDWebImageOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        }
        /// 非数组但 符合 SDWebImageOperation 协议
        else if ([operations conformsToProtocol:@protocol(SDWebImageOperation)]){   // ?
            [(id<SDWebImageOperation>) operations cancel];
        }
        
        /// 移除key 对应的一系列操作
        [operationDictionary removeObjectForKey:key];
    }
}

/** 删除key 对应的图片加载操作 */
- (void)sd_removeImageLoadOperationWithKey:(NSString *)key {
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary removeObjectForKey:key];
}

@end
