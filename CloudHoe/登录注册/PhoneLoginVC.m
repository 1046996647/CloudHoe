//
//  PhoneLoginVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "RegexTool.h"
#import "AppDelegate.h"

#define kCountDownForVerifyCode @"CountDownForVerifyCode"


@interface PhoneLoginVC ()

@property(nonatomic,strong) UITextField *phone;
@property(nonatomic,strong) UITextField *password;
@property (nonatomic, strong) UIButton *countDownButton;

@end

@implementation PhoneLoginVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 手机号
    UIImageView *imgView1 = [UIImageView imgViewWithframe:CGRectMake(0, 0, 20, 50) icon:@""];
    
    _phone = [UITextField textFieldWithframe:CGRectMake(0, 10, kScreenWidth, imgView1.height) placeholder:@"请输入手机号码" font:nil leftView:imgView1 backgroundColor:@"#FFFFFF"];
    _phone.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phone];
    _phone.rightViewMode = UITextFieldViewModeAlways;
    [_phone setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_phone setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(20, _phone.height-.5, kScreenWidth-40, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"#A9B0BA"];
    [_phone addSubview:line];
    
    _phone.text = [InfoCache unarchiveObjectWithFile:@"phone"];
    
    
    // 验证码
    UIImageView *imgView2 = [UIImageView imgViewWithframe:CGRectMake(0, 0, 20, 50) icon:@""];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 110, imgView2.height);
    [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#4588F2"] forState:UIControlStateNormal];
//    rightBtn.backgroundColor = colorWithHexStr(@"#FFE690");
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.countDownButton = rightBtn;
    [self.countDownButton addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    //
    _password = [UITextField textFieldWithframe:CGRectMake(_phone.left, _phone.bottom, _phone.width, _phone.height) placeholder:@"请输入验证码" font:nil leftView:imgView2 backgroundColor:@"#FFFFFF"];
    _password.layer.cornerRadius = 7;
    //    [tf addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventEditingChanged];
    _password.layer.masksToBounds = YES;
    [self.view addSubview:_password];
    _password.rightViewMode = UITextFieldViewModeAlways;
    _password.rightView = rightBtn;

    [_password setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_password setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    _password.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, _password.bottom+20, kScreenWidth-40, 44) text:@"登录" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    //倒计时通知事件
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(countDownUpdate:) name:@"CountDownUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction
{
    [self.view endEditing:YES];
    
    if (self.phone.text.length == 0||
        self.password.text.length == 0) {
        [self.view makeToast:@"您还有内容未填写完整"];
        return;
    }
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [paramDic  setValue:self.phone.text forKey:@"phone"];
    [paramDic  setValue:self.password.text forKey:@"verificationCode"];
    [paramDic  setValue:@"Mail" forKey:@"LoginMode"];
    
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Login dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        
        [InfoCache archiveObject:self.phone.text toFile:@"phone"];
        
        [InfoCache archiveObject:responseObject[@"data"][@"Token"] toFile:@"Token"];
        [InfoCache archiveObject:responseObject[@"data"][@"userId"] toFile:@"userId"];
        
        [InfoCache saveValue:@1 forKey:@"LoginedState"];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        TabBarController *tabVC = [[TabBarController alloc] init];
        delegate.tabVC = tabVC;
        delegate.window.rootViewController = tabVC;
        
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)getCodeAction
{
    [self.view endEditing:YES];
    
    if (![RegexTool checkPhone:self.phone.text]) {
        [self.view makeToast:@"无效的手机号"];
        return;
    }
    
    // 开始计时
    [CountDownServer startCountDown:20 identifier:kCountDownForVerifyCode];
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    [paramDic  setValue:self.phone.text forKey:@"phone"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:GetCode dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {

        NSNumber *code = [responseObject objectForKey:@"httpcode"];
        if (200 == [code integerValue]) {

//            NSString *message = [responseObject objectForKey:@"message"];
            [self.view makeToast:@"验证码发送成功"];

        }


    } failure:^(NSError *error) {

    }];
}

#pragma mark-验证码通知方法
- (void)countDownUpdate:(NSNotification *)noti
{
    NSString *identifier = [noti.userInfo objectForKey:@"CountDownIdentifier"];
    if ([identifier isEqualToString:kCountDownForVerifyCode]) {
        NSNumber *n = [noti.userInfo objectForKey:@"SecondsCountDown"];
        
        [self performSelectorOnMainThread:@selector(updateVerifyCodeCountDown:) withObject:n waitUntilDone:YES];
    }
}

- (void)updateVerifyCodeCountDown:(NSNumber *)num {
    
    if ([num integerValue] == 0){
        
        [self.countDownButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.countDownButton.userInteractionEnabled = YES;
        [self.countDownButton setTitleColor:[UIColor colorWithHexString:@"#4588F2"] forState:UIControlStateNormal];
        
    } else {
        [self.countDownButton setTitle:[NSString stringWithFormat:@"已发送(%@)",num] forState:UIControlStateNormal];
        self.countDownButton.userInteractionEnabled = NO;
        [self.countDownButton setTitleColor:[UIColor colorWithHexString:@"#50DBD1"] forState:UIControlStateNormal];
    }
}
@end
