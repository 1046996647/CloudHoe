//
//  MyDeviceVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/10.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "MyDeviceVC.h"
#import "UILabel+WLAttributedString.h"
#import "SetDeviceVC.h"
#import "ScanVC.h"
#import "ConfigurationNetController.h"
#import <HekrSDK.h>
#import "DevicesModel.h"
#import "GTMBase64.h"
#import "EasyMacro.h"
#import "GiFHUD.h"
#import "Tool.h"

@interface MyDeviceVC ()<UITableViewDelegate,UITableViewDataSource,ModelDelegate>

@property (nonatomic,strong) NSArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) DevicesModel * model;//数据源model

@property (nonatomic ,strong) NSArray *lanDevices;


@end

@implementation MyDeviceVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.lanDevices = [[Hekr sharedInstance] getLanDevcies];

    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 10, kScreenWidth, kScreenHeight-kTopHeight-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"添加" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DevManager"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.model = [DevicesModel new];
    self.model.delegate = self;
}


- (void)addAction
{
    ConfigurationNetController *vc = [[ConfigurationNetController alloc] init];
    //            vc.title = @"设备";
    //    vc.model1 = model;
    [self.navigationController pushViewController:vc animated:YES];
//    ScanVC *vc = [[ScanVC alloc] init];
//    vc.title = @"绑定设备";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ModelDelegate
- (void)erroronLoad:(NSError *)error{
//    [GiFHUD disMiss];
    [self.view.window makeToast:NSLocalizedString(@"网络超时", nil) duration:1.0 position:@"center"];
}

// 刷新成功后调用
- (void)onLoad{
    
    [SVProgressHUD dismiss];
//    if (self.model.allDatas.count<=0) {
//        [self createViews];
//    }
    [_tableView reloadData];
//    NSNotification *notification = [NSNotification notificationWithName:@"ManagerViewReload" object:nil userInfo:@{@"model":self.model}];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];

}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.allDatas.count;
//    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 46;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];

        UIButton *setBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-60, 0, 60, 46) text:@"设置" font:[UIFont systemFontOfSize:14] textColor:@"#4A90E2" backgroundColor:@"" normal:@"" selected:nil];
//        setBtn.tag = 100;
        [cell.contentView addSubview:setBtn];
        [setBtn addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    }
    HekrDevice *dev = self.model.allDatas[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"设备"];

    cell.textLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.text = @"设备号：12346 (在线)";
    
    if (dev.online == YES) {
        cell.textLabel.text = [NSString stringWithFormat:@"设备号：%@(在线)",dev.props[@"devTid"]];
        [cell.textLabel wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(在线)"];

    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"设备号：%@(离线)",dev.props[@"devTid"]];
        [cell.textLabel wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(离线)"];
        
    }
    


    return cell;
}

- (void)setAction
{
    SetDeviceVC *vc = [[SetDeviceVC alloc] init];
    vc.title = @"设备号：12346";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
