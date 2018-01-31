//
//  SoftAPGuideViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/31.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "SoftAPGuideViewController.h"
#import "CategoryControl.h"
#import "ConfigWorkViewController.h"

@interface SoftAPGuideViewController ()
@property (nonatomic ,weak) IBOutlet PressButton *ensureButton;
@property (nonatomic ,weak) IBOutlet UILabel *step1Label;
@property (nonatomic ,weak) IBOutlet UILabel *step2Label;
@property (nonatomic ,weak) IBOutlet UILabel *bandLabel;
@property (nonatomic ,weak) IBOutlet UILabel *hintLabel;
@property (nonatomic ,weak) IBOutlet UIImageView *guideImageView;

@property (nonatomic ,assign) ConfigDeviceType configType;
@property (nonatomic ,copy) NSString *pinCode;
@property (nonatomic ,copy) NSString *ssid;
@property (nonatomic ,copy) NSString *pwd;
@property (nonatomic ,assign) BOOL config;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveTopContraint;

@end

@implementation SoftAPGuideViewController

-(void)setConfigType:(ConfigDeviceType )type ssid:(NSString *)ssid password:(NSString *)pwd pinCode:(NSString *)pin{
    _configType = type;
    _ssid = ssid;
    _pwd = pwd;
    _pinCode = pin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"兼容模式";
    [self initNavView];
    _step1Label.text = NSLocalizedString(@"1. 请将手机连接到如图所示的Wi-Fi网络", nil);
    _step2Label.text = NSLocalizedString(@"2. 返回本应用继续添加设备", nil);
    _hintLabel.text = NSLocalizedString(@" （如您无法找到对应网络，请重新进行配网）", nil);

    _bandLabel.text = NSLocalizedString(@"仅支持2.4G Wi-Fi网络", nil);
    
    _guideImageView.image = [UIImage imageNamed:isEN()?@"system_wifi_en":@"system_wifi"];
    _moveTopContraint.constant = StatusBarAndNavBarHeight;

    _config = NO;
    
    [self refreshSSID];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:@"HEKRchangeNet" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:@"HEKRchangeNet" object:nil];
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //    [MobClick beginLogPageView:@"Config"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    //    [MobClick endLogPageView:@"Config"];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshSSID{
    //SmartDevice_
    if ([getWifiName() hasPrefix:@"SmartDevice-"]) {
        _config = YES;
        [_ensureButton setTitle:NSLocalizedString(@"添加", nil) forState:UIControlStateNormal];
    }else{
        _config = NO;
        [_ensureButton setTitle:NSLocalizedString(@"去连接", nil) forState:UIControlStateNormal];
    }
}

-(IBAction)selectButton:(id)sender{
    if (_config) {
        ConfigWorkViewController *configDevVC = [[ConfigWorkViewController alloc] initWithNibName:@"ConfigWorkViewController" bundle:nil];
        [configDevVC setConfigType:ConfigDeviceTypeSoftAP ssid:_ssid password:_pwd pinCode:_pinCode];
        [self.navigationController pushViewController:configDevVC animated:YES];
        
    }else{
        NSString * urlString = @"App-Prefs:root=WIFI";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        }
    }
}

@end
