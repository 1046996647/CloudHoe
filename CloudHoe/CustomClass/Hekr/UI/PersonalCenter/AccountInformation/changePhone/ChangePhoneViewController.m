//
//  ChangePhoneViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/20.
//  Copyright © 2016年 Mike. All rights reserved.
//



#import "ChangePhoneViewController.h"
#import "OldValidationViewController.h"
#import "EasyMacro.h"
#import "Tool.h"
#import "SafetyQuestionViewController.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface ChangePhoneViewController ()

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChangePhone"];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChangePhone"];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
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
    UIImageView *image = [UIImageView new];
    image.image = [UIImage imageNamed:@"ic_changephone"];
    [self.view addSubview:image];
    
    UILabel *upLabel = [UILabel new];
    upLabel.textAlignment = NSTextAlignmentCenter;
    upLabel.font = [UIFont boldSystemFontOfSize:20];
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"手机号码：%@",nil),[[NSUserDefaults standardUserDefaults] objectForKey:@"UserNumber"]];
    upLabel.text = str;
    upLabel.textColor = getTitledTextColor();
    upLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:upLabel];
    
    UILabel *downLabel = [UILabel new];
    downLabel.textAlignment = NSTextAlignmentCenter;
    downLabel.font = [UIFont systemFontOfSize:14];
    downLabel.text = NSLocalizedString(@"如需更换手机号，请点击下方按钮进行操作。", nil);
    downLabel.numberOfLines = 0;
    downLabel.textColor = getDescriptiveTextColor();
//    downLabel.adjustsFontSizeToFitWidth = YES;
    downLabel.alpha = 0.8;
    [self.view addSubview:downLabel];
    
    UIButton *button = [UIButton buttonWithTitle:NSLocalizedString(@"更换手机", nil) frame:CGRectMake(0, 0, sHrange(320), sVrange(40)) target:self action:@selector(buttonAction)];
    //    button.center = CGPointMake(ScreenWidth/2, CGRectGetMaxY(downLabel.frame)+Vrange(120)+button.frame.size.height/2);
    [self.view addSubview:button];
    
    WS(weakSelf);
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).offset(Vrange(116)+StatusBarAndNavBarHeight);
        make.size.mas_equalTo(CGSizeMake(Vrange(84), Vrange(154)));
    }];
    
    [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(image.mas_bottom).offset(Vrange(58));
        make.size.mas_equalTo(CGSizeMake(Width, 22));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(upLabel.mas_bottom).offset(Vrange(120));
        make.size.mas_equalTo(CGSizeMake(sHrange(320), sVrange(40)));
    }];
    
    [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.top.equalTo(button.mas_bottom).offset(Vrange(40));
        make.width.mas_equalTo(Width - 20);
    }];
    [downLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)buttonAction{
    
    NSDictionary *dataDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrUserProfile"];
//    if ([dataDic[@"isSecurity"] boolValue]) {
//        SafetyQuestionViewController *view = [[SafetyQuestionViewController alloc]initWithIsOne:NO Num:dataDic[@"phoneNumber"] Title:NSLocalizedString(@"修改绑定", nil) ViewType:changeBind];
//        [self.navigationController pushViewController:view animated:YES];
//    }else{
        [self.navigationController pushViewController:[OldValidationViewController new] animated:YES];
//    }
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
