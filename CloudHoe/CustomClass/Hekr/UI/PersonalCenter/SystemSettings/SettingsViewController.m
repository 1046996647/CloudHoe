//
//  SettingsViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/17.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SettingsViewController.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>
#import "SecurityViewController.h"
#import "MessageCenterViewController.h"
#import "SuggestViewController.h"
#import "AboutHekrViewController.h"
#import "LANSettingViewController.h"
#import "HekrAPI.h"
#import "UIImageView+ThemeColor.h"
#import "ReadWebViewController.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) CGFloat cacheSize;
@property (nonatomic, strong) UILabel *cacheLabel;
@property (nonatomic, strong) UIView *cacheView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *lanLabel;
@property (nonatomic, strong) HekrNavigationBarView *nav;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
//    _titleArray = @[@[NSLocalizedString(@"账号与安全", nil)],@[NSLocalizedString(@"消息中心", nil),NSLocalizedString(@"局域网设置", nil),NSLocalizedString(@"清空缓存", nil)],@[NSLocalizedString(@"常见问题", nil),NSLocalizedString(@"反馈建议", nil),NSLocalizedString(@"关于我们", nil)]];
    _titleArray = @[@[NSLocalizedString(@"消息中心", nil),NSLocalizedString(@"局域网设置", nil),NSLocalizedString(@"清空缓存", nil)],@[NSLocalizedString(@"常见问题", nil),NSLocalizedString(@"反馈建议", nil),NSLocalizedString(@"关于我们", nil)]];
    _cacheSize = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0);
    [self initNavView];
    [self createTableView];
}
//

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick beginLogPageView:@"Setting"];
    _cacheSize = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0);
    if (_lanLabel) {
        if ([[Hekr sharedInstance] getLocalControl]) {
            _lanLabel.text = NSLocalizedString(@"打开", nil);
        }else{
            _lanLabel.text = NSLocalizedString(@"关闭", nil);
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Setting"];
//    [self.navigationController setNavigationBarHidden:_isPop animated:animated];
}


- (void)initNavView
{
    _nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"系统设置" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:_nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CoverViewRectMake style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor= [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *subTitle = _titleArray[section];
    return subTitle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCellId"];
        UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(100)-1, ScreenWidth, 1)];
        downLabel.backgroundColor = getCellLineColor();
        downLabel.alpha = 0.5;
        [cell.contentView addSubview:downLabel];
    }
    if (!(indexPath.section == 0 && indexPath.row == 2)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (_cacheLabel == nil) {
            _cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 0, 60, Vrange(100))];
            _cacheLabel.textAlignment = NSTextAlignmentRight;
            _cacheLabel.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
            _cacheLabel.textColor = getDescriptiveTextColor();
            _cacheLabel.font = getDescTitleFont();
            [cell.contentView addSubview:_cacheLabel];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        _lanLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-135, 0, 100, Vrange(100))];
        _lanLabel.textAlignment = NSTextAlignmentRight;
        _lanLabel.textColor = getDescriptiveTextColor();
        _lanLabel.font = getDescTitleFont();
        if ([[Hekr sharedInstance] getLocalControl]) {
            _lanLabel.text = NSLocalizedString(@"打开", nil);
        }else{
            _lanLabel.text = NSLocalizedString(@"关闭", nil);
        }
        
        [cell.contentView addSubview:_lanLabel];
    }
    cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = getListTitleFont();
    cell.textLabel.textColor = getTitledTextColor();
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = getCellBackgroundColor();
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            [self.navigationController pushViewController:[SecurityViewController new] animated:YES];
//        }
//    }else
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[MessageCenterViewController new] animated:YES];
        }else if (indexPath.row == 1){
            [self.navigationController pushViewController:[LANSettingViewController new] animated:YES];
        }else if (indexPath.row == 2){
            [self clearCacheAction];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
//            http://app.hekr.me/FAQ/index.html?clientType=①&lang=②&theme=③
//            ①：IOS / ANDROID
//            ②：en-US--英文
//               zh-CN--中文
//            ③：0--夜间主题
//               1--蓝色主题
//               2--米黄色主题
//               3--绿色主题
//            NSString *themeStr = [NSString stringWithFormat:@"%lu",(unsigned long)getThemeCode()];
//            NSString *url = [NSString stringWithFormat:@"http://app.hekr.me/FAQ/index.html?clientType=IOS&lang=%@&theme=%@",lang(),themeStr];
//            NSString *url = [NSString stringWithFormat:@"http://app.hekr.me/FAQ/index.html?clientType=IOS&lang=%@&theme=1",lang()];
            
            NSString *appName = [NSString stringWithFormat:@"%@",NSLocalizedString(@"丛云", nil)];
            appName = [appName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *themeStr = [NSString stringWithFormat:@"%lu",(unsigned long)getThemeCode()];
            NSString *url = [NSString stringWithFormat:@"http://app.hekr.me/FAQ/index.html?clientType=IOS&lang=%@&theme=%@&app=%@",lang(),themeStr,appName];
            
            ReadWebViewController *readWebVC = [[ReadWebViewController alloc] initWithTitle:NSLocalizedString(@"常见问题", nil) url:url];
            [self.navigationController pushViewController:readWebVC animated:YES];
        }else if (indexPath.row == 1){
            [self.navigationController pushViewController:[SuggestViewController new] animated:YES];
        }else if (indexPath.row == 2){
            [self.navigationController pushViewController:[AboutHekrViewController new] animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = getViewBackgroundColor();
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Vrange(30);
    }else{
        return Vrange(50);
    }
}

- (void)clearCacheAction{
    if ([_cacheView.superview isKindOfClass:[self.view class]]) {
        return;
    }
    _cacheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2.5, Vrange(100)*2)];
    _cacheView.center = self.view.center;//CGPointMake(ScreenWidth/2, CGRectGetMaxY(_tableView.frame)-Vrange(100));
    _cacheView.backgroundColor = [UIColor blackColor];
    _cacheView.layer.cornerRadius = 10;
    _cacheView.alpha = 0;
    [self.view addSubview:_cacheView];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Vrange(100), Vrange(100))];
    image.center = CGPointMake(_cacheView.frame.size.width/2, Vrange(100)/2+10);
    image.image = [UIImage imageNamed:@"ic_cache"];
//    [image setThemeImageNamed:@"ic_cache"];
    [_cacheView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _cacheView.frame.size.width, Vrange(100))];
    label.center = CGPointMake(_cacheView.frame.size.width/2, Vrange(100)*1.5);
    label.text = NSLocalizedString(@"缓存已清除", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_cacheView addSubview:label];
    
    [UIView animateWithDuration:0.3 animations:^{
        _cacheView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 animations:^{
            _cacheView.alpha = 0;
        } completion:^(BOOL finished) {
            _cacheView = nil;
            [_cacheView removeFromSuperview];
        }];
    }];
    [[SDImageCache sharedImageCache] clearMemory];
    _cacheSize = 0;
    _cacheLabel.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
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
