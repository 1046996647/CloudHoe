    //
//  SideViewController.m
//  HekrSDKAPP
//
//  Created by Mike on 16/2/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SideViewController.h"
#import <HekrSDK.h>
#import <HekrAPI.h>
#import <UIImageView+WebCache.h>
#import "ConfigurationNetController.h"
#import "DeviceManageViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#import "AboutHekrViewController.h"
#import "DevicesViewController.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#import "StatusBar.h"
#import "UserDetailedViewController.h"
#import "SettingsViewController.h"
#import "SafetyQuestionViewController.h"
#import "changeThemeViewController.h"
@implementation MainContainer

-(UIStatusBarStyle) preferredStatusBarStyle{
    
   
    return UIStatusBarStyleDefault;
}
@end

@implementation SideMenuController
-(void) toggleLeftMenu:(id) sender{
    
  
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [self showHideLeftViewAnimated:YES completionHandler:^{
        
      
    }];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    
}
@end

@interface SideViewController ()<SideViewSubViewDelegate>
@property (nonatomic, strong) UIImageView * userLogo;
@property (nonatomic, strong) UIImageView * bgImg;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) SideViewSubView *homeView;
@property (nonatomic, strong) SideViewSubView *managementView;
@property (nonatomic, strong) SideViewSubView *changeThemeView;
@property (nonatomic, strong) SideViewSubView *settingView;
@end

@implementation SideViewController
{
    NSDictionary *_dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self onUserChange];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self onUserChange];
    if (_bgImg) {
        self.bgImg.image = [UIImage imageNamed:getSideBgImg()];
    }
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createViews{
    _bgImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:getSideBgImg()]];
    [self.view addSubview:_bgImg];
    
    UIImageView *bgVague = [UIImageView new];
    bgVague.backgroundColor = [UIColor blackColor];
    bgVague.alpha = 0.3;
    [self.view addSubview:bgVague];
    
    _userLogo = [UIImageView new];
    _userLogo.image = [UIImage imageNamed:@"icon_user_default"];
    _userLogo.layer.cornerRadius = Vrange(70);
    _userLogo.clipsToBounds = YES;
    _userLogo.layer.masksToBounds = YES;
    _userLogo.layer.borderWidth = 2;
    _userLogo.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_userLogo];
    
    _userName = [UILabel new];
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont systemFontOfSize:15];
    _userName.text = NSLocalizedString(@"游客", nil);
    [self.view addSubview:_userName];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    WS(weakSelf);
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [bgVague mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [_userLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(Hrange(60));
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(160));
        make.size.mas_equalTo(CGSizeMake(Vrange(140), Vrange(140)));
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userLogo.mas_right).offset(10);
        make.centerY.equalTo(_userLogo.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(_userLogo.mas_top);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(_userLogo.mas_bottom);
    }];
    
    _homeView = [[SideViewSubView alloc]initWithFrame:CGRectMake(0, Vrange(576), Width, Vrange(128)) andImg:[UIImage imageNamed:@"mainpage"] andTitle:NSLocalizedString(@"主页", nil)];
    _homeView.delegate = self;
    [self.view addSubview:_homeView];
    
    _managementView = [[SideViewSubView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_homeView.frame), Width, Vrange(128)) andImg:[UIImage imageNamed:@"device-management"] andTitle:NSLocalizedString(@"设备管理", nil)];
    _managementView.delegate = self;
    [self.view addSubview:_managementView];
    
    NSDictionary *profile = [Tool getJsonDataFromFile:@"profile.json"];
    NSString *Theme = [profile objectForKey:@"Theme"];
    if (Theme&&Theme.length>0) {
        _settingView = [[SideViewSubView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_managementView.frame), Width, Vrange(128)) andImg:[UIImage imageNamed:@"side_setting"] andTitle:NSLocalizedString(@"系统设置", nil)];
        _settingView.delegate = self;
        [self.view addSubview:_settingView];
    }else{
        _changeThemeView = [[SideViewSubView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_managementView.frame), Width, Vrange(128)) andImg:[UIImage imageNamed:@"side_theme"] andTitle:NSLocalizedString(@"主题换肤", nil)];
        _changeThemeView.delegate = self;
        [self.view addSubview:_changeThemeView];
        
        _settingView = [[SideViewSubView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_changeThemeView.frame), Width, Vrange(128)) andImg:[UIImage imageNamed:@"side_setting"] andTitle:NSLocalizedString(@"系统设置", nil)];
        _settingView.delegate = self;
        [self.view addSubview:_settingView];
    }
}

- (void)clickFrom:(NSString *)string{
    if ([string isEqualToString:NSLocalizedString(@"主页", nil)]) {
        [self closeAction];
    }else if ([string isEqualToString:NSLocalizedString(@"设备管理", nil)]){
        [self onDeviceManage];
    }else if ([string isEqualToString:NSLocalizedString(@"系统设置", nil)]){
        [self onSetting];
    }else if ([string isEqualToString:NSLocalizedString(@"主题换肤", nil)]){
        [self onChangeTheme];
    }
}

- (void) onUserChange{
    if ([Hekr sharedInstance].user) {
        self.userLogo.image = [UIImage imageNamed:@"icon_user_default"];
        self.userName.text = NSLocalizedString(@"游客", nil);
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:@"http://user.openapi.hekr.me/user/profile" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[获取个人信息]：%@",responseObject);
            _dataDic = responseObject;
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"kHekrUserProfile"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            if (([responseObject[@"phoneNumber"] length]>0 && ![responseObject[@"phoneNumber"] isKindOfClass:[NSNull class]])&&![responseObject[@"isSecurity"] boolValue]) {
//                NSString *safety = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrSafety%@",[Hekr sharedInstance].user.uid]];
//                if (!safety) {
//                    [[NSUserDefaults standardUserDefaults] setObject:[Hekr sharedInstance].user.uid forKey:[NSString stringWithFormat:@"HekrSafety%@",[Hekr sharedInstance].user.uid]];
//                    SafetyQuestionViewController *safetyView = [[SafetyQuestionViewController alloc]initWithIsOne:YES Num:nil Title:NSLocalizedString(@"密保问题", nil) ViewType:setSafetyQuestion];
//                    [self presentViewController:safetyView animated:YES completion:nil];
//                }
//            }

            [self refreshUserPage];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if((_dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"])){
                [self refreshUserPage];
            }
        }];
    }
}

- (void)refreshUserPage{
    NSString *number = _dataDic[@"phoneNumber"];
    if (number.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isPhone"];
        [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"phoneNumber"] forKey:@"UserNumber"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isPhone"];
        [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"email"] forKey:@"UserNumber"];
    }
    
    if (_dataDic[@"avatarUrl"] && ![_dataDic[@"avatarUrl"] isKindOfClass:[NSNull class]]) {
        NSString *smallimage = _dataDic[@"avatarUrl"][@"small"];
        [_userLogo sd_setImageWithURL:[NSURL URLWithString:smallimage] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
        
    }
    
    if (_dataDic[@"lastName"] && ![_dataDic[@"lastName"] isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:_dataDic[@"lastName"] forKey:@"UserName"];
        _userName.text = _dataDic[@"lastName"];
    }
}

-(void) onUser:(id)sender{
    
//    [[[sender view] subviews][1] setBackgroundColor:[UIColor redColor]];
//    [[[sender view] subviews][1] setOpaque:YES];
    
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    if((_dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"])){
        if ([_dataDic[@"phoneNumber"] length]>0 && ![_dataDic[@"phoneNumber"] isKindOfClass:[NSNull class]]) {
            [TheAPPDelegate.rootNav pushViewController:[[UserViewController alloc] initWithShowSafety:YES] animated:YES];
        }else{
            [TheAPPDelegate.rootNav pushViewController:[[UserViewController alloc] initWithShowSafety:NO] animated:YES];
        }
    }else{
        [TheAPPDelegate.rootNav pushViewController:[[UserViewController alloc] initWithShowSafety:NO] animated:YES];
    }
    
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    
}
-(void) onDeviceManage{
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
        [TheAPPDelegate.rootNav pushViewController:[DeviceManageViewController new] animated:YES];
        [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
}
-(void) onSetting{
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController pushViewController:[SettingsViewController new] animated:YES];
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
    
}

- (void)onChangeTheme{
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController pushViewController:[changeThemeViewController new] animated:YES];
    [self performSelector:@selector(hideLeftView) withObject:nil afterDelay:0.5];
}

- (void)closeAction{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDelegate.side hideLeftViewAnimated:YES completionHandler:nil];
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}

- (void)hideLeftView{
    [TheAPPDelegate.side hideLeftViewAnimated:NO completionHandler:nil];
    
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
    
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

@interface SideViewSubView ()
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *viewTtitle;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end

@implementation SideViewSubView
- (instancetype)initWithFrame:(CGRect)frame andImg:(UIImage *)viewImg andTitle:(NSString *)viewTitle{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _image = viewImg;
        _viewTtitle = viewTitle;
        [self createViews];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [button addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)createViews{
    _imageView = [[UIImageView alloc]initWithImage:_image];
    [self addSubview:_imageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.text = _viewTtitle;
    [self addSubview:_titleLabel];
    
    WS(weakSelf);
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(Hrange(60));
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Vrange(50), Vrange(50)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right).offset(Hrange(44));
        make.centerY.equalTo(_imageView.mas_centerY);
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
}

- (void)clickAction{
    [self.delegate clickFrom:_viewTtitle];
}


@end

