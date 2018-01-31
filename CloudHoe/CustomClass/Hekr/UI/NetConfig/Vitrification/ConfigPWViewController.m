//
//  ConfigPWViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/28.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigPWViewController.h"
#import "CategoryControl.h"
#import "SoftAPGuideViewController.h"
#import "ConfigWorkViewController.h"
#import "ConfigFailResultViewController.h"
#import "GiFHUD.h"
#import "HekrCacheManager.h"

#define WiFiPwd @"WiFiPwd"

@interface ConfigPWViewController ()

@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveTopContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *descPointContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *widthPointContraint;

@property (nonatomic ,weak) IBOutlet UIImageView *cgImageView;
@property (nonatomic ,weak) IBOutlet UIView *moveView;
@property(nonatomic,weak)IBOutlet UILabel *ssidLabel;
@property(nonatomic,weak)IBOutlet InputTextField *passwordTF;
@property(nonatomic,weak)IBOutlet WordsButton *wifiButton;
@property(nonatomic,weak)IBOutlet PressButton *ensureButton;
@property (nonatomic ,weak) IBOutlet UILabel *bandLabel;
@property (nonatomic ,weak) IBOutlet UILabel *descLabel;

@property (nonatomic ,assign) ConfigDeviceType configType;
@property (nonatomic ,strong) NSMutableDictionary *pins;
@property (nonatomic ,strong) NSMutableDictionary *pwds;

@property (nonatomic ,copy) NSString *recordSSID;

@end

@implementation ConfigPWViewController

-(void)setConfigDeviceType:(ConfigDeviceType )type{
    _configType = type;
    _pins = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _moveTopContraint.constant = StatusBarAndNavBarHeight;

    _cgImageView.image = [UIImage imageNamed:getConfigGuideBgImg()];
    if (_configType==ConfigDeviceTypeNormal) {
        self.title = @"添加设备";
        self.descPointContraint.constant = -Hrange(20);
        _descLabel.text = NSLocalizedString(@"请按照设备使用说明书操作，使设备进入配置模式后输入Wi-Fi密码", nil);
    }else if (_configType==ConfigDeviceTypeSoftAP) {
        self.title = @"兼容模式";
        _descLabel.hidden = YES;
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ConfigPWViewController class]]) {
                [arr removeObject:controller];
            } else if ([controller isKindOfClass:[ConfigFailResultViewController class]]) {
                [arr removeObject:controller];
            } else if ([controller isKindOfClass:[ConfigWorkViewController class]]) {
                [arr removeObject:controller];
            } else if ([controller isKindOfClass:[SoftAPGuideViewController class]]) {
                [arr removeObject:controller];
            }
        }
        [arr addObject:self.navigationController.viewControllers.lastObject];
        self.navigationController.viewControllers = arr;
        
    }
//    _widthPointContraint.constant = isEN()?108:66;
    [self initNavView];

    [_wifiButton setTitle:NSLocalizedString(@"更换网络", nil) forState:UIControlStateNormal];
    [_ensureButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    _passwordTF.placeholder = NSLocalizedString(@"请输入Wi-Fi密码", nil);
    _ssidLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"当前Wi-Fi", nil),getWifiName()?:@""];
    _recordSSID = getWifiName();
    _bandLabel.text = NSLocalizedString(@"仅支持2.4G Wi-Fi网络", nil);
    
    _pwds = [NSMutableDictionary dictionaryWithDictionary:[Tool dataToJson:[HekrCacheManager objectForFolderName:WiFiPwd FileName:WiFiPwd]]];
    
    if ([_pwds objectForKey:getWifiName()]) {
        _passwordTF.text = [_pwds objectForKey:getWifiName()];
    }
    
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    [MobClick beginLogPageView:@"Config"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
////    [MobClick endLogPageView:@"Config"];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    
//    //    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:@"HEKRchangeNet" object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_configType==ConfigDeviceTypeSoftAP) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HEKRchangeNet" object:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_passwordTF isFirstResponder]) {
        [_passwordTF resignFirstResponder];
    }
}

-(void)refreshSSID{
    _ssidLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"当前网络", nil),getWifiName()?:@""];
    _recordSSID = getWifiName();
    _passwordTF.text = @"";
    if ([_pwds objectForKey:getWifiName()]) {
        _passwordTF.text = [_pwds objectForKey:getWifiName()];
    }
}

-(void)keyboardWillShow:(NSNotification*)noti{
    CGRect keyRect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float wholeHeight = CGRectGetHeight(_moveView.frame)+StatusBarAndNavBarHeight;
    float leftHeight = ScreenHeight-keyRect.size.height;
    
    if (wholeHeight>leftHeight) {
        _moveTopContraint.constant = StatusBarAndNavBarHeight-(wholeHeight-leftHeight);
    }else{
        _moveTopContraint.constant = StatusBarAndNavBarHeight;
    }
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    _moveTopContraint.constant = StatusBarAndNavBarHeight;
    
    [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)setSystemRootWiFi{
    NSString * urlString = @"App-Prefs:root=WIFI";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}

-(IBAction)secureTextEntry:(UIButton *)btn{
    _passwordTF.secureTextEntry = !_passwordTF.secureTextEntry;
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_passwordTF.secureTextEntry?@"ic_eyeclose":@"ic_eyeopen"]] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_passwordTF.secureTextEntry?@"ic_eyeclose":@"ic_eyeopen"]] forState:UIControlStateSelected];
}

-(IBAction)ensure{
    if ([_passwordTF isFirstResponder]) {
        [_passwordTF resignFirstResponder];
    }
//    _recordSSID = @"";
//    [self configDeviceVC];
//    return;
    WS(weakSelf);
    if (!_recordSSID) {
        [self showAlertPromptWithMsg:@"请连接WIFI" ensureText:@"去连接" callback:^(UIAlertAction * _Nonnull action) {
            [weakSelf setSystemRootWiFi];
        }];
        return;
    }else if ([_recordSSID hasSuffix:@"_5G"]) {
        [self showAlertPromptWithMsg:@"仅支持2.4G Wi-Fi，建议您更换网络" leftText:@"继续" leftCallback:^(UIAlertAction * _Nonnull action) {
            [weakSelf checkPassword];
        } rightText:@"去更改" rigthCallback:^(UIAlertAction * _Nonnull action) {
            [weakSelf setSystemRootWiFi];
        }];
        return;
    }
    
    [self checkPassword];
    
//    ConfigFailResultViewController *cfrVC = [[ConfigFailResultViewController alloc] initWithNibName:@"ConfigFailResultViewController" bundle:nil];
//    [cfrVC setConfigDeviceType:ConfigDeviceTypeNormal configStep:2 device:nil];
//    [self.navigationController pushViewController:cfrVC animated:YES];
}

-(void)checkPassword{
    WS(weakSelf);
    if (_passwordTF.text.length==0) {
        [self showAlertPromptWithMsg:@"输入密码为空，请再次确认" ensureText:@"继续" callback:^(UIAlertAction * _Nonnull action) {
            [weakSelf configDeviceVC];
            
        }];
        return;
    }else if ([_passwordTF.text componentsSeparatedByString:@" "].count>1) {
        [self showAlertPromptWithMsg:@"输入的密码中包含空格，请再次确认" ensureText:@"继续" callback:^(UIAlertAction * _Nonnull action) {
            [weakSelf configDeviceVC];
        }];
        return;
    }
    
    [_pwds setObject:_passwordTF.text forKey:_recordSSID];
    [HekrCacheManager setObject:[Tool jsonToData:_pwds] forFolderName:WiFiPwd FileName:WiFiPwd];
    
    [self configDeviceVC];
}

-(void)configDeviceVC{
    
    if (_configType == ConfigDeviceTypeNormal) {
        ConfigWorkViewController *cwVC = [ConfigWorkViewController new];
        [cwVC setConfigType:ConfigDeviceTypeNormal ssid:_recordSSID password:_passwordTF.text pinCode:nil];
        [self.navigationController pushViewController:cwVC animated:YES];
    }else{
        if ([_pins objectForKey:_recordSSID]) {
            SoftAPGuideViewController *sapVC = [[SoftAPGuideViewController alloc] initWithNibName:@"SoftAPGuideViewController" bundle:nil];
            [sapVC setConfigType:ConfigDeviceTypeSoftAP ssid:_recordSSID password:_passwordTF.text pinCode:[_pins objectForKey:_recordSSID]];
            [self.navigationController pushViewController:sapVC animated:YES];
            
        }else{
            [GiFHUD showWithOverlay:self.view];
            WS(weakSelf);
            [[Hekr sharedInstance] getPINCode:_recordSSID callback:^(NSString *pin, NSError *err) {
                [GiFHUD disMiss];
                if (pin) {
                    [weakSelf.pins setObject:pin forKey:weakSelf.recordSSID];
                    SoftAPGuideViewController *sapVC = [[SoftAPGuideViewController alloc] initWithNibName:@"SoftAPGuideViewController" bundle:nil];
                    [sapVC setConfigType:ConfigDeviceTypeSoftAP ssid:_recordSSID password:_passwordTF.text pinCode:pin];
                    [weakSelf.navigationController pushViewController:sapVC animated:YES];
                }else{
                    [weakSelf.view.window makeToast:NSLocalizedString(@"请检查网络", nil) duration:1.0 position:@"center"];
                }
            }];
            
        }
    }
}



@end
