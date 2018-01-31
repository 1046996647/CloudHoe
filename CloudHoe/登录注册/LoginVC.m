//
//  LoginVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneLoginVC.h"
#import "AppDelegate.h"
//#import <UMSocialCore/UMSocialCore.h>
#import "HekrAPI.h"


@interface LoginVC ()

@property(nonatomic,strong) NSString *nickname;



@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imgView = [UIImageView imgViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight) icon:@"1-登录1"];
    [self.view addSubview:imgView];
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(60, 476*scaleWidth, kScreenWidth-120, 44) text:@"手机登录" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#50DBD1" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 0;

    
    UIButton *loginBtn1 = [UIButton buttonWithframe:CGRectMake(loginBtn.left, loginBtn.bottom+15, loginBtn.width, loginBtn.height) text:@"微信登录" font:[UIFont systemFontOfSize:16] textColor:@"#50DBD1" backgroundColor:@"" normal:nil selected:nil];
    loginBtn1.layer.cornerRadius = loginBtn1.height/2;
    loginBtn1.layer.masksToBounds = YES;
    loginBtn1.layer.borderWidth = 1;
    loginBtn1.layer.borderColor = [UIColor colorWithHexString:@"#50DBD1"].CGColor;
    [self.view addSubview:loginBtn1];
    [loginBtn1 addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn1.tag = 1;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:@"Login"];

    //带动画结果在切换tabBar的时候viewController会有闪动的效果不建议这样写
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick endLogPageView:@"Login"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        
        PhoneLoginVC *vc = [[PhoneLoginVC alloc] init];
        vc.title = @"手机登录";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        
//        AppDelegate *delegate = [AppDelegate share];
//        TabBarController *tabVC = [[TabBarController alloc] init];
//        delegate.tabVC = tabVC;
//        delegate.window.rootViewController = tabVC;
        
//        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
        [self socialLoginAction];
    }
}

- (void)socialLoginAction{
    [MobClick event:@"SSOLogin"];
//    NSString *type=_array[index];//Weixin
    [[Hekr sharedInstance] sso:@"Weixin" controller:self.view.window.rootViewController ssoType:HekrSSOLogin anonymous:YES callback:^(id user, id token, NSError * error) {
        if ([[token objectForKey:@"status"] isEqualToString:@"star"]) {
//            [GiFHUD showWithOverlay];
            return;
        }
        
//        [GiFHUD dismiss];
        if (user) {
            
            [self onUserChange];
            return;
        }
            
        [self.view.window makeToast:NSLocalizedString(@"授权失败", nil) duration:1.0 position:@"center"];
    }];
    
}

- (void) onUserChange{
    if ([Hekr sharedInstance].user) {

        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:@"http://user.openapi.hekr.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[获取个人信息]：%@",responseObject);
            
            NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
            
            [paramDic  setValue:responseObject[@"uid"] forKey:@"wechat"];
            [paramDic  setValue:responseObject[@"name"] forKey:@"nikename"];
            [paramDic  setValue:@"WeChat" forKey:@"LoginMode"];
            [paramDic  setValue:[InfoCache unarchiveObjectWithFile:@"clientId"] forKey:@"cid"];
            //        [paramDic  setValue:@"ios" forKey:@"deviceType"];
            
            
            [AFNetworking_RequestData requestMethodPOSTUrl:Login dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
                
                [InfoCache saveValue:@1 forKey:@"LoginedState"];
                
                [InfoCache archiveObject:responseObject[@"data"][@"Token"] toFile:@"Token"];
                [InfoCache archiveObject:responseObject[@"data"][@"userId"] toFile:@"userId"];
                
                AppDelegate *delegate = [AppDelegate share];
                TabBarController *tabVC = [[TabBarController alloc] init];
                delegate.tabVC = tabVC;
                delegate.window.rootViewController = tabVC;
                
                
            } failure:^(NSError *error) {
                
            }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
    }
}




@end
