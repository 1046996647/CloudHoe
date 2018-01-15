//
//  UIImage+UIImageExt.m
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/8/3.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import "UIImage+UIImageExt.h"

@implementation UIImage (UIImageExt)

/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat screenWidth = kScreenWidth;
    CGFloat screenHeight = kScreenHeight;
    
    // 如果读取的二维码照片宽和高小于屏幕尺寸，直接返回原图片
    if (imageWidth <= screenWidth && imageHeight <= screenHeight) {
        return image;
    }
    
    //SGQRCodeLog(@"压缩前图片尺寸 － width：%.2f, height: %.2f", imageWidth, imageHeight);
    CGFloat max = MAX(imageWidth, imageHeight);
    // 如果是6plus等设备，比例应该是 3.0
    CGFloat scale = max / (screenHeight * 2.0f);
    //SGQRCodeLog(@"压缩后图片尺寸 － width：%.2f, height: %.2f", imageWidth / scale, imageHeight / scale);
    
    return [UIImage imageWithImage:image scaledToSize:CGSizeMake(imageWidth / scale, imageHeight / scale)];
}
/// 返回一张处理后的图片
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(NSData *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImagePNGRepresentation(newImage);

    return data;
}

//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

//图片旋转
+ (NSData *)imageOrientation:(UIImage *)image

{
    //处理后的图片
    UIImage *normalizedImage = nil;
    
    //图片方向处理
    if (image.imageOrientation == UIImageOrientationUp) {
        normalizedImage = image;
    } else {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
        [image drawInRect:(CGRect){0, 0, image.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    //图片转成Base64Str
    //    NSData *data = UIImagePNGRepresentation(image);
    NSData *data = UIImageJPEGRepresentation(normalizedImage, .3);
    
    return data;
    
}

@end
