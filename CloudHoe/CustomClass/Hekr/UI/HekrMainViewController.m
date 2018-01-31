//
//  HekrMainViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/28.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "HekrMainViewController.h"

@interface HekrMainViewController ()

@end

@implementation HekrMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"Config"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //    [MobClick endLogPageView:@"Config"];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavView
{
    _nav = [[HekrNavigationBarView alloc] initWithFrame:BarViewRectMake withTitle:self.title leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:_nav];
}


@end
