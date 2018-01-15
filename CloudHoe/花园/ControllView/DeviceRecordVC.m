//
//  DeviceRecordVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/11.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DeviceRecordVC.h"
#import "DeviceRecordCell.h"

@interface DeviceRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation DeviceRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"绑定" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAction
{
//    ScanVC *vc = [[ScanVC alloc] init];
//    vc.title = @"绑定设备";
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.dataArr count];
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.dataArr[section] count];
    return 3;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 10;

    }
    else {
        return 50;

    }
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [view addSubview:view1];

    
    UILabel *label = [UILabel labelWithframe:CGRectMake((view.width-74)/2, 0, 74, 50) text:@"已绑定设备" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentRight textColor:@"#D0D0D0"];
    [view1 addSubview:label];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(label.left-10-(125*scaleWidth), label.centerY-.5, 125*scaleWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
    [view1 addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(label.right+10, line1.top, 125*scaleWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
    [view1 addSubview:line2];

    if (section == 0) {
        
        view1.hidden = YES;
    }
    else {
        view1.hidden = NO;

    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;// 为0无效
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell_id = @"PersonDynamicCell";
    DeviceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[DeviceRecordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cell_id];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            cell.backgroundColor = [UIColor clearColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

@end
