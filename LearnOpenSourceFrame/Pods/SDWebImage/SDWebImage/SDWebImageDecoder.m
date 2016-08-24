/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * Created by james <https://github.com/mystcolor> on 9/28/11.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDecoder.h"

@implementation UIImage (ForceDecode)

/** 解码指定图片 */
+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    // while downloading huge amount of images
    // autorelease the bitmap context
    // and all vars to help system to free memory
    // when there are memory warning.
    // on iOS7, do not forget to call
    // [[SDImageCache sharedImageCache] clearMemory];
    ///
    /// 在下载大量图片时，接收到内存警告后，自动释放 位图上下文和所有的变量来帮助系统释放内存，在iOS7中不要忘记调用 [[SDImageCache sharedImageCache] clearMemory];
    
    if (image == nil) { // Prevent "CGBitmapContextCreateImage: invalid context 0x0" error
        return nil;
    }
    
    /// 自动释放池
    @autoreleasepool{
        // do not decode animated images
        /// 不要解码动态图片
        if (image.images != nil) {   // ?
            return image;
        }
        
        
        /// 以下是底层图片处理代码
        
        /// 图片句柄
        CGImageRef imageRef = image.CGImage;
        /// 获取图片透明度信息
        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
        BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                         alpha == kCGImageAlphaLast ||
                         alpha == kCGImageAlphaPremultipliedFirst ||
                         alpha == kCGImageAlphaPremultipliedLast);
        /// 包含任意透明通道都直接返回，不作处理
        if (anyAlpha) {
            return image;
        }
        
        // current
        /// 获取颜色空间模式
        CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
        /// 获取颜色空间
        CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
        
        /// 是否有不支持的颜色空间模式
        BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                      imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                      imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                      imageColorSpaceModel == kCGColorSpaceModelIndexed);
        /// 如果颜色空间模式不支持，则创建新的颜色空间
        if (unsupportedColorSpace) {
            colorspaceRef = CGColorSpaceCreateDeviceRGB();
        }
        
        /// 获取图片宽度
        size_t width = CGImageGetWidth(imageRef);
        /// 获取图片高度
        size_t height = CGImageGetHeight(imageRef);
        /// 设置每像素包含4个字节
        NSUInteger bytesPerPixel = 4;
        /// 计算每行多少像素
        NSUInteger bytesPerRow = bytesPerPixel * width;
        /// 每部分8个像素
        NSUInteger bitsPerComponent = 8;


        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        ///
        /// CGBitmapContextCreate 不支持 kCGImageAlphaNone 模式，由于原始图片不包含透明信息，使用 kCGImageAlphaNoneSkipLast 来创建一个位图图像上下文，而且不带有透明信息
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        
        // Draw the image into the context and retrieve the new bitmap image without alpha
        /// 绘制图片到上下文，并且重新得到一个新的不带有透明信息的位图图片
        ///
        /// 绘制图片到上下文
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        /// 从上下文生成新的不带有透明信息的位图
        CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        /// 从新生成的位图生成 UIImage 对象
        UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];
        /// 释放颜色空间
        if (unsupportedColorSpace) {
            CGColorSpaceRelease(colorspaceRef);
        }
        
        /// 释放上下文对象
        CGContextRelease(context);
        /// 释放位图对象
        CGImageRelease(imageRefWithoutAlpha);
        
        return imageWithoutAlpha;
    }
}

@end
