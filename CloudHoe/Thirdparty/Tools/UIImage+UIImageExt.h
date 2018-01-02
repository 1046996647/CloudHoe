//
//  UIImage+UIImageExt.h
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/8/3.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)

+(NSData *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

//图片旋转
+ (NSData *)imageOrientation:(UIImage *)image;

@end
