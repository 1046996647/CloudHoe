//
//  ChangeEmailViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/20.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import "EmailNumberViewController.h"
#import "GiFHUD.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "Tool.h"
#import <SHAlertViewBlocks.h>
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface ChangeEmailViewController ()

@end

@implementation ChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangeEmail"];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangeEmail"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"修改绑定", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
//    UILabel* upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    upLabel.backgroundColor = getCellLineColor();
//    [self.view addSubview:upLabel];
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"修改绑定" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_changeemail"]];
    [self.view addSubview:image];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"邮箱地址：",nil)];
    label.text = str;
    label.textColor = getTitledTextColor();
    [self.view addSubview:label];
    
    UILabel *upLabel = [UILabel new];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.font = [UIFont boldSystemFontOfSize:18];
    upLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"];
    upLabel.textColor = rgb(80, 80, 82);
    [self.view addSubview:upLabel];
    
    UILabel *downLabel = [UILabel new];
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.font = [UIFont systemFontOfSize:14];
    downLabel.text = NSLocalizedString(@"如需更换邮箱，请点击下方按钮进行操作", nil);
    downLabel.numberOfLines = 0;
    downLabel.textColor = getDescriptiveTextColor();
    downLabel.alpha = 0.8;
    [self.view addSubview:downLabel];
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"更换邮箱", nil) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(changeAction)];
    [self.view addSubview:button];
    
    WS(weakSelf);
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(140)+StatusBarAndNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(Vrange(150), Vrange(114)));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image.mas_bottom).offset(Vrange(76));
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 20));
    }];
    
    [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 20));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(upLabel.mas_bottom).offset(Vrange(120));
        make.size.mas_equalTo(CGSizeMake(sHrange(320), sVrange(40)));
    }];
    
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(button.mas_bottom).offset(Vrange(40));
        make.width.mas_equalTo(Width - 20);
    }];
    [downLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    
}

- (void)changeAction{
//    [self.navigationController pushViewController:[EmailNumberViewController new] animated:YES];
    
    [GiFHUD showWithOverlay];
    AFHTTPSessionManager *manager  =[[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sendChangeEmailStep1Email?email=%@&pid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"],[Hekr sharedInstance].pid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"邮件验证链接已经发送至您的登录邮箱:\n%@\n请点击邮箱内链接，并通过邮件验证",nil),[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"]];
        
        [self showOneActionAlertWithTitle:@"邮箱验证" msg:str actionText:@"确定" actionCallback:^(UIAlertAction * _Nonnull action) {
            [[Hekr sharedInstance] logout];
            if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:HekrSDKUserChangeNotification object:nil];
            }
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];

        if ([APIError(error) isEqualToString:@"0"]) {
            [self.view.window makeToast:NSLocalizedString(@"邮件发送失败", nil) duration:1.0 position:@"center"];
        }else{
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
        }
        
        
    }];
    
    
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
