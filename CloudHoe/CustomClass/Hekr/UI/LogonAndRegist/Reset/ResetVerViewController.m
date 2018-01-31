//
//  ResetVerViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ResetVerViewController.h"
#import "Tool.h"
#import "ImageVerView.h"
#import "GiFHUD.h"
#import <Masonry.h>
#import <HekrAPI.h>
#import "SafetyQuestionViewController.h"
#import "ResetPassWordForPhoneViewController.h"


@interface ResetVerViewController ()<ImageVerViewDelegate,ResetPassWordForPhoneDelegate>
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, strong)UITextField *verTextField;
@property (nonatomic, strong)UIButton *verBtn;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger second;
@property (nonatomic, assign)BOOL isHaveSecurity;
@property (nonatomic, strong)ImageVerView *imageVerView;
@property (nonatomic, strong)UILabel *hintLabel;
@end

@implementation ResetVerViewController
- (instancetype)initWithPhoneNum:(NSString *)phoneNum isHaveSecurity:(BOOL)isHaveSecurity{
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
//        _isHaveSecurity = isHaveSecurity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    _second = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initNavView{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"忘记密码", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"忘记密码" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIView *phoneNumView = [UIView new];
    phoneNumView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:phoneNumView];
    
    UIView *verView = [UIView new];
    verView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:verView];
    
    UILabel *phoneLabel = [UILabel new];
    NSString *str = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"您的手机号", nil),_phoneNum];
    phoneLabel.text = NSLocalizedString(str,nil);
    phoneLabel.font = [UIFont boldSystemFontOfSize:16];
    phoneLabel.textColor = UIColorFromHex(0x727272);
    [self.view addSubview:phoneLabel];
    
    _verTextField = [UITextField new];
    _verTextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _verTextField.font  = [UIFont systemFontOfSize:16];
    _verTextField.textColor = UIColorFromHex(0x727272);
    _verTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_verTextField];
    
    UILabel *verLabel = [UILabel new];
    verLabel.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:verLabel];
    
    _verBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_verBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verBtn];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    [self.view addSubview:_hintLabel];
    
    UIButton *tureBtn = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(tureAction)];
    [self.view addSubview:tureBtn];
    
    WS(weakSelf);
    [phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(48)+StatusBarAndNavBarHeight);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [verView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumView.mas_bottom).offset(1);
        make.left.equalTo(phoneNumView.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumView.mas_top);
        make.left.equalTo(phoneNumView.mas_left).offset(Hrange(32));
        make.size.mas_equalTo(CGSizeMake(Width - Hrange(64), Vrange(100)));
    }];
    
    [_verTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView.mas_top);
        make.left.equalTo(phoneLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width/2, Vrange(100)));
    }];
    
    [_verBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView.mas_top);
        make.right.equalTo(verView.mas_right);
        make.size.mas_equalTo(CGSizeMake(Hrange(205), Vrange(100)));
    }];
    
    [verLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView.mas_top).offset(Vrange(10));
        make.right.equalTo(_verBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(1, Vrange(80)));
    }];
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verView.mas_bottom).offset(5);
        make.left.equalTo(_verTextField.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, 36));
    }];
    
    [tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(verView.mas_bottom).offset(Vrange(210)+BUTTONHEIGHT/2+20);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, BUTTONHEIGHT));
    }];
    if (_isHaveSecurity == YES) {
        UILabel *secyrityLabel = [UILabel new];
        secyrityLabel.text = NSLocalizedString(@"用密保问题验证", nil);
        secyrityLabel.textColor = UIColorFromHex(0x06a4f0);
        secyrityLabel.font = [UIFont systemFontOfSize:14];
        secyrityLabel.userInteractionEnabled = YES;
        [self.view addSubview:secyrityLabel];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secyrityAction)];
        [secyrityLabel addGestureRecognizer:tgr];
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_secyrity_arrow"]];
        [self.view addSubview:image];
        
        [secyrityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(verView.mas_bottom).offset(Vrange(82)+20);
            make.centerX.mas_equalTo(weakSelf.view.mas_centerX).offset(-8);
            make.height.mas_equalTo(16);
        }];
        [secyrityLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(secyrityLabel.mas_right).offset(1);
            make.centerY.equalTo(secyrityLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
    }
    
}

- (void)secyrityAction{
    SafetyQuestionViewController *safetyView = [[SafetyQuestionViewController alloc]initWithIsOne:NO Num:_phoneNum Title:NSLocalizedString(@"忘记密码", nil) ViewType:resetPassWord];
    [self.navigationController pushViewController:safetyView animated:YES];
}


- (void)tureAction{
    if ([_verTextField isFirstResponder]) {
        [_verTextField resignFirstResponder];
    }
    if (_verTextField.text.length > 6 || _verTextField.text.length <= 0) {
        _hintLabel.text = NSLocalizedString(@"请输入正确的验证码", nil);
        return;
    }
//    [GiFHUD showWithOverlay];528297
    _hintLabel.text = @"";
    
    ResetPassWordForPhoneViewController *controller = [[ResetPassWordForPhoneViewController alloc]initWithToken:_verTextField.text Num:_phoneNum isSafety:NO];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
//    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://uaa-openapi.hekr.me/sms/checkVerifyCode?phoneNumber=%@&code=%@",_phoneNum,_verTextField.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [GiFHUD dismiss];
//        ResetPassWordForPhoneViewController *controller = [[ResetPassWordForPhoneViewController alloc]initWithToken:responseObject[@"token"] Num:_phoneNum];
//    controller.delegate = self;
//        [self.navigationController pushViewController:controller animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [GiFHUD dismiss];
//        if ([APIError(error) isEqualToString:@"0"]) {
//            [self.view.window makeToast:NSLocalizedString(@"验证码错误", nil) duration:1.0 position:@"center"];
//        }else{
//            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
//        }
//    }];
}

- (void)resetPassWordForPhoneDelegateAction:(NSString *)num{
    [self.delegate resetVerViewControllerAction:num];
}


- (void)getCode{
    if ([_verTextField isFirstResponder]) {
        [_verTextField resignFirstResponder];
    }
    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];
}

- (void)getSMS:(NSString *)captchaToken{
    [self.view resignFirstResponder];
    [_timer setFireDate:[NSDate distantPast]];
    _verBtn.titleLabel.adjustsFontSizeToFitWidth = NO;
    _verBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_verBtn setTitle:@"59" forState:UIControlStateNormal];
    [_verBtn setTitleColor:UIColorFromHex(0xdadada) forState:UIControlStateNormal];
    _verBtn.userInteractionEnabled = NO;
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=resetPassword&token=%@",_phoneNum,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[获取短信验证码]：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (APIErrorCode(error) == 3400008) {
            [self.view.window makeToast:NSLocalizedString(@"用户已注册", nil) duration:1.0 position:@"center"];
        }else if((APIErrorCode(error) == 400016)||(APIErrorCode(error) == 3400005)){
            [self showAlertPromptWithTitle:APIError(error)  actionCallback:nil];
        }else{
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"短信发送失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }
        [_timer setFireDate:[NSDate distantFuture]];
        _verBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
        _verBtn.userInteractionEnabled = YES;
        _second = 60;
    }];
    
}


- (void)timerAction{
    if (_second <= 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
        _verBtn.userInteractionEnabled = YES;
        _second = 60;
    }else{
        _second --;
        [_verBtn setTitle:[NSString stringWithFormat:@"%ld",_second] forState:UIControlStateNormal];
    }
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
