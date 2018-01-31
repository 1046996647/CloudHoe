//
//  LANSettingViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "LANSettingViewController.h"
#import "Tool.h"
#import "HekrAPI.h"
#import <Masonry.h>

@interface LANSettingViewController ()
@property (nonatomic, strong)UIView *mainView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contenLabel;
@property (nonatomic, strong)UISwitch *lanSwitch;
@end

@implementation LANSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"LANSetting"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LANSetting"];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"局域网设置", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    label.backgroundColor = getCellLineColor();
//    [self.view addSubview:label];
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"局域网设置" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    WS(weakSelf);
    _mainView = [UIView new];
    _mainView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:_mainView];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = NSLocalizedString(@"局域网状态", nil);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = getTitledTextColor();
    [_mainView addSubview:_titleLabel];
    
    _lanSwitch = [UISwitch new];
    _lanSwitch.on=[[Hekr sharedInstance] getLocalControl];
    [_lanSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    [_lanSwitch setExclusiveTouch:YES];
    [_mainView addSubview:_lanSwitch];
    
    _contenLabel = [UILabel new];
    _contenLabel.text = NSLocalizedString(@"开启局域网功能，已配置的设备可以在没有外网的情况下，通过连接路由器接入局域网继续使用。\n\n注意：开启此功能，设备控制将自动设置为优先通过局域网控制。", nil);
    _contenLabel.font = [UIFont systemFontOfSize:14];
    _contenLabel.textColor = getDescriptiveTextColor();
    _contenLabel.numberOfLines = 0;
    [self.view addSubview:_contenLabel];
    
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(StatusBarAndNavBarHeight+10);
        make.left.equalTo(weakSelf.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(Width, Vrange(100)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top);
        make.left.equalTo(_mainView.mas_left).offset(Hrange(30));
        make.height.mas_equalTo(Vrange(100));
    }];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_lanSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_mainView.mas_right).offset(-Hrange(30));
    }];
    
    [_contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_bottom).offset(20);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.mas_equalTo(Width-2*Hrange(30));
    }];
    [_contenLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)switchChange{
    
    [[Hekr sharedInstance] setLocalControl:[[Hekr sharedInstance] getLocalControl]==HekrLocalControlOn?HekrLocalControlOff:HekrLocalControlOn block:^(HekrLocalControl control) {
        _lanSwitch.on=control;
    }];
    
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
