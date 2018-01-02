//
//  BaseViewController.m
//  HealthManagement
//
//  Created by ZhangWeiLiang on 2017/7/7.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    // 设置了UIRectEdgeNone之后，你嵌在UIViewController里面的UITableView和UIScrollView就不会穿过UINavigationBar了，同时UIView的控件也回复到了iOS6时代。
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navigationController.childViewControllers.count > 1) {


        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Back "] forState:UIControlStateNormal];
        CGRect frame = button.frame;
        frame.size = CGSizeMake(46, 30);
        button.frame = frame;
//        button.backgroundColor = [UIColor greenColor]
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button.titleLabel.font = SystemFont(15);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.backButton = button;
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
