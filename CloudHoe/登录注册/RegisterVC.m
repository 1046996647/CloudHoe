//
//  PhoneLoginVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "RegisterVC.h"
#import "RegexTool.h"
#import "AppDelegate.h"
#import "ImageVerView.h"
#import "HekrAPI.h"
//#import "PhoneLoginVC.h"

#define kCountDownForVerifyCode @"CountDownForVerifyCode"


@interface RegisterVC ()<ImageVerViewDelegate>

@property(nonatomic,strong) UITextField *phone;
@property(nonatomic,strong) UITextField *vericate;
@property(nonatomic,strong) UITextField *password;
@property (nonatomic, strong) UIButton *countDownButton;
@property (nonatomic, strong)ImageVerView *imageVerView;


@end

@implementation RegisterVC

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
    _vericate = [UITextField textFieldWithframe:CGRectMake(_phone.left, _phone.bottom, _phone.width, _phone.height) placeholder:@"请输入验证码" font:nil leftView:imgView2 backgroundColor:@"#FFFFFF"];
    _vericate.layer.cornerRadius = 7;
    //    [tf addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventEditingChanged];
    _vericate.layer.masksToBounds = YES;
    [self.view addSubview:_vericate];
    _vericate.rightViewMode = UITextFieldViewModeAlways;
    _vericate.rightView = rightBtn;

    [_vericate setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_vericate setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    _vericate.keyboardType = UIKeyboardTypeNumberPad;
    
    line = [[UIView alloc] init];
    line.frame = CGRectMake(20, _vericate.height-.5, kScreenWidth-40, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"#A9B0BA"];
    [_vericate addSubview:line];
    
    // 密码
    UIImageView *imgView3 = [UIImageView imgViewWithframe:CGRectMake(0, 0, 20, 50) icon:@""];
    
    _password = [UITextField textFieldWithframe:CGRectMake(0, _vericate.bottom, kScreenWidth, imgView3.height) placeholder:@"请输入密码" font:nil leftView:imgView3 backgroundColor:@"#FFFFFF"];
//    _password.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_password];
    _password.rightViewMode = UITextFieldViewModeAlways;
    [_password setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_password setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, _password.bottom+20, kScreenWidth-40, 44) text:@"注册" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    
    //倒计时通知事件
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(countDownUpdate:) name:@"CountDownUpdate" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registAction
{
    [self.view endEditing:YES];
    
    if (self.phone.text.length == 0||
        self.password.text.length == 0||
        self.vericate.text.length == 0) {
        [self.view makeToast:@"您还有内容未填写完整"];
        return;
    }
    
    if (_vericate.text.length >= 6) {
        if (!validatePassWord(_password.text)) {
            [self.view.window makeToast:@"密码在6-30位，由数字、字母或符号组成" duration:1.0 position:@"center"];
            return;
        }

        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        
        [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/checkVerifyCode?phoneNumber=%@&code=%@",_phone.text,_vericate.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[校验短信验证码]：%@",responseObject);
            NSDictionary *dic = responseObject;
            [self onRegister:dic[@"token"]];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:@"验证码错误" duration:1.0 position:@"center"];

            }else{
                [self.view.window makeToast:APIError(error) duration:1.0 position:@"center"];

            }
        }];
        
    }else{
        
        [self.view.window makeToast:@"请输入正确的验证码" duration:1.0 position:@"center"];

    }
    

}


- (void)getCodeAction
{
    [self.view endEditing:YES];
    
    if (![RegexTool checkPhone:self.phone.text]) {
        [self.view makeToast:@"无效的手机号"];
        return;
    }
    
    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];
}

- (void)getSMS:(NSString *)captchaToken{

    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    
    [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=register&token=%@",_phone.text,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
            
            [self.view.window makeToast:@"该手机号已经注册" duration:1.0 position:@"center"];

//            [self showAlertNoMsgWithTitle:@"该手机号已经注册，是否直接登录？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
////                LoginViewController *loginView = [[LoginViewController alloc]init];
////                loginView.userNumber = _userNumTf.text;
////                [self.navigationController pushViewController:loginView animated:YES];
//            }];
        }else if((APIErrorCode(error) == 400016)||(APIErrorCode(error) == 3400005)){
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

- (void)onRegister:(NSString *)token{
    
    if (validatePassWord(_password.text)) {

        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager POST:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/register?type=phone"] parameters:@{@"pid":[Hekr sharedInstance].pid,@"password":_password.text,@"phoneNumber":_phone.text,@"token":token} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[手机号注册]：%@",responseObject);
            
            [InfoCache archiveObject:_phone.text toFile:@"phone"];
            //        [self.navigationController popViewControllerAnimated:YES];

            //            UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"注册成功,请登录",nil)];
            //            [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
            //                LoginViewController *loginView = [[LoginViewController alloc]init];
            //                loginView.userNumber = _userNumTf.text;
            //                [self.navigationController pushViewController:loginView animated:YES];
            //
            //            }];
            //            [alert show];
//            [self showAlertPromptWithTitle:@"注册成功,请登录" actionCallback:^(UIAlertAction * _Nonnull action) {
//
//
////                PhoneLoginVC *vc = [[PhoneLoginVC alloc]init];
////                [self.navigationController pushViewController:vc animated:YES];
//            }];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginNotification" object:nil];
            [self.navigationController popViewControllerAnimated:YES];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            
            if ((APIErrorCode(error) == 400016) || (APIErrorCode(error) == 3400012) || (APIErrorCode(error) == 3400014)){
                
                [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
                
            }else if ((APIErrorCode(error) == 3400001) || (APIErrorCode(error) == 3400002) || (APIErrorCode(error) == 3400003) || (APIErrorCode(error) == 3400010) || (APIErrorCode(error) == 3400011)) {

            }else{
                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"注册失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
            }
            
        }];
    }else{
        
        [self.view.window makeToast:NSLocalizedString(@"密码在6-30位，由数字、字母或符号组成", nil) duration:1.0 position:@"center"];


    }
    
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
