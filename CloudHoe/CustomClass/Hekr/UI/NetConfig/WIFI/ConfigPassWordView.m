//
//  ConfigPassWordView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/6.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigPassWordView.h"
#import "Tool.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <HekrAPI.h>

@interface ConfigPassWordView ()
@property (nonatomic, strong)UILabel *wifiName;
@property (nonatomic, strong)UITextField *passWord;
@property (nonatomic, strong)UISwitch *saveSwitch;
@property (nonatomic, assign)BOOL isShow;
@end

@implementation ConfigPassWordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = getViewBackgroundColor();
        [self createViews];
        _isShow = NO;
    }
    return self;
}

- (void)createViews{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, Vrange(30), ScreenWidth, Vrange(426))];
    view.backgroundColor = getCellBackgroundColor();
    [self addSubview:view];
    //111
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Hrange(670), 0.5)];
    centerLabel.center = CGPointMake(ScreenWidth/2, Vrange(160.0));
    centerLabel.backgroundColor = getCellLineColor();
    [view addSubview:centerLabel];
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Hrange(670), 0.5)];
    downLabel.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(centerLabel.frame)+Vrange(140));
    downLabel.backgroundColor = getCellLineColor();
    [view addSubview:downLabel];
    
    UIImageView *wifiimage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(centerLabel.frame)+Hrange(20), CGRectGetMinY(centerLabel.frame)-Hrange(60), Hrange(40), Hrange(40))];
    wifiimage.image = [UIImage imageNamed:@"icon-wifiName"];
    [view addSubview:wifiimage];
    UIImageView *passimage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(downLabel.frame)+Hrange(20), CGRectGetMinY(downLabel.frame)-Hrange(60), Hrange(40), Hrange(40))];
    passimage.image = [UIImage imageNamed:@"icon-passWord"];
    [view addSubview:passimage];
    
    UILabel *netLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wifiimage.frame)+Hrange(20), CGRectGetMinY(wifiimage.frame), 80, Hrange(40))];
    netLabel.text = NSLocalizedString(@"当前网络", nil);
    netLabel.textColor = getTitledTextColor();
    netLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:netLabel];
    UILabel *passLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passimage.frame)+Hrange(20), CGRectGetMinY(passimage.frame), 80, Hrange(40))];
    passLabel.text = NSLocalizedString(@"密码", nil);
    passLabel.textColor = getTitledTextColor();
    passLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:passLabel];
    
    _wifiName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(netLabel.frame)+Hrange(20), CGRectGetMinY(netLabel.frame)-5, CGRectGetWidth(centerLabel.frame)-80-Hrange(166), Hrange(40)+10)];
    _wifiName.text = [self getWifiName];
    _wifiName.textAlignment = NSTextAlignmentCenter;
    _wifiName.textColor = getDescriptiveTextColor();
    _wifiName.font = [UIFont systemFontOfSize:18];
    _wifiName.adjustsFontSizeToFitWidth = YES;
    [view addSubview:_wifiName];
    _passWord = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passLabel.frame)+Hrange(20), CGRectGetMinY(passLabel.frame)-5, CGRectGetWidth(downLabel.frame)-80-Hrange(166), Hrange(40)+10)];
    _passWord.textColor = getInputTextColor();
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",[Hekr sharedInstance].user.access_token,_wifiName.text]]) {
        _passWord.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",[Hekr sharedInstance].user.access_token,_wifiName.text]];
    }
    _passWord.placeholder = NSLocalizedString(@"请输入WI-FI密码", nil);
    _passWord.font = [UIFont systemFontOfSize:18];
    [_passWord setSecureTextEntry:YES];
    _passWord.textAlignment = NSTextAlignmentCenter;
    [_passWord setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    [view addSubview:_passWord];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showButton.frame = CGRectMake(CGRectGetMaxX(downLabel.frame)-Hrange(66), _passWord.center.y-Vrange(24), Hrange(66)+10, Vrange(48));
    //34 24
    [showButton setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
    [showButton setImageEdgeInsets:UIEdgeInsetsMake(Vrange(12), Vrange(32), Vrange(12), 10)];
    [showButton addTarget:self action:@selector(showPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [showButton setExclusiveTouch:YES];
    [view addSubview:showButton];
    
    
    UILabel *save = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(downLabel.frame)-50, CGRectGetMaxY(downLabel.frame)+Vrange(30), 50, Vrange(36))];
    save.text = NSLocalizedString(@"保存密码", nil);
    save.textAlignment = NSTextAlignmentRight;
    save.textColor = getTitledTextColor();
    save.font = [UIFont systemFontOfSize:12];
    save.userInteractionEnabled = YES;
    [save setExclusiveTouch:YES];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tgrAction)];
    [save addGestureRecognizer:tgr];
    [view addSubview:save];
    _saveSwitch = [[UISwitch alloc]init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@savewifipassword",[Hekr sharedInstance].user.access_token]] isEqualToString:@"YES"]) {
        _saveSwitch.on = YES;
    }else{
        _saveSwitch.on = NO;
    }
    //开启时颜色
    _saveSwitch.onTintColor = rgb(2, 153, 237);
    //关闭时颜色，只有边框
    _saveSwitch.tintColor = rgb(80, 82, 82);
    //按钮颜色
    //    _saveSwitch.thumbTintColor = rgb(2, 153, 237);
    
    _saveSwitch.transform  = CGAffineTransformMakeScale(0.6,0.6);
    //    _saveSwitch.transform  = CGAffineTransformMakeScale((_saveSwitch.frame.size.width-Hrange(64))/_saveSwitch.frame.size.width, (_saveSwitch.frame.size.height-Vrange(36))/_saveSwitch.frame.size.height);
    _saveSwitch.center = CGPointMake(CGRectGetMinX(save.frame)-Hrange(20)-Hrange(32), CGRectGetMinY(save.frame)+Vrange(18));
    [_saveSwitch addTarget:self action:@selector(saveChange) forControlEvents:UIControlEventValueChanged];
    [_saveSwitch setExclusiveTouch:YES];
    [view addSubview:_saveSwitch];
    
    UIButton *configBtn = [UIButton buttonWithTitle:NSLocalizedString(@"连接", nil) frame:CGRectMake(0, 0, sHrange(231), sVrange(40)) target:self action:@selector(configAction:)];
//    configBtn.frame = CGRectMake(0, 0, Hrange(710), Vrange(80));
    configBtn.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(view.frame)+Vrange(150)+configBtn.frame.size.height/2);
//    configBtn.backgroundColor = rgb(2, 153, 237);
//    configBtn.layer.cornerRadius = configBtn.frame.size.height/2;
//    [configBtn setTitle:NSLocalizedString(@"连接", nil) forState:UIControlStateNormal];
//    [configBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    configBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    [configBtn addTarget:self action:@selector(configAction:) forControlEvents:UIControlEventTouchUpInside];
//    [configBtn setExclusiveTouch:YES];
    [self addSubview:configBtn];

}

#pragma mark - 刷新SSID
- (void)refreshSSID{
    _wifiName.text = [self getWifiName];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",[Hekr sharedInstance].user.access_token,_wifiName.text]]) {
        _passWord.text = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",[Hekr sharedInstance].user.access_token,_wifiName.text]];
    }
}

#pragma mark - 开始配网
- (void)configAction:(UIButton *)btn{
    if ([_passWord isFirstResponder]) {
        [_passWord resignFirstResponder];
    }
    [self.delegate congfigStarActionWifiName:_wifiName.text PassWord:_passWord.text];
}

#pragma mark - 密码 显示&&隐藏
- (void)showPassWord:(UIButton *)btn{
    if (_isShow == NO) {
        _isShow = YES;
        
        [btn setImage:[UIImage imageNamed:@"ic_eyeopen"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(Vrange(12), Vrange(32), Vrange(12), 10)];
        [_passWord setSecureTextEntry:NO];
    }else{
        _isShow = NO;
        
        [btn setImage:[UIImage imageNamed:@"ic_eyeclose"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(Vrange(12), Vrange(32), Vrange(12), 10)];
        [_passWord setSecureTextEntry:YES];
    }
}

- (void)tgrAction{
    [UIView animateWithDuration:1 animations:^{
        [_saveSwitch setOn:!(_saveSwitch.on) animated:YES];
    }];
    [self saveChange];
    
}

#pragma mark - 保存密码
- (void)saveChange{
    if (_saveSwitch.on == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"%@savewifipassword",[Hekr sharedInstance].user.access_token]];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:[NSString stringWithFormat:@"%@savewifipassword",[Hekr sharedInstance].user.access_token]];
    }
}


#pragma mark - 获取WIFI名字
- (NSString *)getWifiName{
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
        
    }
    CFRelease(wifiInterfaces);
    
    return wifiName==nil?@"":wifiName;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_passWord isFirstResponder]) {
        [_passWord resignFirstResponder];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
