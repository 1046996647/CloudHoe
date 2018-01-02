//
//  UIImage+UIImageExt.m
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/8/3.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import "UIImage+UIImageExt.h"

@implementation UIImage (UIImageExt)

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
