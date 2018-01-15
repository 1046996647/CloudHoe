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
#import <UMSocialCore/UMSocialCore.h>


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
    
    //带动画结果在切换tabBar的时候viewController会有闪动的效果不建议这样写
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
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
        
        [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
    }
}

- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        self.nickname = resp.originalResponse[@"nickname"];
        
        NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
        
        [paramDic  setValue:resp.uid forKey:@"wechat"];
        [paramDic  setValue:@"WeChat" forKey:@"LoginMode"];
        [paramDic  setValue:self.nickname forKey:@"nikename"];
//        [paramDic  setValue:[InfoCache unarchiveObjectWithFile:@"pushToken"] forKey:@"deviceToken"];
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
    }];
}



@end
