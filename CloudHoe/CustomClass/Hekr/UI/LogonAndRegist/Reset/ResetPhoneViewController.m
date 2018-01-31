//
//  ResetPhoneViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ResetPhoneViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
//#import "LoginController.h"
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
#import "ImageVerView.h"
#import "LoginViewController.h"
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
@interface ResetPhoneViewController ()<ImageVerViewDelegate>
@property (nonatomic, strong)ImageVerView *imageVerView;
@end

@implementation ResetPhoneViewController
{
    UIButton *_verButton;
    UITextField *_ver;
    UITextField *_passWord;
    NSTimer *_timer;
    NSInteger _time;
    NSString *_num;
    UILabel *_hintLabel;
}

- (instancetype)initWithNumber:(NSString *)number{
    self = [super init];
    if (self) {
        _num = number;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    _time = 60;
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"ResetPassWord-Phone"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ResetPassWord-Phone"];
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
    CGFloat viewheight = (88/1136.0)*ScreenHeight;
    CGFloat Hgap = (40/640.0)*ScreenWidth;
    CGFloat Vgap = (72/1136.0)*ScreenHeight;
    CGFloat placeholderAlpha = 0.56;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
    
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, Vgap+64, ScreenWidth, viewheight)];
    upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upView];
    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(0, Vgap+viewheight, ScreenWidth, viewheight)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
//    上边线
    UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(upView.frame)-1, ScreenWidth, 1)];
    upLabel.backgroundColor = rgb(199, 199, 199);
    [self.view addSubview:upLabel];
//    下边线
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downView.frame), ScreenWidth, 1)];
    downLabel.backgroundColor = rgb(199, 199, 199);
    [self.view addSubview:downLabel];
    
    _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hgap, CGRectGetMaxY(downLabel.frame), Width - 2*Hgap, 36)];
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    _hintLabel.numberOfLines = 0;
    [self.view addSubview:_hintLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(Hgap, CGRectGetMaxY(downLabel.frame)+36, ScreenWidth-(2*Hgap), Vgap);
    btn.backgroundColor = rgb(6, 164, 240);
    btn.layer.cornerRadius = Vgap/2;
    [btn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _ver = [[UITextField alloc]initWithFrame:CGRectMake(Hgap, 0, 200, viewheight)];
    _ver.backgroundColor = [UIColor clearColor];
    _ver.placeholder = NSLocalizedString(@"验证码", nil);
    [_ver setValue:rgb(51, 51, 51) forKeyPath:@"_placeholderLabel.textColor"];
    [_ver setValue:[NSNumber numberWithFloat:placeholderAlpha] forKeyPath:@"_placeholderLabel.alpha"];
    [upView addSubview:_ver];
    
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(Hgap, 0, ScreenWidth-Hgap, viewheight)];
    [_passWord setSecureTextEntry:YES];
    _passWord.backgroundColor = [UIColor clearColor];
    _passWord.placeholder = NSLocalizedString(@"新密码（至少六位）", nil);
    [_passWord setValue:rgb(51, 51, 51) forKeyPath:@"_placeholderLabel.textColor"];
    [_passWord setValue:[NSNumber numberWithFloat:placeholderAlpha] forKeyPath:@"_placeholderLabel.alpha"];
    [downView addSubview:_passWord];
    
    _verButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verButton.frame = CGRectMake(ScreenWidth-Hgap-120, 0, 120, viewheight);
    _verButton.backgroundColor = [UIColor clearColor];
    _verButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_verButton setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
    [_verButton setTitleColor:rgb(51, 51, 51) forState:UIControlStateNormal];
    _verButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _verButton.alpha = 0.56;
    _verButton.userInteractionEnabled = NO;
    [_verButton addTarget:self action:@selector(verAction:) forControlEvents:UIControlEventTouchUpInside];
    [upView addSubview:_verButton];
    
    UILabel *cenLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hgap, CGRectGetMaxY(upView.frame)-0.5, ScreenWidth-Hgap, 1)];
    cenLabel.backgroundColor = rgb(199, 199, 199);
    [self.view addSubview:cenLabel];
}

- (void)timerAction{
    if ([_verButton.titleLabel.text isEqualToString:@"0s"]) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_verButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
//        [_verButton setTitleColor:rgb(189, 211, 228) forState:UIControlStateNormal];
        _verButton.userInteractionEnabled = YES;
        _verButton.alpha = 1;
        _time = 60;
        return;
    }
    _time--;
    [_verButton setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
}

- (void)verAction:(UIButton *)btn{
    
    
    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];
    
    
    
}

- (void)getSMS:(NSString *)captchaToken{
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=resetPassword&token=%@",_num,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[获取重置密码短信]：%@",responseObject);
        [_timer setFireDate:[NSDate distantPast]];
        [_verButton setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
        //    [btn setTitleColor:rgb(189, 211, 228) forState:UIControlStateNormal];
        _verButton.alpha = 0.56;
        _verButton.userInteractionEnabled = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if((APIErrorCode(error) == 400016)||(APIErrorCode(error) == 3400005)){
            [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
        }else{
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"短信发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }
    }];

}


- (void)btnAction{
    if ([_ver isFirstResponder]) {
        [_ver resignFirstResponder];
    }else if([_passWord isFirstResponder]){
        [_passWord resignFirstResponder];
    }
    
    if (_ver.text.length==0 || _ver.text.length > 6) {
        _hintLabel.text = NSLocalizedString(@"验证码错误", nil);
    }else if (!validatePassWord(_passWord.text)){
        _hintLabel.text = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成", nil);
        
    }else{
        [GiFHUD showWithOverlay];
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager POST:@"http://uaa.openapi.hekr.me/resetPassword?type=phone" parameters:@{@"phoneNumber":_num,@"verifyCode":_ver.text,@"pid":[Hekr sharedInstance].pid,@"password":_passWord.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[使用手机号重置密码]：%@",responseObject);
            [GiFHUD dismiss];
            DDLogVerbose(@"%@",responseObject);
            
//            UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"修改成功", nil)];
//            [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
//                for (UIViewController *temp in self.navigationController.viewControllers) {
//                    if ([temp isKindOfClass:[LoginViewController class]]) {
//                        [self.delegate PassingOnUser:_num];
//                        [self.navigationController setNavigationBarHidden:YES animated:NO];
//                        [self.navigationController popToViewController:temp animated:YES];
//                    }
//                }
//                
//            }];
//            [alert show];
            
            [self showAlertPromptWithTitle:@"修改成功" actionCallback:^(UIAlertAction * _Nonnull action) {
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[LoginViewController class]]) {
                        [self.delegate PassingOnUser:_num];
//                        [self.navigationController setNavigationBarHidden:YES animated:NO];
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];

            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"密码修改失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
            
        }];
    }
    
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
