//
//  UIButton+HeKrButton.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HeKrButton)
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image titleColor:(UIColor *)color frame:(CGRect )frame target:(id)target action:(SEL)action;

+ (instancetype)buttonWithTitle:(NSString *)title frame:(CGRect )frame target:(id)target action:(SEL)action;

@end
