//
//  SsoBindViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SsoBindViewController.h"
#import "Tool.h"
#import "SsoBindTableViewCell.h"
#import "HekrAPI.h"
#import "GiFHUD.h"
#import <SHAlertViewBlocks.h>

@interface SsoBindViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong)NSMutableDictionary *ssoStatus;
@property (nonatomic, strong)NSDictionary *ssoImg;
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSDictionary *typeDic;
@property (nonatomic, assign)BOOL isToast;
@end

@implementation SsoBindViewController

- (instancetype)initWithInfo:(NSMutableDictionary *)info{
    self = [super init];
    if (self) {
        _dataDic = info;
        
        _ssoStatus = [[NSMutableDictionary alloc]initWithDictionary:@{@"QQ":NSLocalizedString(@"未绑定", nil),
                                                                      @"WECHAT":NSLocalizedString(@"未绑定", nil),
                                                                      @"SINA":NSLocalizedString(@"未绑定", nil),
                                                                      @"TWITTER":NSLocalizedString(@"未绑定", nil),
                                                                      @"GOOGLE":NSLocalizedString(@"未绑定", nil),
                                                                      @"FACEBOOK":NSLocalizedString(@"未绑定", nil)} copyItems:NO];
        
        
        for (NSString *str in _dataDic[@"thirdAccount"]) {
            if ([str isEqualToString:@"QQ"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"QQ"];
            }else if ([str isEqualToString:@"WECHAT"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"WECHAT"];
            }else if ([str isEqualToString:@"SINA"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"SINA"];
            }else if ([str isEqualToString:@"TWITTER"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"TWITTER"];
            }else if ([str isEqualToString:@"GOOGLE"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"GOOGLE"];
            }else if ([str isEqualToString:@"FACEBOOK"]) {
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:@"FACEBOOK"];
            }
        }
        
        NSDictionary *socialData = [Tool getProfileJsonData];
        
        if (![[socialData objectForKey:KeyOfSocialWeibo] boolValue]) {
            [_ssoStatus removeObjectForKey:@"SINA"];
        }
        if (![[socialData objectForKey:KeyOfSocialQQ] boolValue]) {
            [_ssoStatus removeObjectForKey:@"QQ"];
        }
        if (![[socialData objectForKey:KeyOfSocialWeixin] boolValue]) {
            [_ssoStatus removeObjectForKey:@"WECHAT"];
        }
        if (![[socialData objectForKey:KeyOfSocialGoogle] boolValue]) {
            [_ssoStatus removeObjectForKey:@"GOOGLE"];
        }
        if (![[socialData objectForKey:KeyOfSocialFacebook] boolValue]) {
            [_ssoStatus removeObjectForKey:@"FACEBOOK"];
        }
        if (![[socialData objectForKey:KeyOfSocialTwitter] boolValue]) {
            [_ssoStatus removeObjectForKey:@"TWITTER"];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleArray = _ssoStatus.allKeys;
    _typeDic = @{@"QQ":KeyOfSocialQQ,@"WECHAT":KeyOfSocialWeixin,@"SINA":KeyOfSocialWeibo,@"TWITTER":KeyOfSocialTwitter,@"GOOGLE":KeyOfSocialGoogle,@"FACEBOOK":KeyOfSocialFacebook};
    _ssoImg = @{@"QQ":@{NSLocalizedString(@"已绑定", nil):@"ic_user_qqS",NSLocalizedString(@"未绑定", nil):@"ic_user_qqN"},
                @"WECHAT":@{NSLocalizedString(@"已绑定", nil):@"ic_user_wxS",NSLocalizedString(@"未绑定", nil):@"ic_user_wxN"},
                @"SINA":@{NSLocalizedString(@"已绑定", nil):@"ic_user_sinaS",NSLocalizedString(@"未绑定", nil):@"ic_user_sinaN"},
                @"GOOGLE":@{NSLocalizedString(@"已绑定", nil):@"ic_user_gS",NSLocalizedString(@"未绑定", nil):@"ic_user_gN"},
                @"FACEBOOK":@{NSLocalizedString(@"已绑定", nil):@"ic_user_fbS",NSLocalizedString(@"未绑定", nil):@"ic_user_fbN"},
                @"TWITTER":@{NSLocalizedString(@"已绑定", nil):@"ic_user_twS",NSLocalizedString(@"未绑定", nil):@"ic_user_twN"}};
    _isToast = YES;
    self.view.backgroundColor = getViewBackgroundColor();
    [self initNavView];
    [self createTableView];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"绑定管理" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarAndNavBarHeight + Vrange(32), Width, Vrange(100)*_titleArray.count) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}

#pragma mark --TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SsoBindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ssoBindCell"];
    if (cell == nil) {
        cell = [[SsoBindTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ssoBindCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *ssoTitle = _titleArray[indexPath.row];
    NSDictionary *img = [_ssoImg objectForKey:ssoTitle];
    NSString *status = [_ssoStatus objectForKey:ssoTitle];
    [cell updataWithTitle:ssoTitle Img:[img objectForKey:status] Status:status];
    cell.backgroundColor = getCellBackgroundColor();
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *phoneNumber;
    NSString *email;
    if (_dataDic[@"phoneNumber"] && ![_dataDic[@"phoneNumber"] isKindOfClass:[NSNull class]]) {
        phoneNumber = _dataDic[@"phoneNumber"];
    }
    if (_dataDic[@"email"] && ![_dataDic[@"email"] isKindOfClass:[NSNull class]]){
        email = _dataDic[@"email"];
    }
    if (!(phoneNumber && phoneNumber.length > 0) && !(email && email.length > 0)) {
        if (_isToast == YES) {
            _isToast = NO;
            [self performSelector:@selector(toastDismiss) withObject:nil afterDelay:1.3];
            [self.view.window makeToast:NSLocalizedString(@"请先绑定手机号或邮箱", nil) duration:1.0 position:@"center"];
        }
        return;
        
    }
    
    
    if ([[_ssoStatus objectForKey:_titleArray[indexPath.row]] isEqualToString:NSLocalizedString(@"已绑定", nil)]) {
        
        [self showAlertNoMsgWithTitle:@"您是否要解除绑定？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
            [GiFHUD showWithOverlay:self.view];
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://uaa-openapi.hekr.me/account/unbind?" parameters:@{@"type":_titleArray[indexPath.row],@"pid":[Hekr sharedInstance].pid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DDLogInfo(@"[解除%@绑定]%@",_titleArray[indexPath.row],responseObject);
                [GiFHUD disMiss];
                [_ssoStatus setValue:NSLocalizedString(@"未绑定", nil) forKey:_titleArray[indexPath.row]];
                [_tableView reloadData];
                NSArray *arr = _dataDic[@"thirdAccount"];
                NSMutableArray *thirdAccountArr = [[NSMutableArray alloc]initWithArray:arr];
                [thirdAccountArr removeObject:_titleArray[indexPath.row]];
                [_dataDic setValue:thirdAccountArr forKey:@"thirdAccount"];
                [self.deletage refurbishSsoImg:_dataDic];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GiFHUD disMiss];
                if ([APIError(error) isEqualToString:@"0"]) {
                    [self.view.window makeToast:NSLocalizedString(@"解除失败", nil) duration:1.0 position:@"center"];
                }else{
                    [self.view.window makeToast:NSLocalizedString(APIError(error), nil) duration:1.0 position:@"center"];
                }
                
            }];
        }];
        
    }else{
        //绑定
        NSString *type = [_titleArray objectAtIndex:indexPath.row];

        [[Hekr sharedInstance] sso:_typeDic[type] controller:self.view.window.rootViewController ssoType:HekrSSOBind anonymous:YES callback:^(id token, id user, NSError *error) {
            
            [GiFHUD disMiss];
            if (token) {
                [self.view.window makeToast:NSLocalizedString(@"该账号已被绑定", nil) duration:1.0 position:@"center"];
                return;
            }else if([user isKindOfClass:[NSString class]]){
                [_ssoStatus setValue:NSLocalizedString(@"已绑定", nil) forKey:_titleArray[indexPath.row]];
                [_tableView reloadData];
                NSArray *arr = _dataDic[@"thirdAccount"];
                NSMutableArray *thirdAccountArr = [[NSMutableArray alloc]initWithArray:arr];
                [thirdAccountArr addObject:_titleArray[indexPath.row]];
                [_dataDic setValue:thirdAccountArr forKey:@"thirdAccount"];
                [self.deletage refurbishSsoImg:_dataDic];
            }else{
                [self.view.window makeToast:NSLocalizedString(@"授权失败", nil) duration:1.0 position:@"center"];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Vrange(100);
}

- (void)toastDismiss{
    _isToast = YES;
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
