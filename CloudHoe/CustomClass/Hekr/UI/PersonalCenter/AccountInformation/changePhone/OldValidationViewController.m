//
//  OldValidationViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/20.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "OldValidationViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "PhoneNumberViewController.h"
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>
#import "ImageVerView.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface OldValidationViewController ()<ImageVerViewDelegate>
@property (nonatomic, strong)ImageVerView *imageVerView;

@end

@implementation OldValidationViewController
{
    UITextField *_number;
    UIButton *_verButton;
    NSInteger _time;
    NSTimer *_timer;
    NSString *_token;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    _time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
//    [_timer setFireDate:[NSDate distantPast]];
    
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
    
    [GiFHUD showWithOverlay];
    [self performSelector:@selector(getVer) withObject:nil afterDelay:1.0f];

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
//    titLabel.text = NSLocalizedString(@"修改绑定", nil);
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
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"修改绑定" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, Vrange(100))];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _number = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(30), 64, 150, Vrange(100))];
    _number.textColor = getInputTextColor();
    _number.placeholder = NSLocalizedString(@"请输入验证码", nil);
    [_number setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    _number.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_number];
    
    UILabel* downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), ScreenWidth, 1)];
    downLabel.backgroundColor = rgb(209, 209, 209);
    [self.view addSubview:downLabel];
    
    _verButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verButton.frame = CGRectMake(ScreenWidth-Hrange(210), 64, Hrange(210), Vrange(100));
    _verButton.userInteractionEnabled = YES;
    [_verButton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_verButton setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_verButton addTarget:self action:@selector(getVer) forControlEvents:UIControlEventTouchUpInside];
    _verButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _verButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_verButton];
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"下一步", nil) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(phoneChange)];
    button.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(downLabel.frame)+Vrange(200)+button.frame.size.height/2);
    [self.view addSubview:button];
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
    if ([_number isFirstResponder]) {
        [_number resignFirstResponder];
    }
//    PhoneNumberViewController *phoneView = [[PhoneNumberViewController alloc]initWithToken:_token];
//    [self.navigationController pushViewController:phoneView animated:YES];
    
    
// 
    if (_number.text.length > 0) {
        [GiFHUD showWithOverlay];
        AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/checkVerifyCode?phoneNumber=%@&code=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"],_number.text] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            if ([responseObject objectForKey:@"token"]) {
                _token = [responseObject objectForKey:@"token"];
                
                PhoneNumberViewController *phoneView = [[PhoneNumberViewController alloc]initWithToken:_token];
                [self.navigationController pushViewController:phoneView animated:YES];
                
                
                
            }else{
                [self.view.window makeToast:NSLocalizedString(@"验证码错误",nil) duration:1.0 position:@"center"];
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"修改失败", nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
            }
            
        }];
    }else{
        
        [self showAlertPromptWithTitle:NSLocalizedString(@"请输入正确的验证码",nil) actionCallback:nil];

    }
}



- (void)getVer{
    if ([_number isFirstResponder]){
        [_number resignFirstResponder];
    }
    [GiFHUD dismiss];

    ImageVerView * imageVer = [[[NSBundle mainBundle] loadNibNamed:@"ImageVewView" owner:self options:nil] firstObject];
    _imageVerView = imageVer;
    _imageVerView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _imageVerView.delegate = self;
    [self.view.window addSubview:_imageVerView];

}
- (void)getSMS:(NSString *)captchaToken{
    _time = 60;
    [_timer setFireDate:[NSDate distantPast]];
    [_verButton setTitle:[NSString stringWithFormat:@"%ldS",(long)_time] forState:UIControlStateNormal];
    [_verButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _verButton.userInteractionEnabled = NO;

    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=changePhone&token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"],[Hekr sharedInstance].pid,captchaToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_number isFirstResponder]) {
        [_number resignFirstResponder];
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
