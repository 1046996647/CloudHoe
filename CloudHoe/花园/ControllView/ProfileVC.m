//
//  ProfileVC.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/8.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "ProfileVC.h"
#import "PersonalCenterVC.h"
#import "PersonBotanyVC.h"
#import "LoginVC.h"
#import "NavigationController.h"
#import "AppDelegate.h"
#import "MyDeviceVC.h"

@interface ProfileVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,strong) UIImageView *headView;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) UIButton *headBtn;
@property(nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) NSArray *dataArr;
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation ProfileVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 175)];
    //    _bgView.backgroundColor = [UIColor whiteColor];
    
    // 大图
    _imgView = [UIImageView imgViewWithframe:CGRectMake(0, 0, kScreenWidth, _bgView.height) icon:@""];
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_imgView];
//    _imgView.backgroundColor = [UIColor redColor];

    
    // 用户头像及姓名
    _headView = [UIImageView imgViewWithframe:CGRectMake(15, 95, 55, 55) icon:@""];
    _headView.layer.cornerRadius = _headView.height/2;
    _headView.layer.masksToBounds = YES;
    //    _imgView1.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:_headView];
//    _headView.backgroundColor = [UIColor greenColor];
    
    // 赵诗怡
    _nameLab = [UILabel labelWithframe:CGRectMake(_headView.right+10, _headView.centerY-11, 52, 22) text:@"" font:[UIFont boldSystemFontOfSize:16] textAlignment:NSTextAlignmentLeft textColor:@"#FFFFFF"];
    [_bgView addSubview:_nameLab];
    
    // 编辑资料
    UIButton *editBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-15-100, _headView.centerY-15, 100, 30) text:@"" font:[UIFont systemFontOfSize:12] textColor:@"#FFFFFF" backgroundColor:@"" normal:@"bianji" selected:nil];
    [_bgView addSubview:editBtn];
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [editBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];

    UILabel *editLab = [UILabel labelWithframe:CGRectMake(editBtn.width-59-20, 0, 59, editBtn.height) text:@"编辑资料" font:[UIFont boldSystemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:@"#FFFFFF"];
    [editBtn addSubview:editLab];
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+196)];
    //    _bgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [UIButton buttonWithframe:CGRectMake(20, 196, kScreenWidth-40, 44) text:@"退出登录" font:[UIFont systemFontOfSize:16] textColor:@"#FFFFFF" backgroundColor:@"#B0B0B0" normal:nil selected:nil];
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    [footView addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(exitAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.dataArr = @[@[@{@"image":@"树叶a",@"title":@"我的植物"}
                       ,@{@"image":@"设备",@"title":@"我的设备"}
                       ],
                     @[@{@"image":@"关于我们",@"title":@"关于我们"}
                       //                       ,@{@"image":@"107",@"title":@"薪资测评"}
                       ]
                     ];
    
    _tableView = [UITableView tableViewWithframe:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTopHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = _bgView;
    _tableView.tableFooterView = footView;

    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PersonModel *model = [InfoCache unarchiveObjectWithFile:Person];
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"img"]];

    [_headView sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"mrtx"]];
    
    if (model.nikename.length == 0) {
        _nameLab.text = @"未设置";
        
    }
    else {
        _nameLab.text = model.nikename;
        CGSize size = [NSString textLength:model.nikename font:_nameLab.font];
        _nameLab.width = size.width;
//        _headBtn.width = _nameLab.right+15;
    }
    
}

- (void)exitAction
{
    [InfoCache archiveObject:nil toFile:@"Token"];
    [InfoCache saveValue:@0 forKey:@"LoginedState"];
    
    LoginVC *loginVC = [[LoginVC alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    
    AppDelegate *delegate = [AppDelegate share];
    delegate.window.rootViewController = nav;
}

- (void)editAction
{
    PersonalCenterVC *vc = [[PersonalCenterVC alloc] init];
    vc.title = @"个人信息";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr[section] count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;// 为0无效
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell_id = @"PersonDynamicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cell_id];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            PersonBotanyVC *vc = [[PersonBotanyVC alloc] init];
            vc.title = @"我的植物";
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            MyDeviceVC *vc = [[MyDeviceVC alloc] init];
            vc.title = @"我的设备";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    
}


@end
