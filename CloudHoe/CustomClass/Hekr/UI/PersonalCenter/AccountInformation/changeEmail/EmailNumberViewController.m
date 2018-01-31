//
//  EmailNumberViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/20.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "EmailNumberViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "Tool.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface EmailNumberViewController ()

@end

@implementation EmailNumberViewController
{
    UITextField *_number;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"更换邮箱地址", nil);
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
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"更换邮箱地址" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createViews{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, Vrange(100))];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    _number = [[UITextField alloc]initWithFrame:CGRectMake(Hrange(30), 64, ScreenWidth-2*Hrange(30), Vrange(100))];
    _number.textColor = getInputTextColor();
    _number.textColor = rgb(80, 80, 82);
    _number.placeholder = NSLocalizedString(@"请填写邮箱地址", nil);
    [_number setValue:getPlaceholderTextColor() forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_number];
    
    UILabel* downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), ScreenWidth, 1)];
    downLabel.backgroundColor = rgb(209, 209, 209);
    [self.view addSubview:downLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, Hrange(710), Vrange(80));
    button.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(downLabel.frame)+Vrange(280)+button.frame.size.height/2);
    button.backgroundColor = rgb(6,164,240);
    button.layer.cornerRadius = button.frame.size.height/2;
    [button setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(emailChange) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
  
}

- (void)emailChange{
    
    if ([_number isFirstResponder]) {
        [_number resignFirstResponder];
    }
    if (validateEmail(_number.text)) {
        [GiFHUD showWithOverlay];
        AFHTTPSessionManager *manager  =[[Hekr sharedInstance] sessionWithDefaultAuthorization];
        [manager GET:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/sendChangeEmailStep1Email?email=%@&pid=%@",_number.text,[Hekr sharedInstance].pid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [GiFHUD dismiss];
            NSString *str = [NSString stringWithFormat:NSLocalizedString(@"邮件验证链接已经发送至您的登录邮箱:\n%@\n请点击邮箱内链接，并通过邮件验证",nil),_number.text];
            
            [self showOneActionAlertWithTitle:@"邮箱验证" msg:str actionText:@"确定" actionCallback:^(UIAlertAction * _Nonnull action) {
                [[Hekr sharedInstance] logout];
                if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:HekrSDKUserChangeNotification object:nil];
                }
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [GiFHUD dismiss];
            
            [self showAlertPromptWithTitle:APIError(error) actionCallback:nil];
        }];
        
        
    }else{
        
        [self showAlertPromptWithTitle:@"请输入正确的邮箱地址" actionCallback:nil];

    }
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
