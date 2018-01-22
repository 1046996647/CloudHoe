//
//  ConcernDynamicVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/18.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ConcernDynamicVC.h"
#import "DynamicStateCell.h"
#import "DynamicDetailVC.h"

@interface ConcernDynamicVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//@property(nonatomic,strong) HeaderView *headView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation ConcernDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight-kTabBarHeight-32) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
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

@end
