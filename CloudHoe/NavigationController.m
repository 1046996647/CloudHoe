//
//  RCNavigationController.m
//  ChangeLanguage
//
//  Created by RongCheng on 16/7/21.
//  Copyright © 2016年 RongCheng. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#50DBD1"];
    

    //消除底部横线
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // 设置字体
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FFFFFF"]}];
    
//    //1.设置阴影颜色
//    self.navigationBar.layer.shadowColor = [UIColor grayColor].CGColor;
//    
//    //2.设置阴影偏移范围
//    self.navigationBar.layer.shadowOffset = CGSizeMake(0, .5);
//    
//    //3.设置阴影颜色的透明度
//    self.navigationBar.layer.shadowOpacity = 0.2;

    
    self.interactivePopGestureRecognizer.delegate = self;
}
/**
 *  重写push方法
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        /**
         *  设置默认的"< 返回 "
         */
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
////        [button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
////        [button setImage:[UIImage imageNamed:@"navigationReturnClick"] forState:UIControlStateHighlighted];
//        CGRect frame = button.frame;
//        frame.size = CGSizeMake(30, 20);
//        button.frame = frame;
//        
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
////        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];

}
//- (void)back{
//    [self popViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    else {
        return YES;

    }
}


@end
