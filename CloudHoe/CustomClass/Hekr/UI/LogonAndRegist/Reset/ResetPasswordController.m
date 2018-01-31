//
//  ResetPasswordController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ResetPasswordController.h"
#import <AFNetworking.h>
#import "ResetEmailViewController.h"
#import "ResetPhoneViewController.h"
#import <HekrAPI.h>
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
#import "ImageVerView.h"
#import "UpdataEmailViewController.h"
#import "ResetVerViewController.h"

//#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@interface ResetPasswordController ()<ResetVerViewControllerDelegate>
@property (nonatomic, strong)ImageVerView *imageVerView;
@end

@implementation ResetPasswordController
{
    UIView *_numView;
    UITextField *_num;
    UIButton *_nextBtn;
    UILabel *_hintLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"ResetPassWord"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"ResetPassWord"];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
//    640  1136
    CGFloat Hgap = (32/640.0)*ScreenWidth;
    CGFloat Vgap = (32/1136.0)*ScreenHeight;
    CGFloat viewHeight = (100/1136.0)*ScreenHeight;
    CGFloat placeholderAlpha = 0.56;
    _numView = [[UIView alloc]initWithFrame:CGRectMake(0, Vgap+64, ScreenWidth, viewHeight)];
    _numView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_numView];
//    UILabel *uplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_numView.frame)-1, ScreenWidth, 1)];
//    uplabel.backgroundColor = rgb(199, 199, 199);
//    [self.view addSubview:uplabel];
//    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_numView.frame), ScreenWidth, 1)];
//    downLabel.backgroundColor = rgb(199, 199, 199);
//    [self.view addSubview:downLabel];
    
    _num = [[UITextField alloc]initWithFrame:CGRectMake(Hgap, 0, ScreenWidth-(2*Hgap), viewHeight)];
    _num.backgroundColor = [UIColor clearColor];
    _num.placeholder = NSLocalizedString(@"邮箱 / 手机号", nil);
    [_num setValue:rgb(51, 51, 51) forKeyPath:@"_placeholderLabel.textColor"];
    [_num setValue:[NSNumber numberWithFloat:placeholderAlpha] forKeyPath:@"_placeholderLabel.alpha"];
    [_numView addSubview:_num];
    
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hgap, CGRectGetMaxY(_numView.frame), Width - 2*Hgap, 36)];
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    _hintLabel.numberOfLines = 0;
    [self.view addSubview:_hintLabel];
    
    _nextBtn = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(nextAction)];
    _nextBtn.center = CGPointMake(Width/2, CGRectGetMaxY(_numView.frame)+Vrange(210)+BUTTONHEIGHT/2);
    [self.view addSubview:_nextBtn];
}

- (void)nextAction{
    if ([_num isFirstResponder]) {
        [_num resignFirstResponder];
    }
    _hintLabel.text = @"";
    if (validateEmail(_num.text)) {
        
//        [self.navigationController pushViewController:[ResetEmailViewController new] animated:YES];
        [GiFHUD showWithOverlay];
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sendResetPasswordEmail?email=%@&pid=%@",_num.text,[Hekr sharedInstance].pid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            DDLogInfo(@"[获取重置密码邮件]：%@",responseObject);
            UpdataEmailViewController *emailView = [[UpdataEmailViewController alloc]initWithEmil:_num.text NavTitle:NSLocalizedString(@"忘记密码", nil) isUpData:NO];
            [self.navigationController pushViewController:emailView animated:YES];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //@"请核对邮箱账号"
            [GiFHUD dismiss];
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"邮件发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
            
        }];
    }else if (validateMobile(_num.text)){
        [GiFHUD showWithOverlay];
        NSString *str = [NSString stringWithFormat:@"http://uaa.openapi.hekr.me/isSecurityAccount?phoneNumber=%@&pid=%@",_num.text,[Hekr sharedInstance].pid];
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            if ([responseObject[@"result"] boolValue]) {
                ResetVerViewController *verView = [[ResetVerViewController alloc]initWithPhoneNum:_num.text isHaveSecurity:YES];
                verView.delegate = self;
                [self.navigationController pushViewController:verView animated:YES];
            }else{
                ResetVerViewController *verView = [[ResetVerViewController alloc]initWithPhoneNum:_num.text isHaveSecurity:NO];
                verView.delegate = self;
                [self.navigationController pushViewController:verView animated:YES];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            if (APIErrorCode(error) == 3400011) {
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                return;
            }
            ResetVerViewController *verView = [[ResetVerViewController alloc]initWithPhoneNum:_num.text isHaveSecurity:NO];
            verView.delegate = self;
            [self.navigationController pushViewController:verView animated:YES];
        }];
        
    }else{
        _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号", nil);
    }
}

- (void)resetVerViewControllerAction:(NSString *)num{
    [self.delegate PassingOnUserNum:num];
}

- (void)PassingOnUser:(NSString *)num{
    [self.delegate PassingOnUserNum:num];
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
