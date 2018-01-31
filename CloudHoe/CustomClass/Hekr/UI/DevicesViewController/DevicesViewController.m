//
//  DevicesViewController.m
//  HekrSDKAPP
//

//  Created by Mike on 16/2/15.
//  Copyright © 2016年 Mike. All rights reserved.
//
#import "DevicesViewController.h"
#import "HomeDeviceCells.h"
#import "HomeDevicesLayout.h"
//#import "SideViewController.h"
#import "HomeDeviceStatisticsView.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#import "TNKRefreshControl.h"
#import "EmptyDeviceView.h"
#import "JCRBlurView.h"
#import <Accelerate/Accelerate.h>
#import "ConfigurationNetController.h"
#import <HekrAPI.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import <SHAlertViewBlocks.h>
#import "DevCell.h"
#import "ReadWebViewController.h"
#import "GroupView.h"
#import "AuthorizationView.h"
#import "GiFHUD.h"
#import "AudioToolbox/AudioToolbox.h"
#import "SafetyQuestionViewController.h"
#import "MJAnimateHeader.h"
#import "GTMBase64.h"
#import "SendDataObj.h"
#import <Masonry.h>
#import "LoadWebViewObj.h"

#define HeaderHeight 40
#define StatisticsViewHeight 224
#define EmptyHeight 300
#define RefreshHeight 30
//#define ScreenWidth                     [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight                    [UIScreen mainScreen].bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Hrange(x)  (x/750.0)*ScreenWidth
//#define Vrange(x)  (x/1334.0)*ScreenHeight
//#define iPhone4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
//#define MAX_STARWORDS_LENGTH 16

@interface DevicesViewController ()<MergeAbleDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ModelDelegate,EmptyDeviceDelegate,UITextFieldDelegate,DevDelete,GroupViewDelegate>
@property (nonatomic,weak) IBOutlet UICollectionView * deviesView;

@property (nonatomic,weak) HomeDeviceStatisticsView * statistics; //upview

@property (nonatomic,weak) EmptyDeviceView * empDevView; //提示view

@property (nonatomic,weak) DeviceStatisticsView * deviceStatisticsView;

@property (nonatomic,strong) GroupModel *groupmodel;

@property (nonatomic,assign) BOOL beShowHeader;

@property (nonatomic,strong) NSDictionary * devModels;

//@property (nonatomic, strong)NSMutableArray *cidArrays;

@property (nonatomic, assign) BOOL isReload;

@property (nonatomic, strong) GroupView *mainview;

@property (nonatomic,assign) BOOL authChecking;

@property (nonatomic,strong)NSMutableDictionary *alertDic;

@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, assign) BOOL isCellAnimate;

@property (weak, nonatomic) IBOutlet UIImageView *devBgImg;

@property (nonatomic ,strong) NSArray *lanDevices;

@property (nonatomic ,strong) NSTimer *lanTimer;
@property (nonatomic, assign) BOOL isShowLan;
@property (nonatomic,strong) LoadWebViewObj *loadWebObj;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *bgImageTopContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *bgImageBottomContraint;
@property(nonatomic, weak)IBOutlet NSLayoutConstraint *decViewBottomContraint;

@end


@interface DevicesViewController (Notification)
-(void) onRecvNotification:(id) data userSelect:(BOOL) isUserSelected;
-(void) checkAuth:(id)info isUserChose:(BOOL) useChose;
@end

@implementation DevicesViewController
{
    UIButton *_endButton;
    UIView *_staView;
    UIView *_groupview;
    HekrFold *_group;
    UICollectionView *_groupcollection;
    BOOL _isgroup;
    AuthorizationView *_authView;
    id _info;
}
-(BOOL) prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DevicesView"];
    [self initNavView];
    
    [self.statistics refreshTheme];
    UIImage *image = isNightTheme() ? [UIImage imageNamed:@"ic_dev_bar_dark"] : [UIImage imageNamed:@"ic_dev_bar"];
    self.deviceStatisticsView.devStaBgImg.image = image;
    self.deviceStatisticsView.onLineImg.image = [UIImage imageNamed:getOnLineImg()];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    _devBgImg.image = [UIImage imageNamed:getDeviseViewBgImg()];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isGroup"] isEqualToString:@"YES"]) {
        _staView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _staView.backgroundColor = [UIColor blackColor];
        _staView.alpha = 0.6;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staMove)];
        [_staView addGestureRecognizer:tap];
        [self.navigationController.view addSubview:_staView];
        
    }
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkLogin];
    [self checkAuth:nil isUserChose:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DevicesView"];
    {
        _isgroup = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isGroup"];
        [_mainview removeFromSuperview];
        _mainview = nil;
        [_staView removeFromSuperview];
        _staView = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    _isReload = YES;
    _isCellAnimate = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isGroup"];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(configNSNotification:) name:@"configStop" object:nil];
    [center addObserver:self selector:@selector(isShowBack) name:@"backHide" object:nil];
    [center addObserver:self selector:@selector(clearDataNSNotification) name:@"clearData" object:nil];
    [center addObserver:self selector:@selector(reloadNSNotification:) name:@"ManagerViewReload" object:nil];
    [center addObserver:self selector:@selector(changeThemeNSNotification) name:@"ChangeHekrTheme" object:nil];
    [center addObserver:self selector:@selector(loadRequsetWebView:) name:@"loadRequsetWebView" object:nil];
    
    //导航条设置
    [self initNavView];
    
    self.deviesView.contentInset = UIEdgeInsetsMake(StatisticsViewHeight-HeaderHeight, 0, 0, 0);
    [self.deviesView registerClass:[DevCell class] forCellWithReuseIdentifier:@"DevCell"];
    self.beShowHeader = YES;
    
    HomeDeviceStatisticsView * view = [[[NSBundle mainBundle] loadNibNamed:@"HomeDeviceStatisticsView" owner:self options:nil] firstObject];
    //禁止AutoresizingMask转换成AutoLayout
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.deviesView insertSubview:view atIndex:0];
    self.statistics = view;
    //    [self.statistics updateDeviceData];
    
    //upview autolayout代码布局
    [self.deviesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view(width)]-(0)-|" options:NSLayoutFormatAlignAllTop metrics:@{@"width":@(CGRectGetWidth([UIScreen mainScreen].bounds))} views:@{@"view":view}]];
    [self.deviesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[view(height)]" options:NSLayoutFormatAlignAllLeading metrics:@{@"offset":@(-StatisticsViewHeight + HeaderHeight),@"height":@(StatisticsViewHeight - HeaderHeight)} views:@{@"view":view}]];
    
    //下拉刷新初始化
    MJAnimateHeader *reafreshHeader = [MJAnimateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh:)];
    reafreshHeader.ignoredScrollViewContentInsetTop = 180;
    self.deviesView.mj_header = reafreshHeader;
    
    self.isShowLan = NO;
    //数据源model初始化
    self.model = [DevicesModel new];
    self.model.delegate = self;
    
    //提示view初始化
    EmptyDeviceView * empty = [[EmptyDeviceView alloc] initWithFrame:CGRectMake(0, self.statistics.frame.origin.y + self.statistics.frame.size.height+HeaderHeight, ScreenWidth, ScreenHeight - self.statistics.frame.size.height - 64.f)];
    empty.translatesAutoresizingMaskIntoConstraints = NO;
    empty.delegate = self;
    empty.hidden = YES;
    self.empDevView = empty;
    [self.deviesView addSubview:empty];
    
    [self.deviesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[view(width)]-(0)-|" options:NSLayoutFormatAlignAllTop metrics:@{@"width":@(CGRectGetWidth([UIScreen mainScreen].bounds))} views:@{@"view":empty}]];
    [self.deviesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[view(height)]" options:NSLayoutFormatAlignAllLeading metrics:@{@"offset":@(HeaderHeight),@"height":@(EmptyHeight)} views:@{@"view":empty}]];
    
    if (@available(iOS 11.0, *)) {
        _deviesView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _bgImageTopContraint.constant = -88;
        _bgImageBottomContraint.constant = -34;
        _decViewBottomContraint.constant = -34;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //    NSLog(@"CGRectGetFrame:%f,%f,%f,%f",CGRectGetMinX(self.deviesView.frame),CGRectGetMinY(self.deviesView.frame),CGRectGetWidth(self.deviesView.frame),CGRectGetHeight(self.deviesView.frame));
    //请求数据
    //    [self loadDevModes];
    
    self.authChecking = NO;
    self.alertDic = [NSMutableDictionary new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUser:) name:HekrSDKUserChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[Hekr sharedInstance] setNotificationHandle:^(id note, BOOL isUserSelected) {
        [self onRecvNotification:note userSelect:isUserSelected];
    }];
    [self checkAuth:nil isUserChose:NO];
    // Do any additional setup after loading the view.
    WS(weakSelf);
    
    NSDictionary * filter = @{@"action" : @"addSubDev"};
    [[Hekr sharedInstance] recv:filter obj:self callback:^(id obj, id data, NSError *error) {
        typeof(self)vc = obj;
        [vc.model reload];
    }];
    
    [[Hekr sharedInstance] callBackLocalDevicesState:^(NSString *devTid, NSArray *devices) {
        weakSelf.lanDevices = devices.copy;
        //        _devDataArray = [NSArray arrayWithArray:_model.commonDatas];
        //        [self.deviesView reloadData];
        [weakSelf reloadLoaclDeviceShow];
        
    } closeState:^(NSString *devTid) {
        if (devTid==nil) {
            weakSelf.lanDevices = @[];
        }
        else{
            NSMutableArray *arr = [NSMutableArray arrayWithArray:weakSelf.lanDevices];
            [arr removeObject:devTid];
            weakSelf.lanDevices = arr;
        }
        //        _devDataArray = [NSArray arrayWithArray:_model.commonDatas];
        //        [self.deviesView reloadData];
        [weakSelf reloadLoaclDeviceShow];
    }];
    //    [[Hekr sharedInstance] callWebSocketNetStateHandle:^(BOOL netState) {
    //        if (!netState) {
    //            if ([[Hekr sharedInstance] reachability].networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
    //                return ;
    //            }
    //            if ([[Hekr sharedInstance] getLocalControl] != HekrLocalControlOn) {
    //                if (weakSelf.lanTimer==nil) {
    //                    weakSelf.lanTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:weakSelf selector:@selector(openLocalControl) userInfo:nil repeats:NO];
    //                }
    //            }
    //        }else{
    //            if (weakSelf.lanTimer) {
    //                [weakSelf.lanTimer invalidate];
    //                weakSelf.lanTimer = nil;
    //            }
    //            [[Hekr sharedInstance] setLocalControl:HekrLocalControlOff];
    //        }
    //    }];
    
    _loadWebObj = [[LoadWebViewObj alloc] init];
}

-(void)loadRequsetWebView:(NSNotification *)notification{
    NSArray *devs = notification.userInfo[@"devices"];
    [_loadWebObj loadRequsetWebView:devs];
}

-(void)openLocalControl{
    if (self.lanTimer) {
        [self.lanTimer invalidate];
        self.lanTimer = nil;
    }
    [[Hekr sharedInstance] setLocalControl:HekrLocalControlOn];
    if (!self.isShowLan) {
        self.isShowLan = YES;
        [self showAlertPromptWithTitle:@"检测到当前连接网络异常，已为您开启智能局域网功能" actionCallback:nil];
    }
}

-(void)reloadLoaclDeviceShow{
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"onLanDeices" object:nil userInfo:@{@"lanDevices":self.lanDevices.copy}]];
    [self.deviesView reloadData];
}

- (void)addEmptyDevice:(NSString *)h5Url{
    [self jumpTo:[NSURL URLWithString:[NSString stringWithFormat:@"%@?lang=%@&openType=push",h5Url,lang()]]  devData:nil];
}

- (void)clearDataNSNotification{
    [self.model clearDevCache];
}

- (void)reloadNSNotification:(NSNotification *)sender{
    self.model = sender.userInfo[@"model"];
    self.model.delegate = self;
    [self onLoad];
}

- (void)configNSNotification:(NSNotification *)notification{
    id info = notification.userInfo[@"info"];
    [self.model configAddDevices:info];
    [self onLoad];
    [self.model reload];
}

- (void)changeThemeNSNotification{
    [self.deviesView reloadData];
}

//导航条相关设置
- (void)initNavView
{
    UIImage *image = isNightTheme() ? [UIImage imageNamed:@"ic_dev_bar_dark"] : [UIImage imageNamed:@"ic_dev_bar"];
    self.automaticallyAdjustsScrollViewInsets = YES;
    //    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-100)/2, 0, 100, 30)];
    titLabel.backgroundColor = [UIColor clearColor];
    titLabel.textColor = getNavTitleColor();
    titLabel.textAlignment = NSTextAlignmentCenter;
    titLabel.text = NSLocalizedString(@"", nil);
    titLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titLabel;
    
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(onAddDevice:) forControlEvents:(UIControlEventTouchUpInside)];
    add.frame = CGRectMake(0, 0, 40, 40);
    add.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:add];
    
}

-(void) dealloc{
    //通知移除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//刷新数据
-(void) refresh:(id) sender{
    [self.view endEditing:YES];
    _isRefresh = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    //    self.deviesView.contentOffset = CGPointMake(0.0, -200.0); // 注意位移点的y值为负值
    [UIView commitAnimations];
    //    self.deviesView
    // 改变refreshControl的状态
    [self.deviesView.refreshControl beginRefreshing];
    
    // 刷新数据和表格视图
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:2.0];
}

-(void)refreshData
{
    _isRefresh = YES;
    [self.model reload];
}

//model控制---刷新完成

- (void)erroronLoad:(NSError *)error{
    [self.deviesView.mj_header endRefreshing];
    //    [self.deviesView.refreshControl endRefreshing];
    if ([Hekr sharedInstance].user) {
        [self.view.window makeToast:NSLocalizedString(@"网络超时", nil) duration:1.0 position:@"center"];
    }
}

-(void) onLoad{
    if (_isgroup) {
        _mainview.isReload = _isReload;
        [_mainview.groupcollection reloadData];
        //        [_groupcollection reloadData];
        return;
    }
#ifdef DEBUG
    //主动发送测试数据用的
    [[SendDataObj sharedInstance] setDevData:self.model.allDatas];
#endif
    [self.deviesView reloadData];
    
    [self.deviesView.mj_header endRefreshing];
    //    [self.deviesView.refreshControl endRefreshing];
    
    [self.statistics updateDeviceData];
    
    if (self.model.datas.count == 0) {
        [self.empDevView viewLoad];
        [self.deviesView bringSubviewToFront:self.empDevView];
        self.empDevView.hidden = NO;
        [self isShowBack];
    }else{
        self.empDevView.hidden = YES;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.deviesView.isDragging && !self.deviesView.refreshControl.refreshing) {
                //                _beShowHeader = NO;
                //                [UIView animateWithDuration:.3 animations:^{
                //                    [self.deviesView setContentInset:UIEdgeInsetsZero];
                //                    [self.deviesView setContentOffset:CGPointZero animated:YES];
                //                }];
            }
        });
    });
}

-(void) onActive:(id) sender{
    
}
//跳转到登录
-(void) checkLogin{
    //    BOOL isFirst = ([self rootController] == [self rootController].navigationController.viewControllers.lastObject);
    
    if (![Hekr sharedInstance].user) {
        [TheAPPDelegate.rootNav pushViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"] animated:NO];
    }
    //    else{
    //        NSString *safety = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"HekrSafety%@",[Hekr sharedInstance].user.uid]];
    //        if (!safety) {
    //            [[NSUserDefaults standardUserDefaults] setObject:[Hekr sharedInstance].user.uid forKey:[NSString stringWithFormat:@"HekrSafety%@",[Hekr sharedInstance].user.uid]];
    //            SafetyQuestionViewController *safetyView = [[SafetyQuestionViewController alloc]initWithIsOne:YES Num:nil Title:NSLocalizedString(@"密保问题", nil) ViewType:setSafetyQuestion];
    //            [self presentViewController:safetyView animated:YES completion:nil];
    //        }
    //    }
}

//添加设备
-(void) onAddDevice:(id) sender{
    [TheAPPDelegate.rootNav pushViewController:[ConfigurationNetController new] animated:YES];
    NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}

//判断是否登录，若已登录，刷新数据，若没登录，跳转登录
-(void) onUser:(id) sender{
    
    if (![Hekr sharedInstance].user) {
        
        BOOL needCheck = [TheAPPDelegate rootNav].viewControllers.count <= 1;
        [TheAPPDelegate.rootNav popToRootViewControllerAnimated:NO];
        
        NSMutableArray *array = [NSMutableArray array];
        for (UIViewController *viewController in TheAPPDelegate.rootNav.viewControllers) {
            if ([viewController isKindOfClass:[SideMenuController class]]) {
                SideMenuController *sideMenuController = (SideMenuController *)viewController;
                [sideMenuController hideLeftViewAnimated:NO completionHandler:^{
                    
                }];
                
                [array addObject:sideMenuController];
                [array addObject:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginController"]]
                ;
                break;
            }
        }
        
        TheAPPDelegate.rootNav.viewControllers = array;
        if (needCheck) {
            [self checkLogin];
        }
    }else{
        self.isShowLan = NO;
        [self.model reload];
    }
    
    //删除用户数据的缓存
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHekrUserProfile"];
}


//获取跟视图控制器
-(UIViewController*) rootController{
    return [TheAPPDelegate.rootNav viewControllers].firstObject;
}

//?????????
-(void) jumpTo:(NSURL *)url devData:(NSDictionary *)data{
    NSMutableDictionary *devData = [NSMutableDictionary dictionaryWithDictionary:data];
    if ([[data objectForKey:@"devType"] isEqualToString:@"GATEWAY"]) {
        NSMutableDictionary *subDevs = [NSMutableDictionary dictionary];
        for (HekrDevice *dev in _model.allDatas) {
            if ([[dev.props objectForKey:@"devType"] isEqualToString:@"SUB"]&&[dev.indTid isEqualToString:[data objectForKey:@"devTid"]]) {
                NSMutableDictionary *subData = [NSMutableDictionary dictionary];
                [subData setObject:dev.props forKey:@"devData"];
                [subDevs setObject:subData forKey:dev.tid];
            }
        }
        [devData setObject:subDevs forKey:@"subDevs"];
    }
    [[self rootController] jumpTo:url currentController:[TheAPPDelegate.rootNav viewControllers].lastObject devData:devData devProtocol:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *
 * HomeDevicesLayout---@protocol  MergeAbleDataSource
 *
 *判断拖动到的新位置是设备或目录
 *判断拖动的item是设备
 *拖动完成
 */
- (BOOL)isGroup{
    return _isgroup;
}

- (BOOL) isOutBondIndex:(NSIndexPath*) index{
    return (index.item == -1 && index.section == -1);
}
- (BOOL) canMergeItem:(NSIndexPath *)index withItem:(NSIndexPath *)toIndex{
    if (_isgroup) {
        return [self isOutBondIndex:toIndex];//for move out group;
    }
    if(index.item >= self.model.datas.count || toIndex.item >= self.model.datas.count ) return NO;
    
    return [self isDevice:[self.model.datas objectAtIndex:index.item]] && ([self isDevice:[self.model.datas objectAtIndex:toIndex.item]] || [self isFold:[self.model.datas objectAtIndex:toIndex.item]]);
}
- (BOOL) canMergeItem:(NSIndexPath *)index{
    if (!index) {
        return NO;
    }
    if (_isgroup) {
        return [self isDevice:[_mainview.groupmodel.datas objectAtIndex:index.item]];
    }
    return [self isDevice:[self.model.datas objectAtIndex:index.item]];
}
-(void) didMergeItem:(NSIndexPath*) index withItem:(NSIndexPath*) toIndex block:(void(^)(NSDictionary* ))block{
    if (_isgroup && [self isOutBondIndex:toIndex]) {
        [(GroupModel*)_mainview.groupmodel moveOutDevceAt:index.item block:block];
    }
    id toItem = [self.model.datas objectAtIndex:toIndex.item];
    if ([self isFold:toItem]) {
        [self.model meargeDeviceAtGroup:index.item withGroupAt:toIndex.item block:block];
    }else{
        if ([self isDevice:toItem]){
            void(^block)(id,void(^block)(BOOL)) = [self.model meargeDeviceAt:index.item withDeviceAt:toIndex.item];
            
            WS(weakSelf);
            [self showAlertTextFieldWithTitle:@"目录名称" msg:@"" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action,UIAlertController * _Nonnull alert) {
                
                UITextField *tf = alert.textFields.firstObject;
                [_model meargeDeviceAt:index.item withDeviceAt:toIndex.item];
                NSString * name = tf.text;
                name = name ? name : @"--";
                block(name,^(BOOL ret){
                    if (!ret)
                        [weakSelf showOneActionAlertWithTitle:@"提示" msg:@"合并目录失败，请重试" actionText:@"确定" actionCallback:^(UIAlertAction * _Nonnull action) {                    }];
                });
                
            } tfCallback:^(UITextField * _Nonnull textField) {
                textField.placeholder =NSLocalizedString(@"请输入目录名称", nil);
                textField.delegate = self;
                [textField addTarget:self action:@selector(TextDidChange:) forControlEvents:UIControlEventEditingChanged];
                textField.returnKeyType=UIReturnKeyDone;
            }];
        }
    }
}

-(void)AlertMessage:(NSString *)message{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(message,nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show];
}

//识别长按后震动提醒
- (void)vibrationAction{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (BOOL)isDev:(NSIndexPath *)idx{
    if (_isgroup) {
        return [self isDevice:[_mainview.groupmodel.datas objectAtIndex:idx.item]];
    }else{
        if (self.model.datas.count > idx.item ) {
            return [self isDevice:[self.model.datas objectAtIndex:idx.item]];
        }else{
            return NO;
        }
        
    }
}

//判断是否设备
- (BOOL) isDevice:(id) item{
    return [item isKindOfClass:[HekrDevice class]];
}
//判断是否是占位？？？？
- (BOOL)isPlacehode:(id)item{
    return [item isKindOfClass:[HekrPlacehode class]];
}
//判断是否分组
- (BOOL) isFold:(id) item{
    return [item isKindOfClass:[HekrFold class]];
}

//判断是否群组
- (BOOL)isHekrGroup:(id)item{
    return [item isKindOfClass:[HekrGroup class]];
}

- (BOOL)isReload{
    return _isCellAnimate;
}

- (void)LongPressGestureAnimate{
    _isCellAnimate = NO;
}

- (void)groupViewDismiss{
    [self endDelete];
    [UIView animateWithDuration:0.2 animations:^{
        _mainview.alpha = 0;
    } completion:^(BOOL finished) {
        _isgroup = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isGroup"];
        [self onLoad];
        [_mainview removeFromSuperview];
        _mainview = nil;
        [_staView removeFromSuperview];
        _staView = nil;
        [self.model reload];
    }];
}
-(UIView*) contentView{
    return _mainview;
}

//删除按钮

- (void)didSelectDeleteAction:(NSIndexPath *)idx{
    
    
    if (_isReload && [self isDev:idx]) {
        
        _isReload = NO;
        if (_isgroup) {
            _mainview.isReload = _isReload;
            _mainview.isCellAnimate = _isCellAnimate;
            [_mainview.groupcollection reloadData];
        }else{
            [self.deviesView reloadData];
        }
        
        
        _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _endButton.frame = CGRectMake(0, 0, Hrange(160), Vrange(60));
        _endButton.center = CGPointMake(ScreenWidth-Hrange(120), ScreenHeight-Hrange(40)-Vrange(30));
        _endButton.backgroundColor = rgb(241, 244, 245);
        _endButton.layer.cornerRadius = _endButton.frame.size.height/2;
        [_endButton setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
        [_endButton setTitleColor:rgb(49, 49, 49) forState:UIControlStateNormal];
        [_endButton addTarget:self action:@selector(endDelete) forControlEvents:UIControlEventTouchUpInside];
        _endButton.titleLabel.font = getButtonTitleFont();
        [self.view.window addSubview:_endButton];
    }
}


- (void)deleteDev:(UIButton *)sender {
    __weak typeof(self) wself = self;
    //    UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"删除设备", nil) withMessage:NSLocalizedString(@"您确认删除此设备？", nil)];
    //    [alert SH_addButtonCancelWithTitle:NSLocalizedString(@"取消",nil) withBlock:nil];
    //    [alert SH_addButtonWithTitle:NSLocalizedString(@"确定", nil) withBlock:^(NSInteger theButtonIndex) {
    //        __strong typeof(self) sself = wself;
    //        if (theButtonIndex==1) {
    //            alert.userInteractionEnabled = NO;
    //            id cell = sender.superview;
    //            while (cell && ![cell isKindOfClass:[UICollectionViewCell class]]) {
    //                cell = [(UIView*)cell superview];
    //            }
    //            if (_isgroup == YES) {
    //                NSIndexPath * index = [sself.mainview.groupcollection indexPathForCell:cell];
    //                if (index) {
    //                    [sself.groupmodel deleteDevceAt:index.item onDone:^{
    //                        __strong typeof(self) ssself = sself;
    //                        [ssself showAlertDelShareAnnex];
    //                    }];
    //                }
    //            }else{
    //                NSIndexPath * index = [sself.deviesView indexPathForCell:cell];
    //                if (index) {
    //                    [sself.model deleteDevceAt:index.item onDone:^{
    //                        __strong typeof(self) ssself = sself;
    //                        [ssself showAlertDelShareAnnex];
    //                    }];
    //                }
    //            }
    //        }
    //    }];
    //    [alert show];
    
    [self showAlert:@"删除设备" msg:@"您确认删除此设备？" leftText:@"取消" leftCallback:nil rightText:@"确定" rigthCallback:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) sself = wself;
        id cell = sender.superview;
        while (cell && ![cell isKindOfClass:[UICollectionViewCell class]]) {
            cell = [(UIView*)cell superview];
        }
        if (_isgroup == YES) {
            NSIndexPath * index = [sself.mainview.groupcollection indexPathForCell:cell];
            if (index) {
                [sself.groupmodel deleteDevceAt:index.item onDone:^{
                    __strong typeof(self) ssself = sself;
                    [ssself showAlertDelShareAnnex];
                }];
            }
        }else{
            NSIndexPath * index = [sself.deviesView indexPathForCell:cell];
            if (index) {
                [sself.model deleteDevceAt:index.item onDone:^{
                    __strong typeof(self) ssself = sself;
                    [ssself showAlertDelShareAnnex];
                }];
            }
            
        }
    }];
}

-(void)showAlertDelShareAnnex{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"由网关设备授权来的子设备，无法删除!",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show];
}


- (void)isShowBack{
    if (_endButton.superview == self.view.window) {
        [self endDelete];
    }
}


- (void)endDelete{
    _isCellAnimate = YES;
    _isReload = YES;
    if (_isgroup) {
        _mainview.isReload = _isReload;
        [_mainview.groupcollection reloadData];
    }else{
        [self.deviesView reloadData];
    }
    [_endButton removeFromSuperview];
}



#pragma mark - UICollectionView datasouce

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.datas.count;
    
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    id data = [self.model.datas objectAtIndex:indexPath.item];
    if ([data isKindOfClass:[HekrPlacehode class]]) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"HekrPlacehode" forIndexPath:indexPath];
    }
    if ([self isDevice:data]) {
        DevCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DevCell" forIndexPath:indexPath];
        cell.delegate = self;
        if (_isgroup == NO) {
            cell.devDelete.hidden = _isReload ;
            if (_isReload ) {
                cell.img.alpha = 1.0;
                cell.name.alpha = 1.0;
                cell.imgBgView.alpha = 1.0;
            }else{
                cell.img.alpha = 0.5;
                cell.name.alpha = 0.5;
                cell.imgBgView.alpha = 0.5;
            }
            
        }else{
            cell.devDelete.hidden = YES;
            cell.img.alpha = 1.0;
            cell.name.alpha = 1.0;
            cell.imgBgView.alpha = 1.0;
        }
        
        cell.imgBgView.backgroundColor = [UIColor clearColor];
        cell.hekrGroup.hidden = YES;
        [cell update:data isHekrGroup:NO GroupName:nil lanDevices:self.lanDevices];
        return cell;
    }else if([self isHekrGroup:data]){
        HekrGroup *groupData = data;
        
        DevCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DevCell" forIndexPath:indexPath];
        cell.img.alpha = 1.0;
        cell.name.alpha = 1.0;
        cell.imgBgView.alpha = 1.0;
        cell.devDelete.hidden = YES;
        cell.hekrGroup.hidden = NO;
        cell.hekrGroupNum.text = [NSString stringWithFormat:@"%ld",(unsigned long)groupData.count];
        cell.imgBgView.backgroundColor = rgb(6, 164, 240);
        [cell update:groupData.devices[0] isHekrGroup:YES GroupName:groupData.name lanDevices:nil];
        return cell;
    }else{
        GroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];
        [cell update:data isHekrGroup:NO GroupName:nil];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isRefresh == NO) {
        return;
    }
    if ((indexPath.item == self.model.datas.count-1)||indexPath.item>9) {
        _isRefresh = NO;
    }
    cell.transform = CGAffineTransformMakeTranslation(0, 50);
    cell.alpha = 0;
    [self performSelector:@selector(cellanimate:) withObject:cell afterDelay:0.05*indexPath.item];
    
}

- (void)cellanimate:(UICollectionViewCell *)cell{
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeTranslation(0, -10);
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 animations:^{
            cell.transform = CGAffineTransformIdentity;
        }];
    }];
    
}

#pragma mark - UICollectionView delegate

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    DeviceStatisticsView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DeviceStatisticsView" forIndexPath:indexPath];
    self.deviceStatisticsView = view;
    if ([[Hekr sharedInstance] getLocalControl] == HekrLocalControlOn) {
        self.deviceStatisticsView.n_count = self.model.count - self.lanDevices.count;
        self.deviceStatisticsView.n_online = self.lanDevices.count;
    }else{
        self.deviceStatisticsView.n_count = self.model.count - self.model.online;
        self.deviceStatisticsView.n_online = self.model.online;
    }
    self.deviceStatisticsView.devStaBgImg.image = isNightTheme() ? [UIImage imageNamed:@"ic_dev_bar_dark"] : [UIImage imageNamed:@"ic_dev_bar"];
    self.deviceStatisticsView.onLineImg.image = [UIImage imageNamed:getOnLineImg()];
    //    self.deviceStatisticsView.devStaLabel.textColor = getTitledTextColor();
    return view;
    
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _isRefresh = NO;
    id data = [self.model.datas objectAtIndex:indexPath.item];
    if ([self isDevice:data]) {
        HekrDevice *dev = data;
        //            if (dev.online == YES) {
        [self jumpTo:[NSURL URLWithString:controlURLForDevice(dev)] devData:dev.props ];
        NSNotification *notification = [NSNotification notificationWithName:@"backHide" object:nil];
        [[NSNotificationCenter defaultCenter]postNotification:notification];
        //            }else{
        //                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"该设备不在线",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles: nil] show];
        //            }
    }else if ([self isPlacehode:data]){
        return;
    }else if ([self isHekrGroup:data]){
        HekrGroup *hekrGroup = data;
        HekrDevice *dev = hekrGroup.devices[0];
        NSString *str = [NSString stringWithFormat:@"%@&group=true&groupId=%@",controlURLForDevice(dev),hekrGroup.gid];
        [self jumpTo:[NSURL URLWithString:str] devData:dev.props];
        //[controlURLForDevice(dev) stringByAppendingString:@"&group=true"]
    }else if([self isFold:data]){
        HekrFold *g = data;
        _groupmodel = [[GroupModel alloc]initWithGroup:g baseModel:_model];
        _groupmodel.delegate = self;
        _isgroup = YES;
        [_deviesView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isGroup"];
        _mainview = [[GroupView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) Data:g GroupModel:_groupmodel lanDevices:self.lanDevices];
        _mainview.alpha = 0;
        _mainview.delegate = self;
        [self.view addSubview:_mainview];
        _staView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _staView.backgroundColor = [UIColor blackColor];
        _staView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(staMove)];
        [_staView addGestureRecognizer:tap];
        [self.view.window addSubview:_staView];
        
        [UIView animateWithDuration:0.4 animations:^{
            _mainview.alpha = 1;
            _staView.alpha = 0.6;
        }];
    }
}



- (void)staMove{
    [self.deviesView reloadData];
    [UIView animateWithDuration:0.2 animations:^{
        _mainview.alpha = 0;
        _staView.alpha = 0;
    } completion:^(BOOL finished) {
        _isgroup = NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isGroup"];
        [self onLoad];
        [_mainview removeFromSuperview];
        _mainview = nil;
        [_staView removeFromSuperview];
        _staView = nil;
    }];
}

- (void)mainOut:(UITapGestureRecognizer *)tgr{
    
    CGPoint touchPoint = [tgr locationInView:_mainview];
    CGRect groupframe = _groupview.frame;
    if (!(touchPoint.x > groupframe.origin.x && touchPoint.x < groupframe.origin.x + groupframe.size.width && touchPoint.y > groupframe.origin.y && touchPoint.y < groupframe.origin.y + groupframe.size.height)) {
        [self.deviesView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            _mainview.alpha = 0;
            _staView.alpha = 0;
        } completion:^(BOOL finished) {
            _isgroup = NO;
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isGroup"];
            [self onLoad];
            [_mainview removeFromSuperview];
            _mainview = nil;
            [_staView removeFromSuperview];
            _staView = nil;
        }];
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (collectionView.tag == 1001) {
        
    }else{
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout*)collectionViewLayout;
        CGFloat width = collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right;
        
        return CGSizeMake(width, HeaderHeight);
        
    }
    
    return CGSizeZero;
}

#pragma mark - groupViewDelegate

- (void)groupMainOut:(UITapGestureRecognizer *)tgr{
    [self mainOut:tgr];
}

- (void)groupDelets:(UIButton *)sender{
    [self deleteDev:sender];
}


- (void)groupStaViewMove{
    [_staView removeFromSuperview];
}

- (void)groupJumpTo:(NSURL *)url devData:(NSDictionary *)data{
    [self jumpTo:url devData:data];
}

- (void)groupAlertView{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"该设备不在线",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles: nil] show];
}

- (void)groupdidSelectDeleteAction:(NSIndexPath *)idx{
    [self didSelectDeleteAction:idx];
}

- (void)groupRenameFail{
    //    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"重命名失败，请重试",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show];
    [self showOneActionAlertWithTitle:@"提示" msg:@"重命名失败，请重试" actionText:@"确定" actionCallback:^(UIAlertAction * _Nonnull action) {}];
}

#pragma mark - UITextFiled delegate



- (void)TextDidChange:(UITextField *)textfield
{
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    //    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!selectedRange)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textfield.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
#pragma mark - UISrollView delegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([self.deviesView.refreshControl isRefreshing]) {
        return;
    }
    
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.deviesView.refreshControl isRefreshing] || _isgroup) {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (_beShowHeader) {
        if (offsetY > (-(StatisticsViewHeight-HeaderHeight) * 2 / 3)){
            _beShowHeader = NO;
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollView.contentOffset = offset;
        }
    }else{
        if (offsetY < (-(StatisticsViewHeight-HeaderHeight) / 3)){
            _beShowHeader = YES;
            scrollView.contentInset = UIEdgeInsetsMake(StatisticsViewHeight-HeaderHeight, 0, 0, 0);
            scrollView.contentOffset = offset;
        }
    }
    
    if (offsetY <= 0) {
        if (_beShowHeader) {
            //            [scrollView setContentOffset:CGPointMake(0, -(StatisticsViewHeight-HeaderHeight)) animated:YES];
        }else{
            [scrollView setContentOffset:CGPointZero animated:YES];
        }
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height) {
        [self.model loadMore];
    }
}

@end


@implementation DevicesViewController (Notification)

-(void) onRecvNotification:(id)data userSelect:(BOOL)isUserSelected{
    if (![Hekr sharedInstance].user) {
        return;
    }
    
    DDLogVerbose(@"onRecvNotification:%@ userSelect:%@",data,@(isUserSelected));
    //    NSLog(@"onRecvNotification:%@ userSelect:%@",data,@(isUserSelected));
    NSString * type = [data objectForKey:@"pushType"];
    
    /*
     报警推送：
     "pushType" : "DEVICE_ALARM"
     "devTid"   : "devTid"（根据tid在本地model查devName）
     "message"  : "message"
     
     强绑推送：
     "pushType" : "DEVICE_ForceBind"
     "devTid"   : "devTid"（根据tid在本地model查devName）
     "bindResultMsg"  : "bindResultMsg"（手机号/邮箱/第三方账号）
     */
    if ([type isEqualToString:@"DEVICE_ALERT"]) {
        //报警推送
        NSString *encodingStr = [[[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil] base64EncodedStringWithOptions:0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"]];
        NSString *key = [NSString stringWithFormat:@"tid:%@ message:%@",[data objectForKey:@"devTid"],data[@"message"]];
        if ([self.alertDic objectForKey:key]) return;
        [self.alertDic setObject:@"yes" forKey:key];
        
        if (TheAPPDelegate.isBackground == YES) {
            TheAPPDelegate.isBackground = NO;
            for (HekrDevice *dev in self.model.allDatas) {
                if ([dev.tid isEqualToString:[data objectForKey:@"devTid"]]) {
                    [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(dev, encodingStr)] devData:dev.props];
                    [self.alertDic removeObjectForKey:key];
                    return;
                }
            }
            [GiFHUD showWithOverlay];
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://user.openapi.hekr.me/device?devTid=%@",[data objectForKey:@"devTid"]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [GiFHUD dismiss];
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSArray *arr = responseObject;
                    if (arr.count>0) {
                        HekrDevice *dev = [self.model configAddDevices:arr.firstObject];
                        [self onLoad];
                        [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(dev, encodingStr)] devData:dev.props];
                        [self.alertDic removeObjectForKey:key];
                        return;
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [GiFHUD dismiss];
            }];
            NSAssert(false, @"device not fond!!!",[data objectForKey:@"devTid"]);
        }else{
            HekrDevice *devFind = [self.model findDeviceOfTid:[data objectForKey:@"devTid"]];
            if (devFind) {
                //                UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:data[@"title"] withMessage:data[@"message"]];
                //                [alert SH_addButtonCancelWithTitle:NSLocalizedString(@"取消",nil) withBlock:^(NSInteger theButtonIndex) {
                //                    [self.alertDic removeObjectForKey:key];
                //                }];
                //                [alert SH_addButtonWithTitle:NSLocalizedString(@"查看", nil) withBlock:^(NSInteger theButtonIndex) {
                //                    if (theButtonIndex==1) {
                //                        [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(devFind, encodingStr)] devData:devFind.props ];
                //                        [self.alertDic removeObjectForKey:key];
                //                    }
                //                }];
                //                [alert show];
                
                [self showAlert:data[@"title"] msg:data[@"message"] leftText:@"取消" leftCallback:^(UIAlertAction * _Nonnull action) {
                    [self.alertDic removeObjectForKey:key];
                } rightText:@"查看" rigthCallback:^(UIAlertAction * _Nonnull action) {
                    [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(devFind, encodingStr)] devData:devFind.props ];
                    [self.alertDic removeObjectForKey:key];
                }];
                
                return;
            }
            
            //            [GiFHUD showWithOverlay];
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:[NSString stringWithFormat:@"http://user-openapi.hekr.me/device?devTid=%@",[data objectForKey:@"devTid"]] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //                [GiFHUD dismiss];
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    NSArray *arr = responseObject;
                    if (arr.count>0) {
                        HekrDevice *dev = [self.model configAddDevices:arr.firstObject];
                        [self onLoad];
                        //                        UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:data[@"title"] withMessage:data[@"message"]];
                        //                        [alert SH_addButtonCancelWithTitle:NSLocalizedString(@"取消",nil) withBlock:^(NSInteger theButtonIndex) {
                        //                            [self.alertDic removeObjectForKey:key];
                        //                        }];
                        //                        [alert SH_addButtonWithTitle:NSLocalizedString(@"查看", nil) withBlock:^(NSInteger theButtonIndex) {
                        //                            if (theButtonIndex==1) {
                        //                                [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(dev, encodingStr)] devData:devFind.props ];
                        //                                [self.alertDic removeObjectForKey:key];
                        //                            }
                        //                        }];
                        //                        [alert show];
                        [self showAlert:data[@"title"] msg:data[@"message"] leftText:@"取消" leftCallback:^(UIAlertAction * _Nonnull action) {
                            [self.alertDic removeObjectForKey:key];
                        } rightText:@"查看" rigthCallback:^(UIAlertAction * _Nonnull action) {
                            [self jumpTo:[NSURL URLWithString:controlPushURLForDevice(dev, encodingStr)] devData:dev.props ];
                            [self.alertDic removeObjectForKey:key];
                        }];
                    }
                }
            }
                                                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                                     [GiFHUD dismiss];
                                                                 }];
            //        NSAssert(false, @"device not fond!!!",[data objectForKey:@"devTid"]);
        }
    }else if ([type isEqualToString:@"DEVICE_FORCEBIND"]) {
        //强绑推送
        /*
         {
         CategoryName =     {
         "en_US" = "Misc/Cabinet";
         "zh_CN" = "\U5bb6\U5c45\U5bb6\U88c5/\U667a\U80fd\U5185\U8863\U67dc";
         };
         bindResultMsg = 18868945380;
         devTid = "ESP_2M_5CCF7F23AEAF";
         pushType = "DEVICE_FORCEBIND";
         }
         */
        NSString *cidNmae = isEN() ? [[data[@"CategoryName"][@"en_US"] componentsSeparatedByString:@"/"] firstObject] : [[data[@"CategoryName"][@"zh_CN"] componentsSeparatedByString:@"/"] firstObject];
        
        NSString *str = isEN() ? [NSString stringWithFormat:@"You have a %@ already bound by %@. Please apply for permissions or rebind to use it. ",cidNmae,data[@"bindResultMsg"]] : [NSString stringWithFormat:@"您有一个%@已被%@绑定。如需使用，请申请共享权限或重新绑定。",cidNmae,data[@"bindResultMsg"]];
        
        [self showAlertPromptWithTitle:str actionCallback:nil];
        
    }else if ([type isEqualToString:@"DEVICE_ALERT"]) { //is devices
        //show device page;
        //控制
        //        if (isUserSelected) {
        //            for (HekrDevice *dev in self.model.allDatas) {
        //                if ([dev.tid isEqualToString:data[@"devTid"]]) {
        //                    if (dev.online == YES) {
        //                        [self jumpTo:[NSURL URLWithString:controlURLForDevice(dev)]];
        //                    }
        //                }
        //            }
        //        }
    }else if ([type isEqualToString:@"REVERSE_AUTHORIZATION"]){ //is auth requet
        [self checkAuth:(id)data isUserChose:isUserSelected];
        
    }else if ([type isEqualToString:@"REVERSE_AUTHORIZATION_RESULT"]){ //is auth response
        if ([[data objectForKey:@"result"] isEqualToString:@"REJECT"]){//"result":"REJECT"
            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(@"授权请求被拒绝", @"") buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            }] show];
            //            [self.view.window makeToast:NSLocalizedString(@"授权请求被拒绝", @"") duration:1.0 position:@"center"];
        }else if([[data objectForKey:@"result"] isEqualToString:@"ACCEPT"]){//"result":"ACCEPT"
            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(@"授权请求已被接受", @"") buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            }] show];
            //            [self.view.window makeToast:NSLocalizedString(@"授权请求已被接受", @"") duration:1.0 position:@"center"];
            [self.model reload];
        }
        //show auth response
    }else if ([type isEqualToString:@"INFORMATION"]){ //is information
        //URL
        if (isUserSelected && [data objectForKey:@"url"]) {
            ReadWebViewController *readWebVC = [[ReadWebViewController alloc] initWithTitle:NSLocalizedString(@"消息内容", nil) url:[data objectForKey:@"url"]];
            [self.navigationController pushViewController:readWebVC animated:YES];
        }
    }
}

-(void) checkAuth:(id)info isUserChose:(BOOL) useChose{
    if (self.authChecking || [Hekr sharedInstance].user == nil) return;
    self.authChecking = YES;
    [self loadReverseAuthorization:info isUserChose:useChose];
}
-(void) loadReverseAuthorization:(id) info isUserChose:(BOOL) useChose{
    NSString * tid = [info objectForKey:@"devTid"];
    NSString * token = [info objectForKey:@"registerId"];
    NSDictionary * dict = (tid && token)?@{@"devTid":tid,@"registerId":token,@"page":@(0),@"size":@(1)}:@{@"page":@(0),@"size":@(1)};
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] GET:@"http://user.openapi.hekr.me/authorization/reverse/register" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[收到授权请求]：%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]] && [(NSArray*)responseObject count] > 0) {
            [self showAuthRequest:[(NSArray*)responseObject firstObject]];
        }else{
            self.authChecking = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(useChose){
            //            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(@"授权请求信息加载失败", @"") buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            //            }] show];
            [self.view.window makeToast:NSLocalizedString(@"授权请求信息加载失败", @"") duration:1.0 position:@"center"];
        }
        self.authChecking = NO;
    }];
}
-(void) showAuthRequest:(id) info{
    _info = info;
    _authView = [[AuthorizationView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) Data:info Block:^(BOOL isTure) {
        [self authorizationAction:isTure];
    }];
    
    [_authView removeAction:^{
        [_authView removeFromSuperview];
        self.authChecking = NO;
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_authView];
    
    
}


- (void)authorizationAction:(BOOL)isTure{
    [_authView removeFromSuperview];
    [self onAuth:_info ret:isTure];
}



-(void) onAuth:(id) info ret:(BOOL) ret{
    NSString * devTid = [info objectForKey:@"devTid"];
    NSString * ctrlKey = [info objectForKey:@"ctrlKey"];
    NSString * token = [info objectForKey:@"registerId"];
    NSString * uid = [info objectForKey:@"grantee"];
    
    if(ret){
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization/reverse?devTid=%@&ctrlKey=%@&reverseRegisterId=%@",devTid,ctrlKey,token] parameters:@{} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[同意授权]：%@",responseObject);
            //            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(@"授权成功", @"") buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            //                [self loadReverseAuthorization:nil isUserChose:NO];
            //            }] show];
            [self.view.window makeToast:NSLocalizedString(@"授权成功", @"") duration:1.0 position:@"center"];
            [self loadReverseAuthorization:nil isUserChose:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(APIError(error), @"")  buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            //                [self loadReverseAuthorization:nil isUserChose:NO];
            //            }] show];
            if ([APIError(error) isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"授权失败", @"") duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(APIError(error), @"") duration:1.0 position:@"center"];
            }
            
            [self loadReverseAuthorization:nil isUserChose:NO];
        }];
    }else{
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] DELETE:[NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization/reverse/register/%@",token] parameters:@{@"devTid":devTid,@"ctrlKey":ctrlKey,@"uid":uid} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[拒绝授权]：%@",responseObject);
            //            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:NSLocalizedString(@"授权请求已拒绝", @"") buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            //                [self loadReverseAuthorization:nil isUserChose:NO];
            //            }] show];
            [self.view.window makeToast:NSLocalizedString(@"授权请求已拒绝", @"") duration:1.0 position:@"center"];
            [self loadReverseAuthorization:nil isUserChose:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *str = APIError(error);
            //            [[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", @"") andMessage:str buttonTitles:nil cancelTitle:NSLocalizedString(@"确定", @"") withBlock:^(NSInteger theButtonIndex) {
            //                [self loadReverseAuthorization:nil isUserChose:NO];
            //            }] show];
            [self.view.window makeToast:str duration:1.0 position:@"center"];
            [self loadReverseAuthorization:nil isUserChose:NO];
        }];
    }
}
@end
