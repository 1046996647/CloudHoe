//
//  PersonDynamicVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PersonDynamicVC.h"
#import "PersonDynamicCell1.h"
#import "PersonDynamicCell2.h"
#import "DynamicDetailVC.h"

@interface PersonDynamicVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic,assign) NSInteger pageNO;
@property (nonatomic,assign) BOOL isRefresh;
// 原始数据
@property(nonatomic,strong) NSMutableArray *resourceArray;

@end

@implementation PersonDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    // 上拉刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//        if (self.dataArr.count > 0) {
//            // 搜索职位
//            [self getblog];
//        }
//
//    }];
    
    self.pageNO = 1;
    self.resourceArray = [NSMutableArray array];
    [self getblog];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

// 3.6    我的订单-进行中订单
- (void)getblog
{
    if (!self.isRefresh) {
        [SVProgressHUD show];
        
    }
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc] initWithCapacity:0];
//    [paramDic setValue:@(self.pageNO) forKey:@"row"];
//    [paramDic setValue:@15 forKey:@"pagesize"];

    [AFNetworking_RequestData requestMethodPOSTUrl:Getmylog dic:paramDic showHUD:NO response:YES Succed:^(id responseObject) {
        
        self.isRefresh = YES;
        [SVProgressHUD dismiss];
//        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        id obj = responseObject[@"data"];
        if ([obj isKindOfClass:[NSArray class]]) {
            
            if ([obj count]) {
                // 添加刷新的数据，再重新分类
                [self.resourceArray addObjectsFromArray:obj];
                
                NSMutableArray *arrM = [NSMutableArray array];
                NSMutableArray *arrM1 = [NSMutableArray array];
                
                // 去掉一样日期（如：2013-12）
                for (NSDictionary *dic in self.resourceArray) {
                    DynamicStateModel *model = [DynamicStateModel yy_modelWithJSON:dic];
                    if (![arrM containsObject:model.firstTime]) {
                        
                        [arrM addObject:model.firstTime];
                        
                        // 筛选出组头的数据
                        TimeModel *timeModel = [[TimeModel alloc] init];
                        timeModel.timeStr = model.firstTime;
                        [arrM1 addObject:timeModel];
                    }
                }
                
                // 归类
                for (TimeModel *timeModel in arrM1) {
                    
                    for (NSDictionary *dic in self.resourceArray) {
                        
                        DynamicStateModel *model = [DynamicStateModel yy_modelWithJSON:dic];
                        
                        // 筛选出每组的数据
                        if ([timeModel.timeStr isEqualToString:model.firstTime]) {
                            [timeModel.headCellArray addObject:model];
                        }
                    }
                    
                }
                
                [self.tableView.mj_footer endRefreshing];
                
                self.dataArray = arrM1;
                [self.tableView reloadData];
                
                self.pageNO++;
            }
            
            else {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }

    } failure:^(NSError *error) {
        self.isRefresh = YES;
        [SVProgressHUD dismiss];
//        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;

//    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TimeModel *timeModel = _dataArray[section];
    return timeModel.headCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeModel *timeModel = _dataArray[indexPath.section];

    DynamicStateModel *model = timeModel.headCellArray[indexPath.row];
    return model.cellHeight;
//    if (indexPath.section == 0) {
//        return 166+15;
//    }
//    else {
//        return 45+5;
//
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 55;

    }
    else {
        return (55-15);

    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TimeModel *timeModel = _dataArray[section];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
//    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithframe:CGRectMake(5, 17, 58, 23) text:timeModel.timeStr font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#FFFFFF"];
    label.layer.cornerRadius = label.height/2;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithHexString:@"#10CEC0"];

    [view addSubview:label];

    if (section == 0) {
        view.height = 55;
        label.top = 17;
    }
    else {
        view.height = 55-15;
        label.top = 2;
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
    
        static NSString *cell_id = @"PersonDynamicCell2";
        PersonDynamicCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[PersonDynamicCell2 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cell_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
    
        TimeModel *timeModel = _dataArray[indexPath.section];
        cell.model = timeModel.headCellArray[indexPath.row];
        return cell;
    
//    if (indexPath.section == 0) {
//
//        static NSString *cell_id = @"PersonDynamicCell2";
//        PersonDynamicCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
//        if (!cell) {
//            cell = [[PersonDynamicCell2 alloc] initWithStyle:UITableViewCellStyleDefault
//                                            reuseIdentifier:cell_id];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        cell.model = nil;
//        return cell;
//    }
//    else {
//        static NSString *cell_id = @"PersonDynamicCell1";
//        PersonDynamicCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
//        if (!cell) {
//            cell = [[PersonDynamicCell1 alloc] initWithStyle:UITableViewCellStyleDefault
//                                            reuseIdentifier:cell_id];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
//        }
//        cell.model = nil;
//        return cell;
//
//    }
    
    
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TimeModel *timeModel = _dataArray[indexPath.section];
    DynamicStateModel *model = timeModel.headCellArray[indexPath.row];
    
    DynamicDetailVC *vc = [[DynamicDetailVC alloc] init];
    vc.title = @"详情";
    vc.model1 = model;
    vc.mark = 1;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
