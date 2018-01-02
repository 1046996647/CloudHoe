//
//  UIViewController+UIViewControllerExt.m
//  XiaoYing
//
//  Created by ZWL on 16/10/15.
//  Copyright © 2016年 yinglaijinrong. All rights reserved.
//

#import "UIViewController+UIViewControllerExt.h"

@implementation UIViewController (UIViewControllerExt)

- (void)popViewController:(NSString *)controllerStr
{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NSClassFromString(controllerStr) class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            
        }
    }
}

@end
