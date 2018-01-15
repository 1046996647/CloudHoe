//
//  AuthorizeVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/11.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "AuthorizeVC.h"
#import "AuthorizeCell.h"

@interface AuthorizeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation AuthorizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"确定" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
    //    return 44;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    AuthorizeCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[AuthorizeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor clearColor];
        [cell.stateBtn addTarget:self action:@selector(stateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.model = nil;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)stateAction:(UIButton *)btn
{
    
}

@end
