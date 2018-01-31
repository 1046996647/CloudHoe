//
//  ResetPassWordForPhoneViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ResetPassWordForPhoneViewController.h"
#import "Tool.h"
#import <HekrAPI.h>
#import <Masonry.h>
#import "LoginViewController.h"
#import "GiFHUD.h"


@interface ResetPassWordForPhoneViewController ()
@property (nonatomic, copy)NSString *token;
@property (nonatomic, copy)NSString *num;
@property (nonatomic, strong)UITextField *passWordTextField;
@property (nonatomic, strong)UITextField *verPassWordTextField;
@property (nonatomic, strong)UILabel *hintLabel;
@property (nonatomic, assign)BOOL isSafety;
@end

@implementation ResetPassWordForPhoneViewController

- (instancetype)initWithToken:(NSString *)token Num:(NSString *)num isSafety:(BOOL)isSafety{
    self = [super init];
    if (self) {
        _token = token;
        _num = num;
        _isSafety = isSafety;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createViews];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"忘记密码" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIView *upView = [UIView new];
    upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upView];
    
    UIView *downView = [UIView new];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    _passWordTextField = [UITextField new];
    _passWordTextField.placeholder = NSLocalizedString(@"新密码", nil);
    _passWordTextField.font = [UIFont systemFontOfSize:16];
    [_passWordTextField setSecureTextEntry:YES];
    [self.view addSubview:_passWordTextField];
    
    _verPassWordTextField = [UITextField new];
    _verPassWordTextField.placeholder = NSLocalizedString(@"确认新密码", nil);
    _verPassWordTextField.font = [UIFont systemFontOfSize:16];
    [_verPassWordTextField setSecureTextEntry:YES];
    [self.view addSubview:_verPassWordTextField];
    
    UIButton *eyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [eyeBtn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    [eyeBtn addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eyeBtn];
    
    UIButton *tureBtn = [UIButton buttonWithTitle:NSLocalizedString(@"确定", nil) frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(tureAction)];
    [self.view addSubview:tureBtn];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    [self.view addSubview:_hintLabel];
    
    WS(weakSelf);
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(32)+StatusBarAndNavBarHeight);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_bottom).offset(1);
        make.left.equalTo(upView.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [_passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_top);
        make.left.equalTo(upView.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width-Vrange(100)-Hrange(32), Vrange(100)));
    }];
    
    [_verPassWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top);
        make.left.equalTo(downView.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width-Vrange(100)-Hrange(32), Vrange(100)));
    }];
    
    [eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(upView.mas_top);
        make.right.equalTo(upView.mas_right);
        make.size.mas_equalTo(CGSizeMake(Vrange(100), Vrange(100)));
    }];
    
    [tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(downView.mas_bottom).offset(Vrange(350)+BUTTONHEIGHT/2);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, BUTTONHEIGHT));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_bottom).offset(5);
        make.left.equalTo(_verPassWordTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width - Hrange(64), 35));
    }];
    
}

- (void)tureAction{
    if (!validatePassWord(_passWordTextField.text)) {
        _hintLabel.text = NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成", nil);
        return;
    }
    if (![_passWordTextField.text isEqualToString:_verPassWordTextField.text]) {
        _hintLabel.text = NSLocalizedString(@"新密码输入不一致，请重新输入", nil);
        return;
    }
    _hintLabel.text = @"";
    
    if (_isSafety == YES) {
        //根据密保问题重置密码
        NSDictionary *dic = @{@"token":_token,@"pid":[Hekr sharedInstance].pid,@"password":_passWordTextField.text};
        [GiFHUD showWithOverlay];
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa.openapi.hekr.me/resetPassword?type=security" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[使用密保问题重置密码]：%@",responseObject);
            [GiFHUD dismiss];
            [self.delegate resetPassWordForPhoneDelegateAction:_num];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"密码修改失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }];
    }else{
        [GiFHUD showWithOverlay];
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager POST:@"http://uaa.openapi.hekr.me/resetPassword?type=phone" parameters:@{@"phoneNumber":_num,@"verifyCode":_token,@"pid":[Hekr sharedInstance].pid,@"password":_passWordTextField.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[使用手机号重置密码]：%@",responseObject);
            [GiFHUD dismiss];
            [self.delegate resetPassWordForPhoneDelegateAction:_num];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
            
            
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

- (void)showPassWord:(UIButton *)btn{
    if (_passWordTextField.secureTextEntry == YES) {
        _passWordTextField.secureTextEntry = NO;
        _verPassWordTextField.secureTextEntry = NO;
        [btn setImage:[UIImage imageNamed:@"ic_eyeopen"] forState:UIControlStateNormal];
    }else{
        _passWordTextField.secureTextEntry = YES;
        _verPassWordTextField.secureTextEntry = YES;
        [btn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self resignFirst];
}

- (void)resignFirst{
    if ([_verPassWordTextField isFirstResponder]) {
        [_verPassWordTextField resignFirstResponder];
    }
    if ([_passWordTextField isFirstResponder]) {
        [_passWordTextField resignFirstResponder];
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
