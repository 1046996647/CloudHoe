//
//  HomeVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "HomeVC.h"
#import "DynamicStateCell.h"
#import "HeaderView.h"
#import "ReleaseDynamicVC.h"
#import "DynamicDetailVC.h"


@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) HeaderView *headView;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 头视图
    HeaderView *headView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    
    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 32, 32) text:@"发布" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [viewBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
    
    [self getHotblog];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)getHotblog
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
//    [paramDic  setValue:@8 forKey:@"userId"];
//    [paramDic  setValue:@"7db9e4b81a16ef15e195599fc4de0eae" forKey:@"Token"];
//    [paramDic  setValue:@"test" forKey:@"test"];// 测试

    [AFNetworking_RequestData requestMethodPOSTUrl:GetHotblog dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dic in responseObject[@"data"]) {
            DynamicStateModel *model = [DynamicStateModel yy_modelWithJSON:dic];
            [arrM addObject:model];
        }
        self.dataArr = arrM;
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)releaseAction
{
    ReleaseDynamicVC *vc = [[ReleaseDynamicVC alloc] init];
    vc.title = @"发布动态";
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
//        return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicStateModel *model = self.dataArr[indexPath.row];

    return model.cellHeight;
//    return 322+10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    DynamicStateCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[DynamicStateCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.model = self.dataArr[indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DynamicStateModel *model = self.dataArr[indexPath.row];

    DynamicDetailVC *vc = [[DynamicDetailVC alloc] init];
    vc.title = @"详情";
    vc.model1 = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
