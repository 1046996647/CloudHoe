//
//  LoginMainViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "LoginMainViewController.h"
#import "HekrAPI.h"
#import "AppDelegate.h"
#import "Tool.h"
#import "SocialView.h"
#import "GiFHUD.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "PINGViewController.h"

@interface LoginMainViewController ()<SocialDelegata>
@property (nonatomic, strong)NSArray *array;
@end

@implementation LoginMainViewController

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUser:) name:HekrSDKUserChangeNotification object:nil];
    _array = @[KeyOfSocialQQ,KeyOfSocialWeixin,KeyOfSocialWeibo,KeyOfSocialFacebook,KeyOfSocialTwitter,KeyOfSocialGoogle];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    [self createViews];
}

-(void) onUser:(id)note{
    if([[Hekr sharedInstance] user]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"Login"];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Login"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)createViews{
    WS(weakSelf);
    UIImageView *topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_loginMainTop"]];
    [self.view addSubview:topImg];

    UIImageView *clickImg = [[UIImageView alloc] init];
    clickImg.userInteractionEnabled = YES;
//    clickImg.backgroundColor = [UIColor redColor];
    [self.view addSubview:clickImg];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNet)];
    [tgr setNumberOfTapsRequired:5];
    [clickImg addGestureRecognizer:tgr];
    
    
    UIButton *login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = getButtonBackgroundColor();
    login.layer.cornerRadius = BUTTONRadius;
    [login setTitle:NSLocalizedString(@"登录",nil) forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    UIButton *regist = [UIButton buttonWithType:UIButtonTypeCustom];
    regist.backgroundColor = [UIColor whiteColor];
    regist.layer.cornerRadius = BUTTONRadius;
    regist.layer.masksToBounds = YES;
    regist.layer.borderWidth = 1;
    regist.layer.borderColor = [getButtonBackgroundColor() CGColor];
    [regist setTitle:NSLocalizedString(@"注册",nil) forState:UIControlStateNormal];
    [regist setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [regist addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regist];
    
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(login.mas_top).offset(-loginVrange(89));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(sHrange(284), sHrange(197)));
    }];
    
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-loginVrange(252));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, loginVrange(40)));
    }];
    
    [regist mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(login.mas_bottom).offset(loginVrange(20));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.equalTo(login);
    }];
    
    NSDictionary *profile = [Tool getProfileJsonData];
    if ([profile objectForKey:@"Social"]) {
        SocialView *socialView = [[SocialView alloc] init];
        
        UIView *tmpCustomView = [[[NSBundle mainBundle] loadNibNamed:@"SocialView" owner:self options:nil] objectAtIndex:0];
        socialView = (SocialView *)tmpCustomView;
        socialView.delegate = self;
        [self.view addSubview:tmpCustomView];
        
        [socialView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view.mas_bottom);
            make.left.equalTo(weakSelf.view.mas_left);
            make.size.mas_equalTo(CGSizeMake(Width, loginVrange(142)));
        }];
    }
    
}

- (void)registAction{
    [self.navigationController pushViewController:[RegistViewController new] animated:YES];
}

- (void)loginAction{
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

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

- (void)showNet{
    [self.navigationController pushViewController:[PINGViewController new] animated:YES];
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
