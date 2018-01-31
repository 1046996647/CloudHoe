//
//  GardenVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "GardenVC.h"
#import "ThemeCell.h"
#import "GardenView.h"
#import "GardenView1.h"
#import "AddBotanyVC.h"
#import "ProfileVC.h"

@interface GardenVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) GardenView *headView;
@property(nonatomic,strong) GardenView1 *headView1;

@property (nonatomic, strong) NSMutableArray *plantsArr;// 植物
@property (nonatomic, strong) NSMutableArray *dataArr;// 专题

@end

@implementation GardenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imgView = [UIImageView imgViewWithframe:CGRectMake((kScreenWidth-127)/2, (kScreenHeight-kTopHeight-kTabBarHeight-88)/2, 127, 88) icon:@"Group 2"];
    [self.view addSubview:imgView];
    //    self.imgView = imgView;
    
    UILabel *titleLab = [UILabel labelWithframe:CGRectMake(0, imgView.bottom+2, kScreenWidth, 16) text:@"您的花园未创建专题！" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#999999"];
    [self.view addSubview:titleLab];
    //    self.titleLab = titleLab;
    
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 头视图1
    GardenView1 *headView1 = [[GardenView1 alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
//    self.tableView.tableHeaderView = headView1;
    self.headView1 = headView1;
    [headView1.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [headView1.personBtn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];

    
    // 头视图2
    GardenView *headView = [[GardenView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
//    self.tableView.tableHeaderView = headView;
    self.headView = headView;
//    [headView.addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];

    
    // 尾视图
    UIButton *moreBtn = [UIButton buttonWithframe:CGRectMake(0, 0, kScreenWidth, 54) text:@"查看更多专题" font:[UIFont systemFontOfSize:14] textColor:@"#6F6F6F" backgroundColor:@"#ffffff" normal:@"" selected:nil];
//    [moreBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = moreBtn;
    
    
    
//    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 80, 32) text:@"创建专题" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
//    //    [viewBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
//    viewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//    UIImageView *img = [UIImageView imgViewWithframe:CGRectMake(viewBtn.width-15, 0, 15, viewBtn.height) icon:@"创建实例-1"];
//    img.contentMode = UIViewContentModeScaleAspectFit;
//    [viewBtn addSubview:img];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
    
    [self getUserInfo];

}

// 获取用户信息
- (void)getUserInfo
{
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:GetUserInfo dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
        PersonModel *model = [PersonModel yy_modelWithJSON:responseObject[@"data"]];
        [InfoCache archiveObject:model toFile:Person];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getPlants];
}

- (void)getPlants
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Plants dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];

        id obj = responseObject[@"data"][@"plant"];
        id obj1 = responseObject[@"data"][@"prcontent"];
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in obj) {
                BotanyModel *model = [BotanyModel yy_modelWithJSON:dic];
                [arrM addObject:model];
            }
        }

        if (arrM.count > 0) {
            self.headView.plantsArr = arrM;
            self.tableView.tableHeaderView = self.headView;

        }
        else {
            self.tableView.tableHeaderView = self.headView1;

        }
//        [_tableView reloadData];

        
    } failure:^(NSError *error) {
        
    }];
}

- (void)addAction
{
    AddBotanyVC *vc = [[AddBotanyVC alloc] init];
    vc.title = @"添加植物";
//    vc.model1 = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)personAction
{
    ProfileVC *vc = [[ProfileVC alloc] init];
    vc.title = @"我的";
    //    vc.model1 = model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _dataArr.count;
            return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ThemeModel *model = self.dataArr[indexPath.row];
//
//    return model.cellHeight;
    return 281+10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;

    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [UILabel labelWithframe:CGRectMake(15, 0, kScreenWidth-15, view.height) text:@"最新专题" font:[UIFont boldSystemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-.5, kScreenWidth, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [view addSubview:line];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[ThemeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.model = self.dataArr[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    ThemeModel *model = self.dataArr[indexPath.row];
    
//    DynamicDetailVC *vc = [[DynamicDetailVC alloc] init];
//    vc.title = @"详情";
//    vc.model1 = model;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
