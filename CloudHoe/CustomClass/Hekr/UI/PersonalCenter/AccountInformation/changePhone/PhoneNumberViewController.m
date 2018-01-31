//
//  PhoneNumberViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/20.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
#import "ImageVerView.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface PhoneNumberViewController ()<ImageVerViewDelegate>
@property (nonatomic, strong)ImageVerView *imageVerView;

@end

@implementation PhoneNumberViewController
{
    NSString *_token;
    UITextField *_phone;
    UITextField *_ver;
    UIButton *_verButton;
    NSInteger _time;
    NSTimer *_timer;
}
- (id)initWithToken:(NSString *)token{
    self = [super init];
    if (self) {
        _token = token;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    _time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"更换手机号码", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
//    UILabel* upLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    upLabel.backgroundColor = getCellLineColor();
//    [self.view addSubview:upLabel];
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"更换手机号码" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, Vrange(100))];
    phoneView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:phoneView];
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneView.frame), ScreenWidth, 1)];
    centerLabel.backgroundColor = rgb(209, 209, 209);
    [self.view addSubview:centerLabel];
    UIView *verView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(centerLabel.frame), ScreenWidth, Vrange(100))];
    verView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:verView];
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(verView.frame), ScreenWidth, 1)];
    downLabel.backgroundColor = rgb(209, 209, 209);
    [self.view addSubview:downLabel];
    
    _phone = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(30), 0, ScreenWidth-2*Hrange(30), Vrange(100))];
    _phone.textColor = getInputTextColor();
    _phone.placeholder = NSLocalizedString(@"请填写新的手机号码", nil);
    [_phone setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    [phoneView addSubview:_phone];
    _ver = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(30), 0, 150, Vrange(100))];
    _ver.textColor = getInputTextColor();
    _ver.placeholder = NSLocalizedString(@"请填写验证码", nil);
    [_ver setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    _ver.keyboardType = UIKeyboardTypeDecimalPad;
    [verView addSubview:_ver];
    _verButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verButton.frame = CGRectMake(ScreenWidth-Hrange(210), 0, Hrange(210), Vrange(100));
    
    [_verButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_verButton setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_verButton addTarget:self action:@selector(verAction) forControlEvents:UIControlEventTouchUpInside];
    _verButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _verButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [verView addSubview:_verButton];
    
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"完成", nil) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(phoneChange)];
    button.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(downLabel.frame)+Vrange(200)+button.frame.size.height/2);
    [self.view addSubview:button];
}



- (void)verAction{
    if ([_phone isFirstResponder]) {
        [_phone resignFirstResponder];
    }else if ([_ver isFirstResponder]) {
        [_ver resignFirstResponder];
    }
    
    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];
    
}
- (void)getSMS:(NSString *)captchaToken{
 
    if (validateMobile(_phone.text)) {
        
        if ([_phone.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"]]) {
            
            [self showAlertPromptWithTitle:@"该手机号码已绑定" actionCallback:nil];


        }else{
            _time = 60;
            _verButton.userInteractionEnabled = NO;
            [_timer setFireDate:[NSDate distantPast]];
            [_verButton setTitle:[NSString stringWithFormat:@"%ldS",(long)_time] forState:UIControlStateNormal];
            [_verButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _verButton.userInteractionEnabled = NO;
            
            AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
            [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=register&token=%@",_phone.text,[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                

                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"请求发送失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
                
                [_verButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
                [_verButton setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
                _verButton.userInteractionEnabled = YES;
                [_timer setFireDate:[NSDate distantFuture]];
                _time = 60;
                
                
            }];

        }
        
    }else{
        
        [self showAlertPromptWithTitle:@"请输入正确的手机号码" actionCallback:nil];
    }
    
    
}

- (void)timeAction{
    if (_time == 0) {
        [_verButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
        [_verButton setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
        _verButton.userInteractionEnabled = YES;
        [_timer setFireDate:[NSDate distantFuture]];
        _time = 60;
    }else{
        _time--;
        [_verButton setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateNormal];
    }
}

- (void)phoneChange{
    
    
    if (_ver.text.length > 0) {
        [GiFHUD showWithOverlay];
        NSDictionary *dic = @{@"pid":[Hekr sharedInstance].pid,
                              @"token":_token,
                              @"verifyCode":_ver.text,
                              @"phoneNumber":_phone.text};
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager POST:@"http://uaa.openapi.hekr.me/changePhoneNumber" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            
            [self showAlertPromptWithTitle:@"修改成功，请重新登录" actionCallback:^(UIAlertAction * _Nonnull action) {
                [[Hekr sharedInstance] logout];
                if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HekrSDKUserChangeNotification object:nil];
                }
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"修改失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
        }];
    }else{
        

        [self showAlertPromptWithTitle:@"请输入验证码" actionCallback:nil];

    }
    
}

//- (BOOL) validateMobile:(NSString *)mobile
//{
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0])|(17[7])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_phone isFirstResponder]) {
        [_phone resignFirstResponder];
    }else if ([_ver isFirstResponder]) {
        [_ver resignFirstResponder];
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
