//
//  SexVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/10.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "SexVC.h"

@interface SexVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *leftDataList;
@property(nonatomic,strong) UIImageView *markImg;

@end

@implementation SexVC

- (UITableView *)tableView
{
    if (!_tableView) {
        //列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-kTopHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.scrollEnabled = NO;
//        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftDataList = @[@"男",@"女"

                          ];
    
    UIImageView *markImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15-18, 0, 18, 46)];
    markImg.image = [UIImage imageNamed:@"xuanze"];
    markImg.contentMode = UIViewContentModeScaleAspectFit;
    self.markImg = markImg;
    
    [self.view addSubview:self.tableView];
    
    // 右上角按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 22)];
    UIButton *viewBtn = [UIButton buttonWithframe:rightView.bounds text:@"确定" font:SystemFont(15) textColor:@"#ffffff" backgroundColor:nil normal:nil selected:nil];
    [rightView addSubview:viewBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [viewBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)okAction
{
//    if (self.sex.length == 0) {
//
//        [self.navigationController popViewControllerAnimated:YES];
//
//        return;
//    }
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    [paramDic  setObject:self.sex forKey:@"sex"];
    
    [AFNetworking_RequestData requestMethodPOSTUrl:SetUserInfo dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
        
//        self.person.birthday = self.sex;
//        NSLog(@"%@",responseObject);
        PersonModel *person = [PersonModel yy_modelWithJSON:responseObject[@"data"]];
        [InfoCache archiveObject:person toFile:Person];
        
        //        if (self.block) {
        //            self.block(_tv.text);
        //        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftDataList count];
    //    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        
    }
    cell.textLabel.text = self.leftDataList[indexPath.row];
//    cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取单元格
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:self.markImg];
    
    self.sex = cell.textLabel.text;
}

@end
