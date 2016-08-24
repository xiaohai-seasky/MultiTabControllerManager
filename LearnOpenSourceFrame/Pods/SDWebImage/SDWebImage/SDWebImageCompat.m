//
//  SDWebImageCompat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 11/12/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "SDWebImageCompat.h"

#if !__has_feature(objc_arc)
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

/** 以key 指定的方式对 image 进行缩放 */
inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    
    if (!image) {
        return nil;
    }
    
    /// 当image 中包含多张图片时，对里边的每一张图片分别进行相同的缩放(这种情况通常是 GIF 图片)
    if ([image.images count] > 0) {
        NSMutableArray *scaledImages = [NSMutableArray array];

        /// 在循环中递归调用该方法对每张图片进行缩放
        for (UIImage *tempImage in image.images) {
            [scaledImages addObject:SDScaledImageForKey(key, tempImage)];
        }

        return [UIImage animatedImageWithImages:scaledImages duration:image.duration];   // ?
    }
    /// iamge 中只包含一张图片(image 本身)
    else {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {   // ?
            
            CGFloat scale = 1;
            
            if (key.length >= 8) {
                /// 是否是 @2x 图片
                NSRange range = [key rangeOfString:@"@2x."];
                if (range.location != NSNotFound) {
                    scale = 2.0;
                }
                
                /// 是否是 @3x 图片
                range = [key rangeOfString:@"@3x."];
                if (range.location != NSNotFound) {
                    scale = 3.0;
                }
            }

            UIImage *scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];   // ?
            image = scaledImage;
        }
        return image;
    }
}

/// error 域
NSString *const SDWebImageErrorDomain = @"SDWebImageErrorDomain";

