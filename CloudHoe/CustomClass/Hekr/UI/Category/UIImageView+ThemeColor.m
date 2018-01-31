//
//  UIImageView+ThemeColor.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/11.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "UIImageView+ThemeColor.h"
#import "Tool.h"

@implementation UIImageView (ThemeColor)

-(void)setThemeImageNamed:(NSString *)name{
    
    self.tintColor = getButtonBackgroundColor();
    UIImage *tintImage = [UIImage imageNamed:name];
    tintImage = [tintImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.image = tintImage;
    
}

@end
