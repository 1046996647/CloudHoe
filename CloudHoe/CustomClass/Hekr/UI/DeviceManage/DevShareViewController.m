//
//  DevShareViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DevShareViewController.h"
#import <AFNetworking.h>
#import <HekrAPI.h>
#import "GiFHUD.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface DevShareViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DevShareViewController
{
    UILabel *_managerName;
    BOOL _isShow;
    UITableView *_tableView;
    HekrDevice *_data;
    NSMutableArray *_dataArray;
}

- (instancetype)initWithDATA:(HekrDevice *)data isShow:(BOOL)isshow{
    self = [super init];
    if (self) {
        _data = data;
        _isShow = isshow;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = getViewBackgroundColor();
    _dataArray = [NSMutableArray new];
    [self initNavView];
    [self createViews];
    [self getDataFromUrl];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"DevShare"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"DevShare"];
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"共享信息", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
//    label.backgroundColor = getCellLineColor();
//    [self.view addSubview:label];
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"共享信息" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataFromUrl{
    [GiFHUD showWithOverlay];
    AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
    
    NSString *tid=nil;
    if (_data.devType == HekrDeviceTypeAnnex) {
        tid = [NSString stringWithFormat:@"%@",_data.indTid];
    }
    else{
        tid = [NSString stringWithFormat:@"%@",_data.tid];
    }
    NSString *url= nil;
    if (_isShow) {
        url= [NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization?grantor=%@&ctrlKey=%@&devTid=%@",_data.props[@"ownerUid"],_data.props[@"ctrlKey"],tid];
    }
    else{
        url= [NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization?grantor=%@&ctrlKey=%@&devTid=%@&grantee=%@",_data.props[@"ownerUid"],_data.props[@"ctrlKey"],tid,[Hekr sharedInstance].user.uid];
    }
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GiFHUD dismiss];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_dataArray addObjectsFromArray:responseObject];
            if (_isShow) {
                DDLogInfo(@"[属主获取授权列表]：%@",responseObject);
                if (_dataArray.count == 0) {
                    _managerName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
                }else{
                    _managerName.text = _dataArray[0][@"grantorName"];
                    _managerName.text = _managerName.text.length > 0 ? _managerName.text : NSLocalizedString(@"游客", nil);
                    [_tableView reloadData];
                }
            }
            else{
                DDLogInfo(@"[非属主获取授权列表]：%@",responseObject);
                _managerName.text = _dataArray.firstObject[@"grantorName"];
                _managerName.text = _managerName.text.length > 0 ? _managerName.text : @"未命名";
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GiFHUD dismiss];
        if ([APIError(error) isEqualToString:@"0"]) {
            [self.view.window makeToast:NSLocalizedString(@"授权信息获取失败", nil) duration:1.0 position:@"center"];
        }else{
            [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
        }
        
    }];
}

- (void)createViews{
    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(0, Vrange(10)+StatusBarAndNavBarHeight, ScreenWidth, Vrange(110))];
    upView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:upView];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Hrange(30), (Vrange(110)-Hrange(34))/2, Hrange(34), Hrange(34))];
    image.image = [UIImage imageNamed:@"icon_administrator"];
    [upView addSubview:image];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+Hrange(30), 0, 85, Vrange(110))];
    label.text = NSLocalizedString(@"设备管理员", nil);
    label.textColor = getTitledTextColor();
    label.font = [UIFont systemFontOfSize:16];
    [upView addSubview:label];
    _managerName = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - Hrange(30) - 200, 0, 200, Vrange(110))];
    _managerName.textColor = getDescriptiveTextColor();
    _managerName.font = [UIFont systemFontOfSize:16];
    _managerName.textAlignment = NSTextAlignmentRight;
    [upView addSubview:_managerName];
    
    if (_isShow == YES) {
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(30), CGRectGetMaxY(upView.frame)+Vrange(58), 100, 12)];
        shareLabel.text = NSLocalizedString(@"设备共享者", nil);
        shareLabel.textColor = getTitledTextColor();
        shareLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:shareLabel];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(shareLabel.frame)+Vrange(20), ScreenWidth, Vrange(110)*4)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"devShareCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"devShareCell"];
    }
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(Hrange(30), (Vrange(110)-Hrange(34))/2, Hrange(34), Hrange(34))];
    image.image = [UIImage imageNamed:@"icon_member"];
    [cell.contentView addSubview:image];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+Hrange(30), 0, 200, Vrange(110))];
    name.textColor = getDescriptiveTextColor();
    name.font = [UIFont systemFontOfSize:16];
    name.text = _dataArray[indexPath.row][@"granteeName"];
    if (name.text.length <= 0) {
        name.text = NSLocalizedString(@"游客", nil);
    }
    [cell.contentView addSubview:name];
    
    UILabel *downLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Vrange(110)-0.5, ScreenWidth, 0.5)];
    downLabel.backgroundColor = getCellLineColor();
    [cell.contentView addSubview:downLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = getCellBackgroundColor();
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(110);
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = nil;
        if (_data.devType == HekrDeviceTypeAnnex) {
            if (!_data.accredit) {
                [self showAlertPromptWithTitle:@"子设备无法取消授权，请到网关取消！" actionCallback:nil];

            }
            else{
                [self showAlertPromptWithTitle:@"该版本不支持删除授权子设备！" actionCallback:nil];

            }
            return;
        }
        else{
            dic = @{@"grantor":[Hekr sharedInstance].user.uid,
                    @"ctrlKey":_data.props[@"ctrlKey"],
                    @"grantee":_dataArray[indexPath.row][@"grantee"],
                    @"devTid":_data.tid};
        }
        WS(weakSelf);
        AFHTTPSessionManager *manager = [[Hekr sharedInstance]sessionWithDefaultAuthorization];
        [manager DELETE:@"http://user.openapi.hekr.me/authorization?" parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[删除授权关系]：%@",responseObject);
            [_dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([APIError(error) isEqualToString:@"0"]) {
                [weakSelf showAlertPromptWithTitle:@"取消授权失败" actionCallback:nil];

            }else{
                [weakSelf showAlertPromptWithTitle:APIError(error) actionCallback:nil];

            }
        }];
        
    } else {
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSLocalizedString(@"删除", nil);
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
