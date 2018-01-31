//
//  DeviceManageViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/30.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DeviceManageViewController.h"
#import <HekrSDK.h>
#import "DeviceManageCell.h"
#import "ManagerViewController.h"
#import "DevicesModel.h"
#import "GTMBase64.h"
#import "EasyMacro.h"
#import "GiFHUD.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface DeviceManageViewController ()<UITableViewDelegate, UITableViewDataSource,ModelDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) DevicesModel * model;//数据源model
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIImageView *zoreImg;
@property (nonatomic ,strong) UILabel *zoreLabel;
@property (nonatomic ,strong) HekrNavigationBarView *nav;
@property (nonatomic ,strong) NSArray *lanDevices;

@end

@implementation DeviceManageViewController

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
//    [GiFHUD showWithOverlay:self.view];
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLanDeices:) name:@"onLanDeices" object:nil];
    
    self.lanDevices = [[Hekr sharedInstance] getLanDevcies];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DevManager"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [GiFHUD dismiss];
    [GiFHUD showWithOverlay:self.view];
    self.model = [DevicesModel new];
    self.model.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DevManager"];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [GiFHUD dismiss];
}

-(void)onLanDeices:(NSNotification *)notification{
    self.lanDevices = notification.userInfo[@"lanDevices"];
    [self.tableView reloadData];
}

- (void)initNavView
{
    if (_nav) {
        return;
    }
    WS(weakSelf);
    _nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"设备管理" leftBarButtonAction:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:_nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createViews{
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Hrange(168)+20)];
    bgImageView.center = CGPointMake(self.view.center.x, self.view.center.y-StatusBarAndNavBarHeight/2);
    [self.view addSubview:bgImageView];
    
    _zoreImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Hrange(160), Hrange(108))];
    _zoreImg.center = CGPointMake(Width/2, Hrange(84)+10);
    _zoreImg.image = [UIImage imageNamed:@"default"];
    _zoreImg.hidden = NO;
    [bgImageView addSubview:_zoreImg];
    
    _zoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zoreImg.frame)+Hrange(60), Width, 20)];
    _zoreLabel.textAlignment = NSTextAlignmentCenter;
    _zoreLabel.text = NSLocalizedString(@"您当前没有绑定设备", nil);
    _zoreLabel.font = getNavTitleFont();
    _zoreLabel.textColor = getDescriptiveTextColor();
    _zoreLabel.hidden = NO;
    [bgImageView addSubview:_zoreLabel];
}

- (void)erroronLoad:(NSError *)error{
    [GiFHUD disMiss];
    [self.view.window makeToast:NSLocalizedString(@"网络超时", nil) duration:1.0 position:@"center"];
}

- (void)onLoad{
    if (self.model.allDatas.count<=0) {
        [self createViews];
    }
    [_tableView reloadData];
    NSNotification *notification = [NSNotification notificationWithName:@"ManagerViewReload" object:nil userInfo:@{@"model":self.model}];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [GiFHUD disMiss];
}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CoverViewRectMake];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[DeviceManageCell class] forCellReuseIdentifier:@"dmcell"];
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_model.allDatas.count > 0) {
        _zoreLabel.hidden = YES;
        _zoreImg.hidden = YES;
    }else{
        _zoreImg.hidden = NO;
        _zoreLabel.hidden = NO;
    }
    return _model.allDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dmcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = getCellBackgroundColor();
    HekrDevice *dev = self.model.allDatas[indexPath.row];
    [cell updata:dev lanDevices:self.lanDevices];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HekrDevice *dev = _model.allDatas[indexPath.row];
    if ([[Hekr sharedInstance].user.uid isEqualToString:dev.props[@"ownerUid"]]) {
        [self.navigationController pushViewController:[[ManagerViewController alloc] initWith:dev isGranted:YES UID:[Hekr sharedInstance].user.uid] animated:YES];
    }else{
        [self.navigationController pushViewController:[[ManagerViewController alloc] initWith:dev isGranted:NO UID:[Hekr sharedInstance].user.uid] animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(140);
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height) {
        [self.model loadMore];
    }
}



@end
