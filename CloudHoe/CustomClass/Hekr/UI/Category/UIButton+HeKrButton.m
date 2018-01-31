//
//  UIButton+HeKrButton.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UIButton+HeKrButton.h"
#import "Tool.h"

@implementation UIButton (HeKrButton)
+ (instancetype)buttonWithTitle:(NSString *)title image:(NSString *)image titleColor:(UIColor *)color frame:(CGRect )frame target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (instancetype)buttonWithTitle:(NSString *)title frame:(CGRect )frame target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = getButtonBackgroundColor();
    btn.layer.cornerRadius = BUTTONRadius;
    [btn setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setExclusiveTouch:YES];
    btn.titleLabel.font = getButtonTitleFont();
    return btn;
}

@end
