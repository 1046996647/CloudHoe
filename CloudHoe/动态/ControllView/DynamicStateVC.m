//
//  DynamicStateVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicStateVC.h"
#import "FSScrollContentView.h"
#import "DynamicStateCell.h"
#import "HeaderView.h"
#import "ReleaseDynamicVC.h"
#import "DynamicDetailVC.h"

@interface DynamicStateVC ()<UITableViewDelegate,UITableViewDataSource,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) HeaderView *headView;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation DynamicStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = nil;
    
    FSSegmentTitleView *titleView5 = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, 170, 44) titles:@[@"关注",@"热门",@"附近"] delegate:self indicatorType:2];
    //    titleView5.titleSelectFont = [UIFont systemFontOfSize:20];
    titleView5.indicatorColor = [UIColor clearColor];
    titleView5.titleFont = SystemFont(16);
    titleView5.titleSelectFont = [UIFont boldSystemFontOfSize:16];
    titleView5.titleNormalColor = [UIColor colorWithHexString:@"#efefef"];
    titleView5.titleSelectColor = [UIColor colorWithHexString:@"#ffffff"];
    self.navigationItem.titleView = titleView5;

    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    UIButton *viewBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 32, 32) text:@"发布" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [viewBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:viewBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

- (void)releaseAction
{
    ReleaseDynamicVC *vc = [[ReleaseDynamicVC alloc] init];
    vc.title = @"发布动态";
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 322+10;
    //    return 44;
    
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
    
    cell.model = nil;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DynamicDetailVC *vc = [[DynamicDetailVC alloc] init];
    vc.title = @"详情";
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    
}

@end
