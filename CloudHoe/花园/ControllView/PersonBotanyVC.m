//
//  PersonBotanyVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PersonBotanyVC.h"
#import "RelateBotanyCell1.h"
#import "AddBotanyVC.h"

@interface PersonBotanyVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UILabel *titleLab;

@end

@implementation PersonBotanyVC

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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"添加" font:SystemFont(14) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getPlants];
}

- (void)getPlants
{
    
    NSMutableDictionary  *paramDic=[[NSMutableDictionary  alloc]initWithCapacity:0];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:Getplant dic:paramDic showHUD:NO response:NO Succed:^(id responseObject) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        
        id obj = responseObject[@"data"];
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in obj) {
                BotanyModel *model = [BotanyModel yy_modelWithJSON:dic];
                [arrM addObject:model];
            }
        }
        self.dataArr = arrM;
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)addAction
{
    AddBotanyVC *vc = [[AddBotanyVC alloc] init];
    vc.title = @"添加植物";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
//    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
    //    return 44;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        return UITableViewCellEditingStyleDelete;
    };
    return UITableViewCellEditingStyleNone;

}

//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexpath {
    
    return @"删除";
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self cellctionAction:self.dataArr[indexPath.row]];
//    [self.dataArr removeObjectAtIndex:indexPath.row];
//    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_id = @"cell";
    RelateBotanyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[RelateBotanyCell1 alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cell_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor clearColor];
        cell.block = ^(BotanyModel *model) {
            

        };
    }
    BotanyModel *model = self.dataArr[indexPath.row];

    cell.model = model;
    if (self.mark == 1) {
        cell.deviceBtn.hidden = YES;
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
