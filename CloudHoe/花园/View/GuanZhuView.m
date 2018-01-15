//
//  GuanZhuView.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/8.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "GuanZhuView.h"
#import "UserCell1.h"

@interface GuanZhuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;



@end

@implementation GuanZhuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-416, kScreenWidth, 416)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    UIButton *delBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-30-30, baseView.top-30-7, 30, 30) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"chhao" selected:nil];
    [self addSubview:delBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *LiangGuangBtn = [UIButton buttonWithframe:CGRectMake(baseView.centerX-45, 0-45, 85, 90) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"Group 7" selected:nil];
    [baseView addSubview:LiangGuangBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 55, baseView.width, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [baseView addSubview:line];
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, line.bottom, kScreenWidth, baseView.height-line.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [baseView addSubview:_tableView];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)delAction
{
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _dataArr.count;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    //    return 44;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    UserCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UserCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.model = nil;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
