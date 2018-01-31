//
//  ConfigWorkViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/31.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigWorkViewController.h"
#import "ConfigDevModel.h"
#import "ConfigStepView.h"
#import "ConfigAniProgressView.h"
#import "CategoryControl.h"
#import "ConfigUnderView.h"
#import "ConfigSetpCell.h"
#import "ConfigStepTitleCell.h"
#import "ConfigFailResultViewController.h"
#import "ConfigPWViewController.h"
#import "HekrNavigationBarView.h"

#import "UIViewController+UIViewControllerExt.h"

@interface ConfigWorkViewController ()<ConfigAniProgressViewDelegate,ConfigUnderViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray<ConfigDevModel *> *configDevs;
@property (nonatomic ,assign) ConfigDeviceType configType;
@property (nonatomic ,copy) NSString *pinCode;
@property (nonatomic ,copy) NSString *ssid;
@property (nonatomic ,copy) NSString *pwd;

@property (nonatomic ,strong) IBOutlet UITableView *table;
@property (nonatomic ,strong) IBOutlet ConfigStepView *setpView;
@property (nonatomic ,strong) IBOutlet ConfigAniProgressView *aniPgsView;
@property (nonatomic ,strong) IBOutlet ConfigUnderView *underView;

@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveUnderContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveStepContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *moveTopContraint;

@property (nonatomic ,assign) BOOL interFunc;

@end

@implementation ConfigWorkViewController

-(void)setConfigType:(ConfigDeviceType )type ssid:(NSString *)ssid password:(NSString *)pwd pinCode:(NSString *)pin{
    _configType = type;
    _ssid = ssid;
    _pwd = pwd;
    _pinCode = pin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索并连接设备";
    [self initNavView];
    
    self.configDevs = [NSMutableArray array];
    _moveTopContraint.constant = StatusBarAndNavBarHeight;

    _aniPgsView.delegate = self;
    [_aniPgsView start];
    
    _setpView.backgroundColor = UIColorFromHex(0xffffff);
    [_setpView start];
//    _setpView.hidden = YES;
    
    _table.tableFooterView = [self footerEmptyView];
    _table.bounces = NO;
    
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _underView.delegate = self;
    [_underView configUnderButtonReset];
    _moveUnderContraint.constant = -Hrange(168);
    [self.view layoutIfNeeded];

    [self startConfigDevice];
    
//    [self performSelector:@selector(textData:) withObject:@(0) afterDelay:2.0f];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:@"Config"];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:@"Config"];

//    [self.navigationController setNavigationBarHidden:NO animated:animated];

//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)dealloc{
//    NSLog(@"%s",__func__);
    [[Hekr sharedInstance] stopConfig];

    [_aniPgsView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initNavView
{
    WS(weakSelf);
    HekrNavigationBarView *navBar = [[HekrNavigationBarView alloc] initWithFrame:BarViewRectMake withTitle:self.title leftBarButtonAction:^{
        if (!weakSelf.aniPgsView.loading) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            
            [weakSelf showAlertPromptWithMsg:@"确定放弃配网吗？" ensureText:@"确定" callback:^(UIAlertAction * _Nonnull action) {
                [[Hekr sharedInstance] stopConfig];
                [weakSelf.navigationController popViewControllerAnimated:YES];

            }];
        }
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:navBar];
}

-(void)startConfigDevice{
    WS(weakSelf);
    [[Hekr sharedInstance] configSearch:_ssid pwd:_pwd pinCode:_pinCode configType:_configType callback:^(id data, NSError *err) {
        if (err) {
//            [weakSelf aniProgressStopConfig];
//            [weakSelf errorServer];
        }else{
            if (data&&[data isKindOfClass:[NSDictionary class]]) {
                [weakSelf getStepDev:data];
            }
        }
    } stepCall:^(NSDictionary *params) {
        NSLog(@"步骤：%@",params);
        if ([[params objectForKey:@"STEP"] integerValue] == ConfigDeviceStepFirst) {
            if ([params objectForKey:@"pinCode"]) {
                weakSelf.pinCode = [params objectForKey:@"pinCode"];
                [weakSelf.setpView configSuccessWithStep:ConfigDeviceStepFirst];
            }else{
                //第一步失败
                [weakSelf aniProgressStopConfig];
                [weakSelf errorServer];
            }
        }else{
            [weakSelf getStepDev:params];
        }
    }];
}

-(void)getStepDev:(NSDictionary *)params{
    for (NSInteger index = 0; index<self.configDevs.count; index++) {
        ConfigDevModel *dev = [self.configDevs objectAtIndex:index];
        if ([[params objectForKey:@"devTid"] isEqualToString:dev.tid]) {
            [dev setConfigDevModel:params];
            [self.configDevs replaceObjectAtIndex:index withObject:dev];
//            [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
            return ;
        }
    }
    ConfigDevModel *dev = [[ConfigDevModel alloc] initWithConfigDevModel:params];
    [self.configDevs addObject:dev];
//    [_table reloadData];
    [self addFirstDev];
}

-(void)addFirstDev{
    if (self.configDevs.count>1) {
        return;
    }
    
    ConfigDevModel *dev = _configDevs.firstObject;
    dev.show = YES;
    [_table reloadData];
//    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    _moveStepContraint.constant = Hrange(100);
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.setpView.hidden = YES;
    }];
}

-(void)successDevice:(NSDictionary *)data{
    if (data) {
        NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil userInfo:@{@"info":data}];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
    }
    [_underView configUnderButtonSuccess:data?YES:NO];

    if (_moveUnderContraint.constant==0) {
        return;
    }
    _moveUnderContraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)errorServer{
    [_aniPgsView fail:@"无法连接服务器"];
    _pinCode = nil;

    [_underView configUnderButtonFail];
    _table.tableFooterView = [self footerFailView];
    _setpView.hidden = YES;
    
    _moveUnderContraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma  mark -- ConfigAniProgressViewDelegate

-(void)aniProgressStopConfig{
    _interFunc = NO;
    [[Hekr sharedInstance] stopConfig];
}

-(void)aniProgressEnd{
    if (_configDevs.count==0) {
        if (_pinCode) {
            [_aniPgsView fail:@"连接路由器失败"];
        }else{
            [_aniPgsView fail:@"无法连接服务器"];
        }
        [_underView configUnderButtonFail];
        _table.tableFooterView = [self footerFailView];
        _setpView.hidden = YES;
        
    }else{
        BOOL show = NO;
        for (ConfigDevModel *dev in _configDevs) {
            if (dev.state) {
                if (dev.step == ConfigDeviceStepFinish) {
                    show = YES;
                }else{
                    dev.step = dev.step+1;
                    dev.state = NO;
                    if (dev.step == ConfigDeviceStepFinish) {
                        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dev.data];
                        [data setObject:@(ConfigDeviceStepFinish) forKey:@"STEP"];
                        [data setObject:@"E002" forKey:@"bindResultMsg"];
                        [data setObject:@(-1) forKey:@"code"];
                        [data setObject:@"设备" forKey:@"name"];
                        dev.data = data;
                    }
                }
            }
        }
        [_table reloadData];
//        if (_moveUnderContraint.constant==0) {
//            [_aniPgsView success];
//            return;
//        }else{
//            [_aniPgsView fail:@"设备连接失败"];
//            [_underView configUnderButtonFail:_configType];
//        }
        if (show) {
            [_aniPgsView success];
//            [_underView configUnderButtonSuccess:YES];
        }else{
            [_aniPgsView fail:@"设备连接失败"];
            [_underView configUnderButtonFail];
        }
    }
    
    _moveUnderContraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)aniProgressTimerFunc{
    BOOL reload = NO;
    NSInteger count = self.configDevs.count;
    for (NSInteger index = 0; index<count; index++) {
        ConfigDevModel *dev = [self.configDevs objectAtIndex:index];
        if ([dev changeCurrentState]) {
            reload = YES;
//            [_table reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
            if (!dev.state) {
                [self performSelector:@selector(successDevice:) withObject:nil afterDelay:2.0f];
            }
            else if (dev.step==ConfigDeviceStepFinish) {
                if ([ConfigDevModel devContentState:dev.data]) {
                    [self performSelector:@selector(successDevice:) withObject:dev.data afterDelay:2.0f];
                }
            }
        }
    }
    if (reload) {
        [_table reloadData];
    }
}


-(void)aniProgressInterFunc{
    NSMutableArray *arr = [NSMutableArray array];
    for (ConfigDevModel *dev in _configDevs) {
        if (dev.step != ConfigDeviceStepFinish && dev.state) {
            [arr addObject:dev.tid];
        }
    }
    if (arr.count>0) {
        _interFunc = YES;
        WS(weakSelf);
        NSString *tids = [arr componentsJoinedByString:@","];
        DDLogInfo(@"aniProgressInterFunc,%@",tids);
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user.openapi.hekr.me/device?" parameters:@{@"page":@(0),@"size":@(arr.count),@"devTid":tids} progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
            if (responseObject&&[responseObject isKindOfClass:[NSArray class]]) {
                if (weakSelf.interFunc) {
                    NSArray *arr = responseObject;
                    for (NSDictionary *dict in arr) {
                        if (dict&&[dict isKindOfClass:[NSDictionary class]]) {
                            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dict];
                            [data setObject:@NO forKey:@"bindResultCode"];
                            [data setObject:@(ConfigDeviceStepFinish) forKey:@"STEP"];
                            [data setObject:@(200) forKey:@"code"];

                            [weakSelf getStepDev:data];
                        }
                    }
//                    if (arr.count>0) {
//                        [weakSelf performSelector:@selector(successDevice:) withObject:nil afterDelay:2.0f];
//                    }
                }
                
            }
        } failure:^(NSURLSessionDataTask * task, NSError * error) {
            
        }];
    }
}

#pragma  mark -- ConfigUnderViewDelegate

-(void)configFinish{
    [[Hekr sharedInstance] stopConfig];
    
    [self popViewController:@"MyDeviceVC"];
}

-(void)configRestart{
    
    WS(weakSelf);
    [self showAlertPromptWithMsg:@"请确保设备断电重启后，重新添加设备" ensureText:@"添加" callback:^(UIAlertAction * _Nonnull action) {

        weakSelf.moveStepContraint.constant = 0;
        [weakSelf.view layoutIfNeeded];
        
        weakSelf.configDevs = [NSMutableArray array];
        weakSelf.table.tableFooterView = [self footerEmptyView];
        [weakSelf.table reloadData];
        
        [weakSelf.aniPgsView start];
        weakSelf.setpView.hidden = NO;
        weakSelf.moveUnderContraint.constant = -Hrange(168);
        [weakSelf.underView configUnderButtonReset];
        
        [UIView animateWithDuration:0.5f animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
        weakSelf.configType = ConfigDeviceTypeNormal;
        weakSelf.pinCode = nil;
        [weakSelf startConfigDevice];
    }];
}
-(void)configSoftAP{
    
    ConfigPWViewController *cpwVC = [[ConfigPWViewController alloc] initWithNibName:@"ConfigPWViewController" bundle:nil];
    [cpwVC setConfigDeviceType:ConfigDeviceTypeSoftAP];
    [self.navigationController pushViewController:cpwVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _configDevs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ConfigDevModel *dev = [self.configDevs objectAtIndex:section];
    return dev.show?7:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        ConfigStepTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetpTitleIdentifier"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConfigStepTitleCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ConfigDevModel *dev = [self.configDevs objectAtIndex:indexPath.section];
        
        [cell setConfigStepWithStep:dev.step state:dev.state device:dev.data show:dev.show];
        
        return cell;
    }else if (indexPath.row==6){
        
        static NSString * cellIder = @"UITableViewCellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIder];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIder];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(0xf7f7f7);
        cell.contentView.backgroundColor = UIColorFromHex(0xf7f7f7);
        
        return cell;
        
    }else{
        ConfigSetpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetpIdentifier"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ConfigSetpCell" owner:self options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(0xf7f7f7);
        cell.contentView.backgroundColor = UIColorFromHex(0xf7f7f7);
        ConfigDevModel *dev = [self.configDevs objectAtIndex:indexPath.section];
        
        NSInteger row = indexPath.row-1;
        
        if (row<dev.step) {
            [cell setConfigStep:row state:1];
        }else if (row==dev.step) {
            [cell setConfigStep:row state:dev.state?1:0];
        }else{
            if (dev.state) {
                if (row==dev.step+1) {
                    [cell setConfigStep:row state:2];
                }else{
                    [cell setConfigStep:row state:3];
                }
            }else{
                [cell setConfigStep:row state:3];
            }
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return Hrange(100);
    }else if (indexPath.row==6){
        return Hrange(40);
    }
    return Hrange(90);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        ConfigDevModel *dev = [self.configDevs objectAtIndex:indexPath.section];
        dev.show = !dev.show;
        
        [_table reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

    }else{
        ConfigDevModel *dev = [self.configDevs objectAtIndex:indexPath.section];
        if (!dev.state&&dev.step==indexPath.row-1) {
            ConfigFailResultViewController *cfrVC = [[ConfigFailResultViewController alloc] initWithNibName:@"ConfigFailResultViewController" bundle:nil];
            [cfrVC setConfigDeviceType:_configType configStep:dev.step device:dev.data];
            [self.navigationController pushViewController:cfrVC animated:YES];
        }
    }
}

-(UIView *)footerEmptyView{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Hrange(40))];
    v.backgroundColor = [UIColor whiteColor];
    return v;
}

-(UIView *)footerFailView{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_table.frame)-Hrange(168))];
    v.backgroundColor = [UIColor whiteColor];
    
    UIImageView *fail = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-Hrange(200))/2, Hrange(336), Hrange(200), Hrange(116))];
    fail.image = [UIImage imageNamed:@"config_fail"];
    fail.alpha = 0;
    [v addSubview:fail];
    
    UILabel *failLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(fail.frame)+Hrange(40), ScreenWidth, Hrange(30))];
    failLabel.textAlignment = NSTextAlignmentCenter;
    failLabel.font = [UIFont systemFontOfSize:14.0f];
    failLabel.textColor = UIColorFromHex(0xfe3824);
    failLabel.alpha = 0;
    [v addSubview:failLabel];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"查看失败原因",nil)];
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, content.length)];
    failLabel.attributedText = content;
    
    UITapGestureRecognizer *protocolTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(failAction)];
    [failLabel addGestureRecognizer:protocolTgr];
    failLabel.userInteractionEnabled = YES;

    [UIView animateWithDuration:1.0f animations:^{
        fail.alpha = 1;
        failLabel.alpha = 1;
    }];
    
    return v;
}

-(void)failAction{
    NSLog(@"fail");
    
    ConfigFailResultViewController *cfrVC = [[ConfigFailResultViewController alloc] initWithNibName:@"ConfigFailResultViewController" bundle:nil];
    [cfrVC setConfigDeviceType:_configType configStep:_pinCode?ConfigDeviceStepSecond:ConfigDeviceStepFirst device:nil];
    [self.navigationController pushViewController:cfrVC animated:YES];
}

#pragma mark--testData
-(void)textData:(NSNumber *)step{
    switch ([step integerValue]) {
        case 0:{
            [_setpView configSuccessWithStep:0];
            [self performSelector:@selector(textData:) withObject:@(1) afterDelay:2.0f];
        }
            break;
        case 1:{
            [self getStepDev:@{@"devTid":@"ESP_2M_5CCF7F22CE5F",@"STEP":@3,@"code":@200}];
            [self getStepDev:@{@"devTid":@"ESP_2M_5CCF7F22CE5B",@"STEP":@1,@"code":@100}];
            [self performSelector:@selector(textData:) withObject:@(2) afterDelay:2.0f];
        }
            break;
        case 2:{
//            [self testSuccess];
        }
            break;
        case 3:{
            
            
        }
            break;
        case 4:{
            [self aniProgressStopConfig];
            [self aniProgressEnd];
        }
            break;
        default:
            break;
    }
}

-(void)testSuccess{
    [self getStepDev:@{@"devTid":@"ESP_2M_5CCF7F22CE5F",@"STEP":@4,@"code":@200,@"bindResultCode":@0,@"logo":@"",@"name":@"测试假数据"}];
    
    if (_moveUnderContraint.constant==0) {
        return;
    }
    
    [_underView configUnderButtonSuccess:YES];
    _moveUnderContraint.constant = 0;
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
