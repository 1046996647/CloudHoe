//
//  RegistViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "RegistViewController.h"
#import "Tool.h"
#import "LoginMainViewController.h"
#import "ImageVerView.h"
#import <AFNetworking.h>
#import "HekrAPI.h"
#import <SHAlertViewBlocks.h>
#import "LoginViewController.h"
#import "GiFHUD.h"
#import "Tool.h"
#import "ReadWebViewController.h"

#define sHrange(x)  (x/375.0)*ScreenWidth
#define sVrange(x)  (x/667.0)*ScreenHeight
@interface RegistViewController ()<UITextFieldDelegate,ImageVerViewDelegate>
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UIButton *backBtn;
@property (nonatomic, strong)UILabel *backLabel;
@property (nonatomic, strong)UIImageView *userImg;
@property (nonatomic, strong)UITextField *userNumTf;
@property (nonatomic, strong)UILabel *userLabel;
@property (nonatomic, strong)UIImageView *passWordImg;
@property (nonatomic, strong)UITextField *passWordTf;
@property (nonatomic, strong)UILabel *passWordLabel;
@property (nonatomic, strong)UIButton *showPassWordBtn;
@property (nonatomic, strong)UIButton *registBtn;
@property (nonatomic, strong)UILabel *hintLabel;
@property (nonatomic, strong)UIImageView *shadeImg;
@property (nonatomic, strong)UIView *passWordView;
@property (nonatomic, strong)UIImageView *verImg;
@property (nonatomic, strong)UITextField *verTf;
@property (nonatomic, strong)UILabel *verLabel;
@property (nonatomic, strong)UIButton *verBtn;
@property (nonatomic, strong)UIView *verView;
@property (nonatomic, strong)UILabel *protocolLabel;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@property (nonatomic, strong)ImageVerView *imageVerView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger time;
@property (nonatomic, assign)BOOL isPhone;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    _time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    [self createViews];
    
    self.title = @"邮箱/手机号注册";
    [self initNavView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)createViews{
//    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_backBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
//    [self.view addSubview:_backBtn];
//    
//    _backLabel = [UILabel new];
//    _backLabel.text = NSLocalizedString(@"邮箱/手机号注册",nil);
//    _backLabel.textColor = UIColorFromHex(0x06a4f0);
//    _backLabel.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:_backLabel];
    
//    _backView = [UIView new];
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popLoginMainView)];
//    [_backView addGestureRecognizer:tgr];
//    [self.view addSubview:_backView];
    
    UILabel *userBgLabel = [UILabel new];
    userBgLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userBgLabel];
    
    _userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user_nom"]];
    [self.view addSubview:_userImg];
    
    _userNumTf = [UITextField new];
    _userNumTf.placeholder = NSLocalizedString(@"邮箱 / 手机号", nil);
    _userNumTf.font = [UIFont systemFontOfSize:15];
    _userNumTf.textColor = UIColorFromHex(0x4a4a4a);
    [_userNumTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [_userNumTf setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"_placeholderLabel.alpha"];
    [_userNumTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _userNumTf.delegate = self;
    [self.view addSubview:_userNumTf];
    
    _userLabel = [UILabel new];
    _userLabel.backgroundColor = UIColorFromHex(0xdfdfdf);
    [self.view addSubview:_userLabel];
    
    _verView = [UIView new];
    _verView.alpha = 0;
    _verView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_verView];
    
    _verImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_ver_nom"]];
    [_verView addSubview:_verImg];
    
    _verTf = [UITextField new];
    _verTf.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _verTf.font = [UIFont systemFontOfSize:15];
    _verTf.textColor = UIColorFromHex(0x4a4a4a);
//    [_verTf setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"_placeholderLabel.alpha"];
    [_verTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _verTf.delegate = self;
    [_verView addSubview:_verTf];
    
    _verLabel = [UILabel new];
    _verLabel.backgroundColor = UIColorFromHex(0xdfdfdf);
    [_verView addSubview:_verLabel];
    
    _verBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_verBtn addTarget:self action:@selector(getVerCode) forControlEvents:UIControlEventTouchUpInside];
    _verBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_verView addSubview:_verBtn];
    
    _passWordView = [UIView new];
    [self.view addSubview:_passWordView];
    
    UILabel *pwdBgLabel = [UILabel new];
    pwdBgLabel.backgroundColor = [UIColor whiteColor];
    [_passWordView addSubview:pwdBgLabel];
    
    _passWordImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password_nom"]];
    [_passWordView addSubview:_passWordImg];
    
    _passWordTf = [UITextField new];
    _passWordTf.placeholder = NSLocalizedString(@"请输入您的密码",  nil);
    _passWordTf.font = [UIFont systemFontOfSize:15];
    [_passWordTf setSecureTextEntry:YES];
    _passWordTf.textColor = UIColorFromHex(0x4a4a4a);
    [_passWordTf setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"_placeholderLabel.alpha"];
    [_passWordTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordTf.delegate = self;
    [_passWordView addSubview:_passWordTf];
    
    _showPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPassWordBtn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    [_showPassWordBtn setImageEdgeInsets:UIEdgeInsetsMake(sVrange(10), sHrange(10), sVrange(10), sHrange(10))];
    [_showPassWordBtn addTarget:self action:@selector(showPassWord) forControlEvents:UIControlEventTouchUpInside];
    [_passWordView addSubview:_showPassWordBtn];
    
//    _passWordLabel = [UILabel new];
//    _passWordLabel.backgroundColor = UIColorFromHex(0x4a4a4a);
//    [_passWordView addSubview:_passWordLabel];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    [_passWordView addSubview:_hintLabel];
    
//    _shadeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shade"]];
//    [_passWordView addSubview:_shadeImg];
    
    _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registBtn.backgroundColor = getButtonBackgroundColor();
    _registBtn.layer.cornerRadius = BUTTONRadius;
    [_registBtn setTitle:NSLocalizedString(@"注册",nil) forState:UIControlStateNormal];
    [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    _registBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_passWordView addSubview:_registBtn];
    
    _protocolLabel = [UILabel new];
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    _protocolLabel.textColor = UIColorFromHex(0x999999);

    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"我已阅读并同意氦氪用户协议",nil)];
    NSRange contentRange;
    if ([lang() isEqualToString:@"en-US"]) {
        contentRange = NSMakeRange(23, 24);
    }else{
        contentRange = NSMakeRange(7, 6);
    }
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSUnderlineColorAttributeName value:UIColorFromHex(0xFC4049) range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0xFC4049) range:contentRange];

    _protocolLabel.attributedText = content;
    _protocolLabel.font = [UIFont systemFontOfSize:14];
    //        protocol.adjustsFontSizeToFitWidth = YES;
    _protocolLabel.numberOfLines = 0;
    UITapGestureRecognizer *protocolTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction)];
    [_protocolLabel addGestureRecognizer:protocolTgr];
    _protocolLabel.userInteractionEnabled = YES;
    [_passWordView addSubview:_protocolLabel];
    
//    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).offset(sVrange(35));
//        make.left.equalTo(weakSelf.view.mas_left).offset(sVrange(24));
//        make.size.mas_equalTo(CGSizeMake(sHrange(19), sVrange(15)));
//    }];
//    
//    [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_backBtn.mas_top).offset(-1);
//        make.left.equalTo(_backBtn.mas_right).offset(sHrange(10));
//        make.size.mas_equalTo(CGSizeMake(200, sVrange(15)+2));
//    }];
    
//    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view.mas_top).offset(20);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.size.mas_equalTo(CGSizeMake(sHrange(45), sVrange(40)));
//    }];
    
    WS(weakSelf);
    
    [userBgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(StatusBarAndNavBarHeight+10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, sVrange(55)));
    }];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(userBgLabel.mas_bottom);
        make.left.equalTo(userBgLabel.mas_left).offset(sHrange(15));
        make.size.mas_equalTo(CGSizeMake(sHrange(360), 0.5));
    }];
    
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userBgLabel.mas_left).offset(sHrange(30));
        make.centerY.equalTo(userBgLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(sHrange(16), sHrange(18)));
    }];
    
    [_userNumTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userBgLabel.mas_top);
        make.left.equalTo(weakSelf.userImg.mas_right).offset(sHrange(24));
        make.size.mas_equalTo(CGSizeMake(sHrange(250), sVrange(55)));
    }];
    
    [_verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userBgLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, sVrange(55)));
    }];
    
    [_verLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.verView.mas_bottom);
        make.left.equalTo(weakSelf.verView.mas_left).offset(sHrange(15));
        make.size.mas_equalTo(CGSizeMake(sHrange(360), 0.5));
    }];
    
    [_verImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.verView.mas_left).offset(sHrange(30));
        make.centerY.equalTo(weakSelf.verView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(sHrange(16), sHrange(20)));
    }];
    
    [_verTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.verView.mas_top);
        make.left.equalTo(weakSelf.verImg.mas_right).offset(sHrange(24));
        make.size.mas_equalTo(CGSizeMake(sHrange(210), sVrange(55)));
    }];
    
    [_verBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_verView.mas_centerY);
        make.right.equalTo(_verView.mas_right).offset(-sVrange(20));
        make.size.mas_equalTo(CGSizeMake(sHrange(80), sVrange(30)));
    }];
    
    [_passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userLabel.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, sVrange(185)+55));
    }];
    
    [pwdBgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passWordView.mas_top);
        make.left.equalTo(weakSelf.passWordView.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, sVrange(55)));
    }];
    
//    [_passWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_passWordView.mas_top).offset(sVrange(46));
//        make.centerX.equalTo(_verView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(sHrange(273), 0.5));
//    }];
    
    [_passWordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.passWordView.mas_left).offset(sHrange(30));
        make.centerY.equalTo(weakSelf.passWordTf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(sHrange(16), sHrange(23)));
    }];
    
    [_passWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passWordView.mas_top);
        make.left.equalTo(weakSelf.passWordImg.mas_right).offset(sHrange(24));
//        make.right.equalTo(weakSelf.showPassWordBtn.mas_left).offset(-sHrange(10));
//        make.size.height.mas_equalTo(sVrange(55));
        make.size.mas_equalTo(CGSizeMake(sHrange(250), sVrange(55)));
    }];
    
    [_showPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.passWordTf.mas_centerY);
        make.right.equalTo(weakSelf.passWordView.mas_right).offset(-sHrange(20));
        make.size.mas_equalTo(CGSizeMake(sHrange(50), sVrange(40)));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdBgLabel.mas_bottom);
        make.centerX.equalTo(weakSelf.passWordView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(315), sVrange(46)));
    }];
    
    [_registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pwdBgLabel.mas_bottom).offset(sVrange(46));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, sVrange(40)));
    }];
    
//    [_shadeImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_registBtn.mas_bottom).offset(-sVrange(21)/2);
//        make.left.equalTo(_registBtn.mas_left).offset(sVrange(20));
//        make.size.mas_equalTo(CGSizeMake(sHrange(191), sVrange(21)));
//    }];
    
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registBtn.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 35));
    }];
}

- (void)popLoginMainView{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LoginMainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

#pragma mark ---------- 注册

- (void)registAction{
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
    }else if ([_verTf isFirstResponder]){
        [_verTf resignFirstResponder];
    }
    _registBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _registBtn.userInteractionEnabled = YES;
    });
    if (_isPhone) {
        if (_verTf.text.length >= 6) {
            if (!validatePassWord(_passWordTf.text)) {
                NSString *str = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
                _hintLabel.text = str;
                return;
            }
            _hintLabel.text = @"";
            [GiFHUD showWithOverlay];
            AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
            
            [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/checkVerifyCode?phoneNumber=%@&code=%@",_userNumTf.text,_verTf.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DDLogInfo(@"[校验短信验证码]：%@",responseObject);
                NSDictionary *dic = responseObject;
                [self onRegister:dic[@"token"]];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GiFHUD dismiss];
                if ([APIError(error) isEqualToString:@"0"]) {
                    _hintLabel.text = NSLocalizedString(@"验证码错误",nil);
                }else{
                    _hintLabel.text = APIError(error);
                }
        }];
        }else{
            _hintLabel.text = NSLocalizedString(@"请输入正确的验证码", nil);
        }
    }else if (validateEmail(_userNumTf.text)){
        
        if (validatePassWord(_passWordTf.text)) {
            _hintLabel.text = @"";
            [GiFHUD showWithOverlay];
            AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
            [manager POST:@"http://uaa.openapi.hekr.me/register?type=email" parameters:@{@"pid":[Hekr sharedInstance].pid,@"password":_passWordTf.text,@"email":_userNumTf.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DDLogInfo(@"[使用邮箱注册]：%@",responseObject);
                [GiFHUD dismiss];
//                UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"邮件已发送",nil) withMessage:NSLocalizedString(@"验证邮件已发送至注册邮箱，点击邮件中的链接完成激活操作",nil)];
//                [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
//                    LoginViewController *loginView = [[LoginViewController alloc]init];
//                    loginView.userNumber = _userNumTf.text;
//                    [self.navigationController pushViewController:loginView animated:YES];
//                }];
//                [alert show];
                
                [self showOneActionAlertWithTitle:@"邮件已发送" msg:@"验证邮件已发送至注册邮箱，点击邮件中的链接完成激活操作" actionText:@"我知道了" actionCallback:^(UIAlertAction * _Nonnull action) {
                    LoginViewController *loginView = [[LoginViewController alloc]init];
                    loginView.userNumber = _userNumTf.text;
                    [self.navigationController pushViewController:loginView animated:YES];
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GiFHUD dismiss];
                if (APIErrorCode(error) == 3400008) {
//                    UIAlertView *alert1=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"该邮箱已经注册，是否直接登录？",nil)];
//                    [alert1 addButtonWithTitle:NSLocalizedString(@"取消", nil)];
//                    [alert1 SH_addButtonWithTitle:NSLocalizedString(@"确定", nil) withBlock:^(NSInteger theButtonIndex) {
//                        LoginViewController *loginView = [[LoginViewController alloc]init];
//                        loginView.userNumber = _userNumTf.text;
//                        [self.navigationController pushViewController:loginView animated:YES];
//                    }];
//                    [alert1 show];
                    
                    [self showAlertNoMsgWithTitle:@"该邮箱已经注册，是否直接登录？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
                        LoginViewController *loginView = [[LoginViewController alloc]init];
                        loginView.userNumber = _userNumTf.text;
                        [self.navigationController pushViewController:loginView animated:YES];
                    }];
                    
                }else{
                    
                    if ([APIError(error) isEqualToString:@"0"]) {
                        [self.view.window makeToast:NSLocalizedString(@"邮件发送失败", nil) duration:1.0 position:@"center"];
                    }else{
                        [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                    }

                }
                
            }];
            
        }else{
            NSString *str = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
            _hintLabel.text = str;
        }
    }else{
        _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号",nil);
    }

}

- (void)onRegister:(NSString *)token{
    
    if (validatePassWord(_passWordTf.text)) {
        _hintLabel.text = @"";
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager POST:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/register?type=phone"] parameters:@{@"pid":[Hekr sharedInstance].pid,@"password":_passWordTf.text,@"phoneNumber":_userNumTf.text,@"token":token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[手机号注册]：%@",responseObject);
            //        [self.navigationController popViewControllerAnimated:YES];
            [GiFHUD dismiss];
//            UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"注册成功,请登录",nil)];
//            [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
//                LoginViewController *loginView = [[LoginViewController alloc]init];
//                loginView.userNumber = _userNumTf.text;
//                [self.navigationController pushViewController:loginView animated:YES];
//                
//            }];
//            [alert show];
            [self showAlertPromptWithTitle:@"注册成功,请登录" actionCallback:^(UIAlertAction * _Nonnull action) {
                LoginViewController *loginView = [[LoginViewController alloc]init];
                loginView.userNumber = _userNumTf.text;
                [self.navigationController pushViewController:loginView animated:YES];
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            
            if ((APIErrorCode(error) == 400016) || (APIErrorCode(error) == 3400012) || (APIErrorCode(error) == 3400014)){
                
                [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
                
            }else if ((APIErrorCode(error) == 3400001) || (APIErrorCode(error) == 3400002) || (APIErrorCode(error) == 3400003) || (APIErrorCode(error) == 3400010) || (APIErrorCode(error) == 3400011)) {
                _hintLabel.text = APIError(error);
            }else{
                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"注册失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
            }
            
        }];
    }else{
        [GiFHUD dismiss];
        NSString *str = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
        _hintLabel.text = str;
    }
    
}


#pragma mark ---------- 获取验证码
- (void)getVerCode{
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
    }else if ([_verTf isFirstResponder]){
        [_verTf resignFirstResponder];
    }
    
    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];
}

- (void)getSMS:(NSString *)captchaToken{
    [self.view resignFirstResponder];
    [_timer setFireDate:[NSDate distantPast]];
    _verBtn.titleLabel.adjustsFontSizeToFitWidth = NO;
    _verBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_verBtn setTitle:@"59" forState:UIControlStateNormal];
    [_verBtn setTitleColor:UIColorFromHex(0xdadada) forState:UIControlStateNormal];
    _verBtn.userInteractionEnabled = NO;
    
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    
    [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=register&token=%@",_userNumTf.text,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[获取短信验证码]：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (APIErrorCode(error) == 3400008) {
//            UIAlertView *alert1=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"该手机号已经注册，是否直接登录？", nil)];
//            [alert1 addButtonWithTitle:NSLocalizedString(@"取消", nil)];
//            [alert1 SH_addButtonWithTitle:NSLocalizedString(@"确定", nil) withBlock:^(NSInteger theButtonIndex) {
//                if (theButtonIndex==1) {
//                    LoginViewController *loginView = [[LoginViewController alloc]init];
//                    loginView.userNumber = _userNumTf.text;
//                    [self.navigationController pushViewController:loginView animated:YES];
//                }
//            }];
//            [alert1 show];
            [self showAlertNoMsgWithTitle:@"该手机号已经注册，是否直接登录？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
                LoginViewController *loginView = [[LoginViewController alloc]init];
                loginView.userNumber = _userNumTf.text;
                [self.navigationController pushViewController:loginView animated:YES];
            }];
        }else if((APIErrorCode(error) == 400016)||(APIErrorCode(error) == 3400005)){
            [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
        }else{
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"短信发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }
        [_timer setFireDate:[NSDate distantFuture]];
        _verBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
        _verBtn.userInteractionEnabled = YES;
        _time = 60;
    }];
    
}
#pragma mark ---------- 定时器
- (void)timerAction{
    if ([_verBtn.titleLabel.text isEqualToString:@"0s"]) {
        [_timer setFireDate:[NSDate distantFuture]];
        _verBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
        _verBtn.userInteractionEnabled = YES;
        
        _time = 60;
        return;
    }
    _time--;
    [_verBtn setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
}

#pragma mark ---------- 显示密码
- (void)showPassWord{
    if (_passWordTf.secureTextEntry == YES) {
        [_passWordTf setSecureTextEntry:NO];
        [_showPassWordBtn setImage:[UIImage imageNamed:@"ic_eyeopen"] forState:UIControlStateNormal];
    }else{
        [_passWordTf setSecureTextEntry:YES];
        [_showPassWordBtn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    }
}


#pragma mark ---------- UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _userNumTf) {
        //_userLabel.backgroundColor = getButtonBackgroundColor();
//        _userImg.image = [UIImage imageNamed:@"login_user_se"];
//        [_userNumTf setValue:getButtonBackgroundColor() forKeyPath:@"_placeholderLabel.textColor"];
//        _userNumTf.textColor = getButtonBackgroundColor();
    }else if (textField == _passWordTf){
        //_passWordLabel.backgroundColor = getButtonBackgroundColor();
//        [_passWordTf setValue:getButtonBackgroundColor() forKeyPath:@"_placeholderLabel.textColor"];
//        _passWordImg.image = [UIImage imageNamed:@"login_password_se"];
//        _passWordTf.textColor = getButtonBackgroundColor();
    }else if (textField == _verTf){
        //_verLabel.backgroundColor = getButtonBackgroundColor();
//        [_verTf setValue:getButtonBackgroundColor() forKeyPath:@"_placeholderLabel.textColor"];
//        _verImg.image = [UIImage imageNamed:@"login_ver_se"];
//        _verTf.textColor = getButtonBackgroundColor();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userNumTf) {
        //_userLabel.backgroundColor = UIColorFromHex(0x4a4a4a);
//        _userImg.image = [UIImage imageNamed:@"login_user_nom"];
//        [_userNumTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
//        _userNumTf.textColor = UIColorFromHex(0x4a4a4a);
        if (!validateEmail(_userNumTf.text) && !validateMobile(_userNumTf.text)) {
            _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号",nil);
        }else{
            _hintLabel.text = @"";
        }
    }else if (textField == _passWordTf){
        //_passWordLabel.backgroundColor = UIColorFromHex(0x4a4a4a);
//        _passWordImg.image = [UIImage imageNamed:@"login_password_nom"];
//        [_passWordTf setValue:UIColorFromHex(0x4a4a4a) forKeyPath:@"_placeholderLabel.textColor"];
//        _passWordTf.textColor = UIColorFromHex(0x4a4a4a);
    }else if (textField == _verTf){
       //_verLabel.backgroundColor = UIColorFromHex(0x4a4a4a);
//        _verImg.image = [UIImage imageNamed:@"login_ver_nom"];
//        [_verTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
//        _verTf.textColor = UIColorFromHex(0x4a4a4a);
    }
}

//判断是手机或邮箱
- (void) textFieldDidChange:(id) sender {
    UITextField *_field = (UITextField *)sender;
    NSString *str = [_field text];
    
    if (validateMobile(str)) {
        _isPhone = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _verView.alpha = 1;
            _passWordView.transform = CGAffineTransformMakeTranslation(0, sVrange(55));
        }];
    }else {
        _isPhone = NO;
        if (_verView.alpha > 0){
            [UIView animateWithDuration:0.5 animations:^{
                _verView.alpha = 0;
                _passWordView.transform = CGAffineTransformIdentity;
            }];
        }
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _userNumTf){
        if (_isPhone == YES) {
            [_verTf becomeFirstResponder];
        }else{
            [_passWordTf becomeFirstResponder];
        }
    }else if(textField == _verTf){
        [_passWordTf becomeFirstResponder];
    }else if (textField == _passWordTf){
        [self registAction];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
    }else if ([_verTf isFirstResponder]){
        [_verTf resignFirstResponder];
    }
}

- (void)protocolAction{
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
    }else if ([_verTf isFirstResponder]){
        [_verTf resignFirstResponder];
    }
    NSString *url = [NSString stringWithFormat:@"http://app.hekr.me/FAQ/user_protocol.html?lang=%@",lang()];
    ReadWebViewController *readWebVC = [[ReadWebViewController alloc] initWithTitle:NSLocalizedString(@"用户协议", nil) url:url];
    [self.navigationController pushViewController:readWebVC animated:YES];
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
