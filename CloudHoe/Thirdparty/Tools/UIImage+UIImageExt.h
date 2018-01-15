//
//  UIImage+UIImageExt.h
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/8/3.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

/** 返回一张不超过屏幕尺寸的 image */
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

+(NSData *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//图片旋转
+ (NSData *)imageOrientation:(UIImage *)image;

//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;

@end
