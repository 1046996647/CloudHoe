//
//  LoginViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "LoginViewController.h"
#import "Tool.h"
#import "LoginMainViewController.h"
#import "SocialView.h"
#import "HekrAPI.h"
#import "GiFHUD.h"
#import "ResetPasswordController.h"
#import <SHAlertViewBlocks.h>
#import "RegistViewController.h"

@interface LoginViewController ()<SocialDelegata, UITextFieldDelegate, ResetPasswordDelegate>
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
@property (nonatomic, strong)UIButton *loginBtn;
@property (nonatomic, strong)UILabel *resetPassWordLabel;
@property (nonatomic, strong)UILabel *hintLabel;
@property (nonatomic, strong)UIImageView *shadeImg;
@property (nonatomic, strong)SocialView *socialView;
@property (nonatomic, strong)NSArray *array;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _array = @[KeyOfSocialQQ,KeyOfSocialWeixin,KeyOfSocialWeibo,KeyOfSocialFacebook,KeyOfSocialTwitter,KeyOfSocialGoogle];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    [self createViews];
    
    self.title = @"邮箱/手机号登录";
    [self initNavView];
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[RegistViewController class]]) {
            [arr removeObject:controller];
        }
    }
    self.navigationController.viewControllers = arr;
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
//    _backLabel.text = NSLocalizedString(@"邮箱/手机号登录",nil);
//    _backLabel.textColor = UIColorFromHex(0x06a4f0);
//    _backLabel.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:_backLabel];
    
//    _backView = [UIView new];
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popLoginMainView)];
//    [_backView addGestureRecognizer:tgr];
//    [self.view addSubview:_backView];
    
    UILabel *bgLabel = [UILabel new];
    bgLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgLabel];

    
    _userImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_user_nom"]];
    [self.view addSubview:_userImg];
    
    _userNumTf = [UITextField new];
    _userNumTf.placeholder = NSLocalizedString(@"邮箱 / 手机号", nil);
    _userNumTf.font = [UIFont systemFontOfSize:15];
    _userNumTf.textColor = UIColorFromHex(0x4a4a4a);
//    [_userNumTf setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"_placeholderLabel.alpha"];
    [_userNumTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _userNumTf.delegate = self;
    if (_userNumber) {
        _userNumTf.text = _userNumber;
    }else if([[NSUserDefaults standardUserDefaults] objectForKey:@"LOGINUSERNUM"]){
        _userNumTf.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGINUSERNUM"];
    }else{
        [_userNumTf becomeFirstResponder];
    }
    [self.view addSubview:_userNumTf];
    
    _userLabel = [UILabel new];
    _userLabel.backgroundColor = UIColorFromHex(0xdfdfdf);
    [self.view addSubview:_userLabel];
    
    _passWordImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_password_nom"]];
    [self.view addSubview:_passWordImg];
    
    _passWordTf = [UITextField new];
    _passWordTf.placeholder = NSLocalizedString(@"请输入您的密码", nil);
    _passWordTf.font = [UIFont systemFontOfSize:15];
    [_passWordTf setSecureTextEntry:YES];
    _passWordTf.textColor = UIColorFromHex(0x4a4a4a);
//    [_passWordTf setValue:[NSNumber numberWithFloat:0.8] forKeyPath:@"_placeholderLabel.alpha"];
    [_passWordTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
    _passWordTf.delegate = self;
    if (_userNumTf.text.length > 0) {
        [_passWordTf becomeFirstResponder];
    }
    [self.view addSubview:_passWordTf];
    
    _showPassWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showPassWordBtn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    [_showPassWordBtn setImageEdgeInsets:UIEdgeInsetsMake(sVrange(10), sHrange(10), sVrange(10), sHrange(10))];
    [_showPassWordBtn addTarget:self action:@selector(showPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showPassWordBtn];
    
//    _passWordLabel = [UILabel new];
//    _passWordLabel.backgroundColor = UIColorFromHex(0xdadada);
//    [self.view addSubview:_passWordLabel];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
//    _hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_hintLabel];
    
//    _shadeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shade"]];
//    [self.view addSubview:_shadeImg];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = getButtonBackgroundColor();
    _loginBtn.layer.cornerRadius = BUTTONRadius;
    [_loginBtn setTitle:NSLocalizedString(@"登录",nil) forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_loginBtn];
    
    _resetPassWordLabel = [UILabel new];
    _resetPassWordLabel.textAlignment = NSTextAlignmentCenter;
    _resetPassWordLabel.text = NSLocalizedString(@"忘记密码", nil);
    _resetPassWordLabel.textColor = UIColorFromHex(0xFC4049);
    _resetPassWordLabel.font = [UIFont systemFontOfSize:13];
    _resetPassWordLabel.userInteractionEnabled = YES;
    [self.view addSubview:_resetPassWordLabel];
    UITapGestureRecognizer *tgrRester = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushResetView)];
    [_resetPassWordLabel addGestureRecognizer:tgrRester];
    
//    _socialView = [[SocialView alloc] init];
//    UIView *tmpCustomView = [[[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil] objectAtIndex:0];
//    _socialView = (SocialView *)tmpCustomView;
//    _socialView.delegate = self;
//    [self.view addSubview:_socialView];
    
    
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

    [bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(StatusBarAndNavBarHeight+10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, sVrange(110)));
    }];
    
    [_showPassWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.passWordTf.mas_centerY);
        make.right.equalTo(bgLabel.mas_right).offset(-sHrange(20));
        make.size.mas_equalTo(CGSizeMake(sHrange(50), sVrange(40)));
    }];
    
    [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgLabel.mas_centerY);
        make.left.equalTo(bgLabel.mas_left).offset(sHrange(15));
        make.size.mas_equalTo(CGSizeMake(sHrange(360), 0.5));
    }];
    
    [_userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgLabel.mas_left).offset(sHrange(30));
        make.centerY.equalTo(weakSelf.userNumTf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(sHrange(16), sHrange(18)));
    }];
    
    [_userNumTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgLabel.mas_top);
        make.left.equalTo(weakSelf.userImg.mas_right).offset(sHrange(24));
//        make.right.equalTo(weakSelf.showPassWordBtn.mas_left).offset(-sHrange(10));
//        make.size.height.mas_equalTo(sVrange(55));
        make.size.mas_equalTo(CGSizeMake(sHrange(250), sVrange(55)));
    }];
    
//    [_passWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_userLabel.mas_bottom).offset(sVrange(46));
//        make.left.equalTo(_userImg.mas_left);
//        make.size.mas_equalTo(CGSizeMake(sHrange(273), 0.5));
//    }];
    
    [_passWordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgLabel.mas_left).offset(sHrange(30));
        make.centerY.equalTo(weakSelf.passWordTf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(sHrange(16), sHrange(23)));
    }];
    
    [_passWordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgLabel.mas_bottom);
        make.left.equalTo(weakSelf.passWordImg.mas_right).offset(sHrange(24));
//        make.right.equalTo(weakSelf.showPassWordBtn.mas_left).offset(-sHrange(10));
//        make.size.height.mas_equalTo(sVrange(55));
        make.size.mas_equalTo(CGSizeMake(sHrange(250), sVrange(55)));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgLabel.mas_bottom);
        make.centerX.equalTo(bgLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(315), sVrange(46)));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgLabel.mas_bottom).offset(sVrange(46));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, sVrange(40)));
    }];
    
//    [_shadeImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_loginBtn.mas_bottom).offset(-sVrange(21)/2);
//        make.left.equalTo(_loginBtn.mas_left).offset(sVrange(20));
//        make.size.mas_equalTo(CGSizeMake(sHrange(191), sVrange(21)));
//    }];
    
    [_resetPassWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(sVrange(21));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
//    [_socialView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.view.mas_bottom);
//        make.left.equalTo(weakSelf.view.mas_left);
//        make.size.mas_equalTo(CGSizeMake(Width, sVrange(130)));
//    }];
    
}

- (void)popLoginMainView{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LoginMainViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
}

#pragma mark ---------- 登录
- (void)loginAction{
    _loginBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _loginBtn.userInteractionEnabled = YES;
    });
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
    }
    if (_userNumTf.text.length==0 || _passWordTf.text.length == 0) {
        _hintLabel.text = NSLocalizedString(@"请输入账号和密码",nil);
//        [self.delegate loginAlert:NSLocalizedString(@"请输入账号和密码",nil)];
    }else if(_passWordTf.text.length < 6){
        _hintLabel.text = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成",nil);
//        [self.delegate loginAlert:NSLocalizedString(@"请确认密码至少六位",nil)];
    }else if(!(validateMobile(_userNumTf.text) || validateEmail(_userNumTf.text))){
        _hintLabel.text = NSLocalizedString(@"请输入正确的手机号码或邮箱账号",nil);
    }else{
        _hintLabel.text = @"";
        [MobClick event:@"HekrLogin"];
        [GiFHUD showWithOverlay];
        [[Hekr sharedInstance] login:_userNumTf.text password:_passWordTf.text callbcak:^(id user, NSError *error) {
            if(user){
                DDLogInfo(@"%@",user);
                [GiFHUD dismiss];
                [[NSUserDefaults standardUserDefaults] setObject:_userNumTf.text forKey:@"LOGINUSERNUM"];
//                [self.delegate onlogined:user];
            }
            if (error) {
                [GiFHUD dismiss];
                
                if (APIErrorCode(error) == 3400009) {
                    [self loginDisable:_userNumTf.text];
                }else{
                    if ((APIErrorCode(error) == 400016) || (APIErrorCode(error) == 3400012) || (APIErrorCode(error) == 3400014)){
                        [self showAlertPromptWithTitle:APIError(error) actionCallback:nil];
                    }else if ((APIErrorCode(error) == 3400001) || (APIErrorCode(error) == 3400002) || (APIErrorCode(error) == 3400003) || (APIErrorCode(error) == 3400010) || (APIErrorCode(error) == 3400011)) {
                        _hintLabel.text = APIError(error);
                    }else{
                        if ([APIError(error) isEqualToString:@"0"]) {
                            [self.view.window makeToast:NSLocalizedString(@"登录失败", nil) duration:1.0 position:@"center"];
                        }else{
                            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                        }   
                    }
//                    [self.delegate loginAlert:APIError(error)];
                }
                
                
            }
        }];
    }
}

- (void)loginDisable:(NSString *)num{
    
    [self showAlertNoTitleWithMsg:@"该邮箱未激活，请至邮箱激活该邮箱地址，是否需要重新发送激活邮件" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/resendVerifiedEmail?email=%@&pid=%@",num,[Hekr sharedInstance].pid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[重新发送激活邮件]：%@",responseObject);
            
            [self showOneActionAlertWithTitle:@"邮件已发送" msg:@"验证邮件已发送至注册邮箱，点击邮件中的链接完成激活操作" actionText:@"我知道了" actionCallback:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"邮件发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }];
    }];
    
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

#pragma mark ---------- 忘记密码
- (void)pushResetView{
    ResetPasswordController *resetPassWordView = [ResetPasswordController new];
    resetPassWordView.delegate = self;
    [self.navigationController pushViewController:resetPassWordView animated:YES];
}

#pragma mark ---------- UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _userNumTf) {
        //_userLabel.backgroundColor = getButtonBackgroundColor();
        //_userImg.image = [UIImage imageNamed:@"login_user_se"];
//        [_userNumTf setValue:getButtonBackgroundColor() forKeyPath:@"_placeholderLabel.textColor"];
//        _userNumTf.textColor = getButtonBackgroundColor();
    }else if (textField == _passWordTf){
        //_passWordLabel.backgroundColor = getButtonBackgroundColor();
//        [_passWordTf setValue:getButtonBackgroundColor() forKeyPath:@"_placeholderLabel.textColor"];
        //_passWordImg.image = [UIImage imageNamed:@"login_password_se"];
//        _passWordTf.textColor = getButtonBackgroundColor();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _userNumTf) {
        //_userLabel.backgroundColor = UIColorFromHex(0x4a4a4a);
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
//        [_passWordTf setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
//        _passWordTf.textColor = UIColorFromHex(0x4a4a4a);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _userNumTf){
        [_passWordTf becomeFirstResponder];
    }else{
        [self loginAction];
    }
    return YES;
}

- (void)PassingOnUserNum:(NSString *)num{
//    _userNumber = num;
    _userNumTf.text = num;
}

- (void)setUserNumber:(NSString *)userNumber{
    _userNumber = userNumber;
//    _userNumTf.text = userNumber;
}

#pragma mark ---------- 第三方登录

- (void)socialLoginAction:(UIButton *)btn{
    NSInteger index = btn.tag - 2001;
    [MobClick event:@"SSOLogin"];
    NSString *type=_array[index];
    [[Hekr sharedInstance] sso:type controller:self.view.window.rootViewController ssoType:HekrSSOLogin anonymous:YES callback:^(id user, id token, NSError * error) {
        if ([[token objectForKey:@"status"] isEqualToString:@"star"]) {
            [GiFHUD showWithOverlay];
            return;
        }
        [GiFHUD dismiss];
        if(user) return;
        [self.view.window makeToast:NSLocalizedString(@"授权失败", nil) duration:1.0 position:@"center"];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_userNumTf isFirstResponder]) {
        [_userNumTf resignFirstResponder];
    }else if ([_passWordTf isFirstResponder]){
        [_passWordTf resignFirstResponder];
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
