//
//  ResetEmailViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ResetEmailViewController.h"
//#import "LoginController.h"
#import "GiFHUD.h"
#import "Tool.h"
#import "EasyMacro.h"
#import "LoginViewController.h"
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@interface ResetEmailViewController ()

@end

@implementation ResetEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"ResetPassWord-Email"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ResetPassWord-Email"];
}

- (void)initNavView{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"忘记密码", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"忘记密码" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}
- (void)popClick{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LoginViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
}

- (void)createViews{
    //640 1136
    CGFloat imageUp = (160/1136.0)*ScreenHeight;
    CGFloat imageWidth = (120/640.0)*ScreenWidth;
    CGFloat gap1 = (40/1136.0)*ScreenHeight;
//    CGFloat gap2 = (60/1136.0)*Height;
    CGFloat labelgap = (100/640.0)*ScreenWidth;
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    image.center = CGPointMake(ScreenWidth/2, imageUp + imageWidth/2);
    image.image = [UIImage imageNamed:@"ic_duihao"];
    [self.view addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelgap, CGRectGetMaxY(image.frame)+gap1, ScreenWidth-labelgap*2, 60)];
    label.textColor = rgb(51, 51, 51);
    label.alpha = 0.56;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0;
    label.text = NSLocalizedString(@"重置邮件已发送至注册邮箱，点击邮件中的链接完成密码修改操作。", nil);
    [self.view addSubview:label];
    
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noBtn.frame = CGRectMake(0, CGRectGetMaxY(label.frame), ScreenWidth, 20);
    [noBtn setTitle:NSLocalizedString(@"未收到邮件？点击重试", nil) forState:UIControlStateNormal];
    [noBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    noBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [noBtn addTarget:self action:@selector(popClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noBtn];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
