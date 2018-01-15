//
//  SetDeviceVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/10.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "SetDeviceVC.h"
#import "BRPickerView.h"
#import "RelateBotanyVC.h"
#import "AuthorizeVC.h"

@interface SetDeviceVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *leftDataList;
@property(nonatomic,strong) NSArray *rightDataList;

@end

@implementation SetDeviceVC

- (UITableView *)tableView
{
    if (!_tableView) {
        //列表
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftDataList = @[@[@"设备号",@"定时浇水",@"浇水持续时间"],
                          @[@"绑定植物"],
                          @[@"设备授权",@"连接到其他无线路由器"],
                          ];

    self.rightDataList = @[@[@"123456",@"2:00",@"20分钟"],
                           @[@"多肉花盆1"],
                           @[@"好友MAX",@"XXXX路由器"],
                           ];

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+222)];
    //    _bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, 222, kScreenWidth-40, 44) text:@"删除设备" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#B0B0B0" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [footView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = footView;
}

- (void)delAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.leftDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftDataList[section] count];
    //    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    ReleaseJobModel *model = self.dataArr[section][0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //获取单元格
    __block UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 1) {
            
            NSString *birth = nil;
            //            if (![cell.detailTextLabel.text isEqualToString:@"请选择生日日期"]) {
            //                birth = cell.detailTextLabel.text;
            //            }
            birth = cell.detailTextLabel.text;
            [BRDatePickerView showDatePickerWithTitle:@"定时浇水" dateType:UIDatePickerModeTime defaultSelValue:birth minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:NO resultBlock:^(NSString *selectValue) {
                
                NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
                [paramDic  setObject:selectValue forKey:@"birthday"];
                
                //            [AFNetworking_RequestData requestMethodPOSTUrl:SetUserInfo dic:paramDic showHUD:YES response:NO Succed:^(id responseObject) {
                //
                //                [SVProgressHUD dismiss];
                //
                //                NSLog(@"%@",responseObject);
                //                self.person = [PersonModel yy_modelWithJSON:responseObject[@"data"]];
                //                [InfoCache archiveObject:self.person toFile:Person];
                //
                //                cell.detailTextLabel.text = selectValue;
                //
                //
                //            } failure:^(NSError *error) {
                //
                //                NSLog(@"%@",error);
                //                [SVProgressHUD dismiss];
                //
                //
                //            }];
            }];
            
        }
        
        if (indexPath.row == 2) {
            
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i=0; i<60; i++) {
                [arrM addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            [BRStringPickerView showStringPickerWithTitle:@"浇水持续时间" dataSource:arrM defaultSelValue:arrM[0] isAutoSelect:NO resultBlock:^(id selectValue) {
                
                
                
            }];
            
        }
    }
    if (indexPath.section == 1) {
        
        RelateBotanyVC *vc = [[RelateBotanyVC alloc] init];
        vc.title = @"我的植物";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            AuthorizeVC *vc = [[AuthorizeVC alloc] init];
            vc.title = @"授权";
            [self.navigationController pushViewController:vc animated:YES];
        }
        

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        
    }
    
    cell.textLabel.text = self.leftDataList[indexPath.section][indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.detailTextLabel.text = self.rightDataList[indexPath.section][indexPath.row];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#313131"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

@end
