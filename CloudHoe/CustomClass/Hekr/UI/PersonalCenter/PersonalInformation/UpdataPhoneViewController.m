//
//  UpdataPhoneViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/18.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UpdataPhoneViewController.h"
#import "Tool.h"
#import "ImageVerView.h"
#import "GiFHUD.h"
#import <Masonry.h>
#import <HekrAPI.h>
#import "UserViewController.h"

@interface UpdataPhoneViewController ()<ImageVerViewDelegate>
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, strong)UITextField *verTextField;
@property (nonatomic, strong)UIButton *verBtn;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger second;
@property (nonatomic, strong)ImageVerView *imageVerView;
@property (nonatomic, strong)UILabel *hintLabel;
@end

@implementation UpdataPhoneViewController

- (instancetype)initWithPhone:(NSString *)phoneNum PassWord:(NSString *)passWord{
    self = [super init];
    if (self) {
        _passWord = passWord;
        _phoneNum = phoneNum;
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

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"绑定账号" leftBarButtonAction:^{
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
    NSString *str = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您的手机号:", nil),_phoneNum];;
    phoneLabel.text = NSLocalizedString(str,nil);
    phoneLabel.font = [UIFont boldSystemFontOfSize:16];
    phoneLabel.textColor = getTitledTextColor();
    [self.view addSubview:phoneLabel];
    
    _verTextField = [UITextField new];
    _verTextField.placeholder = NSLocalizedString(@"请输入验证码", nil);
    [_verTextField setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    _verTextField.font  = [UIFont systemFontOfSize:16];
    _verTextField.textColor = getInputTextColor();
    _verTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_verTextField];
    
    UILabel *verLabel = [UILabel new];
    verLabel.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:verLabel];
    
    _verBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _verBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _verBtn.backgroundColor = getCellBackgroundColor();
    [_verBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_verBtn setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_verBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verBtn];
    
    _hintLabel = [UILabel new];
    _hintLabel.numberOfLines = 0;
    _hintLabel.font = [UIFont systemFontOfSize:14];
    _hintLabel.textColor = [UIColor redColor];
    [self.view addSubview:_hintLabel];
    
    
    UIButton *tureBtn = [UIButton buttonWithTitle:NSLocalizedString(@"完成", nil) frame:CGRectMake(0, 0, BUTTONWIDTH, BUTTONHEIGHT) target:self action:@selector(tureAction)];
    [self.view addSubview:tureBtn];
    
    WS(weakSelf);
    [phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(32)+StatusBarAndNavBarHeight);
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
        make.size.mas_equalTo(CGSizeMake(Width, 16));
    }];
    
    [tureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(verView.mas_bottom).offset(Vrange(194)+BUTTONHEIGHT/2+20);
        make.size.mas_equalTo(CGSizeMake(BUTTONWIDTH, BUTTONHEIGHT));
    }];
    
}

- (void)tureAction{
    if ([_verTextField isFirstResponder]) {
        [_verTextField resignFirstResponder];
    }
    if (_verTextField.text.length > 6 || _verTextField.text.length <= 0) {
        _hintLabel.text = NSLocalizedString(@"请输入正确的验证码", nil);
        return;
    }
    [GiFHUD showWithOverlay];
    _hintLabel.text = @"";
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://uaa-openapi.hekr.me/sms/checkVerifyCode?phoneNumber=%@&code=%@",_phoneNum,_verTextField.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self updateAction:responseObject[@"token"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        if ([APIError(error) isEqualToString:@"0"]) {
            _hintLabel.text = NSLocalizedString(@"验证码错误，请重试", nil);
        }else{
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
        }
    }];
}

- (void)updateAction:(NSString *)token{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *dict = @{@"uid":[Hekr sharedInstance].user.uid,
                           @"phoneNumber":_phoneNum,
                           @"password":_passWord,
                           @"token":token,
                           @"verifyCode":_verTextField.text};
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa-openapi.hekr.me/accountUpgrade" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdataPhone" object:nil userInfo:@{@"phoneNum":_phoneNum}];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[UserViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        if ([APIError(error) isEqualToString:@"0"]) {
            [self.view.window makeToast:NSLocalizedString(@"绑定失败，请重试", nil) duration:1.0 position:@"center"];
        }else{
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
        }
    }];
    
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
    
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=register&token=%@",_phoneNum,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
