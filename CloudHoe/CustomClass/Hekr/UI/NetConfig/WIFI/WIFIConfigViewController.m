//
//  WIFIConfigViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "WIFIConfigViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <HekrAPI.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <SHAlertViewBlocks.h>
#import "InstrucDetailViewController.h"
#import "ConfigAnimationView.h"
#import "ConfigPassWordView.h"
#import "ConfigPromptViewController.h"
#import "DevicesModel.h"
#import "DevicesViewController.h"


#define CONFIG 0  //1.old  0.new


@class HekrDevice;
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define ringLineBackGroundColor   rgb(190,240,230)
//#define ringLineColor rgb(75,200,200)
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface WIFIConfigViewController ()<ConfigAnimationDelegate, ConfigPassWordDelegate>
@property (nonatomic, strong)ConfigPassWordView *passWordView;
@property (nonatomic, strong)NSMutableArray *logoArray;
@property (nonatomic, strong)UIVisualEffectView *visualEffectView;
@property (nonatomic, strong)ConfigAnimationView *animationView;
@property (nonatomic, strong)UIView *backwhite;
@property (nonatomic, strong)NSMutableDictionary *searchDevs;
@property (nonatomic, strong)NSMutableDictionary *sumDevs;
@property (nonatomic, assign)BOOL isStop;
@property (nonatomic, copy)NSString *wifiName;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, strong)NSMutableDictionary *getDevBinds;
@end

@implementation WIFIConfigViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _logoArray = [NSMutableArray new];
    self.view.backgroundColor = getViewBackgroundColor();
    _searchDevs = [NSMutableDictionary new];
    _sumDevs = [NSMutableDictionary new];
    _getDevBinds = [NSMutableDictionary new];
    [self initNavView];
    [self createViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreAnimation) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSSID) name:@"HEKRchangeNet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDevBind:) name:@"HEKRdevBing" object:nil];
}



- (void)restoreAnimation{
//    if (_animationView && !_isStop) {
//        _animationView.isBackground = YES;
//        [[Hekr sharedInstance] stopConfig];
//        [[self class] cancelPreviousPerformRequestsWithTarget:self];
//        [_animationView cancelPreviousPer];
//        [self configAnimationStop];
//    }
}

- (void)refreshSSID{
    [_passWordView refreshSSID];
}

- (void)addDevBind:(NSNotification *)sender{
    NSDictionary *d = sender.userInfo[@"devBind"];
    [_getDevBinds setObject:d forKey:[NSString stringWithFormat:@"dev--%@",[d objectForKey:@"devTid"]]];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WiFiConfig"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WiFiConfig"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
}
//导航设置相关
- (void)initNavView{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"添加设备" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}
- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//输入密码页面
- (void)createViews{
    _passWordView = [[ConfigPassWordView alloc]initWithFrame:CGRectMake(0, 64, Width, Height)];
    _passWordView.delegate = self;
    [self.view addSubview:_passWordView];
}
//准备开始配网
- (void)congfigStarActionWifiName:(NSString *)wifiName PassWord:(NSString *)passWord{
    _wifiName = wifiName;
    _passWord = passWord;
    [self configAction];
}

- (void)configAction {
#if 1
    if (_wifiName == nil) {
        [self showAlertPromptWithTitle:NSLocalizedString(@"请连接WIFI",nil) actionCallback:nil];
        return;
    }else{
        [self configStar];
    }
#else
    [self configStar];
#endif
    
}

#pragma mark - 开始配网
- (void)configStar{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@savewifipassword",[Hekr sharedInstance].user.access_token]] isEqualToString:@"YES"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_passWord forKey:[NSString stringWithFormat:@"%@%@",[Hekr sharedInstance].user.access_token,_wifiName]];
        
    }
    _backwhite=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _backwhite.alpha = 0;
    [self.view addSubview:_backwhite];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        _backwhite.backgroundColor = [UIColor whiteColor];
    }else{
        _backwhite.backgroundColor = [UIColor clearColor];
    }
    
    //高斯模糊
    UIBlurEffectStyle style = isNightTheme() ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //    _visualEffectView.backgroundColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0];
    [_backwhite addSubview:_visualEffectView];
    [UIView animateWithDuration:0.3 animations:^{
        _backwhite.alpha = 1;
    } completion:^(BOOL finished) {
        _animationView = [[ConfigAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, Height) isScan:NO];
        _animationView.center = CGPointMake(Width/2, Height/2);
        _animationView.delegata = self;
        [self.view addSubview:_animationView];
        //配网逻辑
        [self configLogic];
    }];
    
}
-(void) showDevInfo:(id) info{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [hud setLabelText:[info objectForKey:@"devTid"]];
    [hud hide:YES afterDelay:3];
}
//发现设备停止 相关动画及操作
- (void)configStop{
    [[Hekr sharedInstance] stopConfig];
}

#pragma mark - 90S搜索时间到
- (void)configAnimationStop{
    
    _isStop = YES;
    NSArray *arr = [_searchDevs allKeys];
    if (arr.count > 0) {
        return;
    }

    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [_animationView cancelPreviousPer];
    _animationView.isHave = NO;
//    NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    if (_logoArray.count == 0) {
        [_animationView configFail];
        DDLogWarn(@"[配网结束]");
        DDLogWarn(@"[本次配网共收到 %ld 个devBind]",_getDevBinds.allKeys.count);
        [_getDevBinds removeAllObjects];
    }else{
        [_animationView configSuccess];
    }
}

#pragma mark - 配网逻辑
-(void) configLogic{
    _isStop = NO;
    [self performSelector:@selector(configAnimationStop) withObject:nil afterDelay:90];
    [self performSelector:@selector(configStop) withObject:nil afterDelay:85];
    
    
    DDLogWarn(@"[开始配网]");
    
    NSDate * start = [NSDate new];
    
#if 1
    //搜索设备
    [[Hekr sharedInstance] configSearch:_wifiName pwd:_passWord refreshPin:YES callback:^(id infos, NSError* error) {
        
#if CONFIG
        //旧的配网流程
        if (infos && [infos objectForKey:@"devTid"] && [infos objectForKey:@"bindKey"]) {
            //            [self showDevInfo:infos];
            NSDictionary *dic = @{@"devTid":[infos objectForKey:@"devTid"],
                                  @"bindKey":[infos objectForKey:@"bindKey"]};
            //获取绑定状态 是否被绑 是否允许强绑
            if ([_sumDevs objectForKey:[infos objectForKey:@"devTid"]]==nil) {
                
                [_sumDevs setObject:infos forKey:[infos objectForKey:@"devTid"]];
                [_searchDevs setObject:infos forKey:[infos objectForKey:@"devTid"]];
                [self configBind:infos Dic:dic];
            }
        }
#else
        if (error) {
            [self performSelector:@selector(configError) withObject:nil afterDelay:1.0];
            return;
        }
        
        DDLogWarn(@"[获取到新设备] 用时:%f",[[NSDate new] timeIntervalSinceDate:start]);
        //新的配网流程
        if (infos && [infos isKindOfClass:[NSDictionary class]]) {
            if (![infos[@"bindResultCode"] boolValue]) {
                NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil userInfo:@{@"info":infos}];
                [[NSNotificationCenter defaultCenter]postNotification:notification];
            }
            [self startBindAnimation:infos];
//            DDLogVerbose(@"Bind Device Tid:%@\n bind:%@\n msg:%@",infos[@"devTid"],infos[@"bindResultCode"],infos[@"bindResultMsg"]);
        }
#endif
        
    }];
#else
    [self performSelector:@selector(test) withObject:nil afterDelay:3];
#endif
    
    _animationView.isHave = YES;
}

- (void)configError{
    [self configStop];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [self configAnimationStop];
}

- (void)startBindAnimation:(NSDictionary *)device{
    if (device) {
        
        if (_isStop) {
            [self configAnimationStop];
        }
        [_logoArray addObject:device];
        [_animationView stopAnamation:_logoArray];
    }
}

- (void)configBind:(id)infos Dic:(NSDictionary *)dic{
    //获取绑定状态 是否被绑 是否允许强绑
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user.openapi.hekr.me/deviceBindStatus" parameters:@[dic] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id logoInfo = responseObject;
        DDLogVerbose(@"check devices:[%@]%@",[infos objectForKey:@"devTid"],responseObject);
        id dict = [responseObject firstObject];
        if ([[dict objectForKey:@"devTid"] isEqualToString:[infos objectForKey:@"devTid"]] && (![dict[@"bindToUser"] boolValue] || [dict[@"forceBind"] boolValue])) {
            //绑定
            [[Hekr sharedInstance]bindDevice:infos callback:^(id responseObject, NSError * error) {
                [_searchDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
                if (_isStop == YES) {
                    [self configAnimationStop];
                }
                DDLogVerbose(@"bind devices:[%@]%@",[infos objectForKey:@"devTid"],responseObject);
                if (responseObject && [responseObject objectForKey:@"ctrlKey"] && [responseObject objectForKey:@"logo"]) {
                    DDLogVerbose(@"bind devices:%@",[infos objectForKey:@"devTid"]);
                    [_logoArray addObject:responseObject];
//                    if (_logoArray.count == 1) {
//                        [_animationView configSearched:_logoArray];
//                    }else{
//                        [_animationView stopAnamation:_logoArray];
//                    }
                    [_animationView stopAnamation:_logoArray];
                }else{
                    //已绑
                    [_sumDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
                    DDLogVerbose(@"bind devices:[%@]%@",[infos objectForKey:@"devTid"],error);
                }
            }];
        }else{
            [_searchDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
            if (_isStop == YES) {
                [self configAnimationStop];
            }
            //获取被绑定设备属主信息
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization]POST:@"http://user.openapi.hekr.me/queryOwner" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *str = isEN() == YES ? logoInfo[0][@"categoryName"][@"en_US"] : logoInfo[0][@"categoryName"][@"zh_CN"];
                NSArray *cidNameArray = [str componentsSeparatedByString:@"/"];
                NSDictionary *devInfo = @{@"message":responseObject[@"message"],
                                          @"logo":logoInfo[0][@"logo"],@"cidName":cidNameArray[1]};
                
                [_logoArray addObject:devInfo];
//                if (_logoArray.count == 1) {
//                    [_animationView configSearched:_logoArray];
//                }else{
//                    [_animationView stopAnamation:_logoArray];
//                }
                [_animationView stopAnamation:_logoArray];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [_sumDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
                DDLogVerbose(@"deviceControl error:[%@]%@",[infos objectForKey:@"devTid"],error);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_sumDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
        [_searchDevs removeObjectForKey:[infos objectForKey:@"devTid"]];
        if (_isStop == YES) {
            [self configAnimationStop];
        }
        DDLogVerbose(@"check devices:[%@]%@",[infos objectForKey:@"devTid"],error);
    }];

}

//测试
- (void)test{
    int x = arc4random() % 100;
    NSDictionary *dict;
    if (x % 2 == 0) {
        dict = @{@"message":@"135XXXX1234",
                 @"logo":@"1111",@"cidName":@"加湿器"};
    }else{
        dict = @{@"logo":@"1111"};
    }
    [_logoArray addObject:dict];
//    if (_logoArray.count == 1) {
//        [_animationView configSearched:_logoArray];
//    }else{
//        [_animationView stopAnamation:_logoArray];
//    }
    [_animationView stopAnamation:_logoArray];
    [self performSelector:@selector(test) withObject:nil afterDelay:3];
}

//配网动画页面代理
#pragma mark - configAnimationViewDelegate
- (void)animationViewWillConfig{
    [_logoArray removeAllObjects];
}

- (void)animationViewConfig{
    [self configLogic];
}

- (void)animationViewsolve{
//    [self animationViewCancel];
    InstrucDetailViewController *detailView = [[InstrucDetailViewController alloc]initWithTitle:NSLocalizedString(@"配网问题帮助", nil) Number:4];
    [self.navigationController pushViewController:detailView animated:YES];
}

- (void)animationViewCancel{
    [[Hekr sharedInstance] stopConfig];
    [UIView animateWithDuration:0.3 animations:^{
        _animationView.center = CGPointMake(self.view.center.x, self.view.center.y-44);
        _animationView.alpha = 0;
    } completion:^(BOOL finished) {
        [_logoArray removeAllObjects];
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
        [_animationView cancelPreviousPer];
        [_animationView viewsRemoveFromSuperview];
        [_backwhite removeFromSuperview];
        [_animationView removeFromSuperview];
        _animationView = nil;
        [UIView animateWithDuration:0.3 animations:^{
            _backwhite.alpha = 0;
        } completion:^(BOOL finished) {
            [_backwhite removeFromSuperview];
        }];
    }];
}

- (void)animationViewWillPop{
    [[Hekr sharedInstance] stopConfig];
    if (_animationView.isHave == YES) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)animationViewPop{
    [_backwhite removeFromSuperview];
    [_animationView removeFromSuperview];
    [_backwhite removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)animationViewPrompt:(NSMutableArray *)array{
    ConfigPromptViewController *proView = [[ConfigPromptViewController alloc]initWith:array];
    [self.navigationController pushViewController:proView animated:YES];
}

- (void)animationViewStop{
    DDLogWarn(@"[配网结束]");
    DDLogWarn(@"[本次配网共收到 %ld 个devBind]",_getDevBinds.allKeys.count);
    [_getDevBinds removeAllObjects];
    _isStop = YES;
    [self configStop];
    [_animationView cancelPreviousPer];
    _animationView.isHave = NO;
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
//    NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
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

@interface UITextView(MYTextView)

@end

@implementation UITextView (MYTextView)
- (void)_firstBaselineOffsetFromTop {
    
}

- (void)_baselineOffsetFromBottom {
    
}

@end

