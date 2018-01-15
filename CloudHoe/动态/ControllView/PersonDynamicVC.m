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

@interface PersonDynamicVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property(nonatomic,assign) NSInteger pageNO;
@property (nonatomic,assign) BOOL isRefresh;

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
    self.dataArr = [NSMutableArray array];
    [self getblog];
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
        if ([obj count]) {
            NSMutableArray *arrM = [NSMutableArray array];
//            for (NSDictionary *dic in obj) {
//                PayMentModel *model = [PayMentModel yy_modelWithJSON:dic];
//
//                [arrM addObject:model];
//
//            }
            [self.dataArr addObjectsFromArray:arrM];
            self.pageNO++;
        }
        
        else {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [_tableView reloadData];
        
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    else {
        return 10;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 166+15;
    }
    else {
        return 45+5;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
//    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel labelWithframe:CGRectMake(5, 17, 58, 23) text:@"12/08" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#FFFFFF"];
    label.layer.cornerRadius = label.height/2;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithHexString:@"#10CEC0"];

    [view addSubview:label];

    
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
    
    if (indexPath.section == 0) {
        
        static NSString *cell_id = @"PersonDynamicCell2";
        PersonDynamicCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[PersonDynamicCell2 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cell_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.model = nil;
        return cell;
    }
    else {
        static NSString *cell_id = @"PersonDynamicCell1";
        PersonDynamicCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
        if (!cell) {
            cell = [[PersonDynamicCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cell_id];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.model = nil;
        return cell;
        
    }
    
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
