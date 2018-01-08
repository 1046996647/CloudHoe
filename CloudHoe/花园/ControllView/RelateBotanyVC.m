//
//  RelateBotanyVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "RelateBotanyVC.h"
#import "RelateBotanyCell.h"

@interface RelateBotanyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *titleLab;

@end

@implementation RelateBotanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imgView = [UIImageView imgViewWithframe:CGRectMake(0, 64, kScreenWidth, 66) icon:@"kong"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *titleLab = [UILabel labelWithframe:CGRectMake(0, imgView.bottom+30, kScreenWidth, 16) text:@"您的花园未种植任何花草！" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#999999"];
    [self.view addSubview:titleLab];
    self.titleLab = titleLab;
    
    self.titleLab.hidden = YES;
    self.imgView.hidden = YES;

    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"添加" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//    [viewBtn addTarget:self action:@selector(alumbBtnEvent) forControlEvents:UIControlEventTouchUpInside];
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
    return 86;
    //    return 44;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    RelateBotanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[RelateBotanyCell alloc] initWithStyle:UITableViewCellStyleDefault
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
    [self.view makeToast:@"关联植物成功"];
}

@end
