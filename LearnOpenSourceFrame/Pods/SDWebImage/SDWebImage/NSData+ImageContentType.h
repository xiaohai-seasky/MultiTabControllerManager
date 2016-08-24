//
// Created by Fabrice Aneche on 06/01/14.
// Copyright (c) 2014 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>

/// NSData 扩展
@interface NSData (ImageContentType)

/**
 *  Compute the content type for an image data
 *
 *  @param data the input data
 *
 *  @return the content type as string (i.e. image/jpeg, image/gif)
 * 
 *  计算一个图片的 内容类型(如：image/jpeg, image/gif 等)
 */
+ (NSString *)sd_contentTypeForImageData:(NSData *)data;

@end


/// NSData 扩展(不赞成的、弃用的)
@interface NSData (ImageContentTypeDeprecated)

+ (NSString *)contentTypeForImageData:(NSData *)data __deprecated_msg("Use `sd_contentTypeForImageData:`");

@end
