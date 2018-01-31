//
//  PhoneLoginVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/29.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PhoneLoginVC.h"
#import "AppDelegate.h"
#import "RegisterVC.h"
#import "Tool.h"
#import "HekrAPI.h"


@interface PhoneLoginVC ()

@property(nonatomic,strong) UITextField *phone;
@property(nonatomic,strong) UITextField *vericate;
@property(nonatomic,strong) UITextField *password;

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
    
    
    // 密码
    UIImageView *imgView3 = [UIImageView imgViewWithframe:CGRectMake(0, 0, 20, 50) icon:@""];
    
    _password = [UITextField textFieldWithframe:CGRectMake(0, _phone.bottom, kScreenWidth, imgView3.height) placeholder:@"请输入密码" font:nil leftView:imgView3 backgroundColor:@"#FFFFFF"];
//    _password.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_password];
    _password.rightViewMode = UITextFieldViewModeAlways;
    [_password setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];// 设置这里时searchTF.font也要设置不然会偏上
    [_password setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, _password.bottom+20, kScreenWidth-40, 44) text:@"登录" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 32, 32) text:@"注册" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [viewBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUser:) name:@"kLoginNotification" object:nil];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.phone.text = [InfoCache unarchiveObjectWithFile:@"phone"];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}



//- (void)onUser:(id)note{
//
//    self.phone.text = [InfoCache unarchiveObjectWithFile:@"phone"];
//    [self loginAction];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerAction
{
    RegisterVC *vc = [[RegisterVC alloc] init];
    vc.title = @"注册";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginAction
{
    [self.view endEditing:YES];
    
    if (self.phone.text.length == 0||
        self.password.text.length == 0) {
        [self.view makeToast:@"您还有内容未填写完整"];
        return;
    }
    
    [SVProgressHUD show];
    [MobClick event:@"HekrLogin"];
    [[Hekr sharedInstance] login:_phone.text password:_password.text callbcak:^(id user, NSError *error) {
        if(user){
            DDLogInfo(@"%@",user);

            // 登陆成功
            NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
            
            [paramDic  setValue:self.phone.text forKey:@"phone"];
            [paramDic  setValue:self.password.text forKey:@"pwd"];
            [paramDic  setValue:@"Mail" forKey:@"LoginMode"];
            [paramDic  setValue:[InfoCache unarchiveObjectWithFile:@"clientId"] forKey:@"cid"];
            
            
            [AFNetworking_RequestData requestMethodPOSTUrl:Login dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
                
                [SVProgressHUD dismiss];

                
                [InfoCache archiveObject:self.phone.text toFile:@"phone"];
                
                [InfoCache archiveObject:responseObject[@"data"][@"Token"] toFile:@"Token"];
                [InfoCache archiveObject:responseObject[@"data"][@"userId"] toFile:@"userId"];
                
                [InfoCache saveValue:@1 forKey:@"LoginedState"];
                
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                TabBarController *tabVC = [[TabBarController alloc] init];
                delegate.tabVC = tabVC;
                delegate.window.rootViewController = tabVC;
                
                
            } failure:^(NSError *error) {
                [SVProgressHUD dismiss];

            }];
        }
        if (error) {
            [SVProgressHUD dismiss];

            if (APIErrorCode(error) == 3400009) {

            }else{
                if ((APIErrorCode(error) == 400016) || (APIErrorCode(error) == 3400012) || (APIErrorCode(error) == 3400014)){
                    [self showAlertPromptWithTitle:APIError(error) actionCallback:nil];
                }else if ((APIErrorCode(error) == 3400001) || (APIErrorCode(error) == 3400002) || (APIErrorCode(error) == 3400003) || (APIErrorCode(error) == 3400010) || (APIErrorCode(error) == 3400011)) {
                    [self.view.window makeToast:APIError(error) duration:1.0 position:@"center"];

                }else{
                    if ([APIError(error) isEqualToString:@"0"]) {
                        [self.view.window makeToast:@"登录失败" duration:1.0 position:@"center"];
                    }else{
                        [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                    }
                }
                //                    [self.delegate loginAlert:APIError(error)];
            }
            
            
        }
    }];
    

}





@end
