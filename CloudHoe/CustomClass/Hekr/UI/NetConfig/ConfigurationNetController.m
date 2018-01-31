//
//  ConfigurationNetController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/11.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigurationNetController.h"
#import "WIFIConfigViewController.h"
#import <HekrAPI.h>
#import "Tool.h"
#import "ConfigCueView.h"
#import "ConfigNet.h"
#import "ConfigAnimationView.h"
#import "ConfigPromptViewController.h"
#import "InstrucDetailViewController.h"
#import "ConfigPWViewController.h"
#import "ConfigWorkViewController.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define HEIGHT                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*WIDTH
//#define Vrange(x)  (x/568.0)*HEIGHT
@interface ConfigurationNetController ()<ConfigAnimationDelegate>
@property(nonatomic ,strong)ConfigCueView *modalView;
@property (nonatomic, strong)UIVisualEffectView *visualEffectView;
@property (nonatomic, strong)ConfigAnimationView *animationView;
@property (nonatomic, strong)UIView *backwhite;
@property (nonatomic, strong)NSMutableArray *logoArray;
@property (nonatomic, copy)NSString *bindKey;
@property (nonatomic, copy)NSString *devTid;
@end

@implementation ConfigurationNetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _logoArray = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    [self initNavView];
    [self createViews];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"Config"];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"Config"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initNavView
{
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"添加设备" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)createViews{
  
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+StatusBarAndNavBarHeight, ScreenWidth, (ScreenHeight-StatusBarAndNavBarHeight-60)/2)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    
    ConfigNet *netViewWifi = [ConfigNet instanceConfigNetWitch:@"icon-wifiLogo" configNetClassText:@"WI-FI配网" configNetClassTextColor:UIColorFromHex(0xff825c) configNetNodeText:@"打开Wi-Fi，连接设备" configNetNodeTextColor:UIColorFromHex(0x999999)];
    netViewWifi.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(topView.frame));
    [topView addSubview:netViewWifi];

    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame)+20, ScreenWidth, CGRectGetHeight(topView.frame))];
    downView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:downView];
    
    ConfigNet *netVieScan = [ConfigNet instanceConfigNetWitch:@"icon-twoLogo" configNetClassText:@"扫一扫" configNetClassTextColor:UIColorFromHex(0x0dceeb) configNetNodeText:@"设备上有二维码扫描" configNetNodeTextColor:UIColorFromHex(0x999999)];
    netVieScan.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(topView.frame));
    [downView addSubview:netVieScan];
    
    UIButton *wifiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    wifiButton.frame = netViewWifi.frame;
    [wifiButton setExclusiveTouch:YES];
    [wifiButton addTarget:self action:@selector(wifiAction) forControlEvents:UIControlEventTouchUpInside];
    [netViewWifi addSubview:wifiButton];
    
    UIButton *twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twoButton.frame = netVieScan.frame;
    [twoButton setExclusiveTouch:YES];
    [twoButton addTarget:self action:@selector(twoAction) forControlEvents:UIControlEventTouchUpInside];
    [netVieScan addSubview:twoButton];
}

- (void)wifiAction{
    
    ConfigPWViewController *cpwVC = [[ConfigPWViewController alloc] initWithNibName:@"ConfigPWViewController" bundle:nil];
    [cpwVC setConfigDeviceType:ConfigDeviceTypeNormal];
//    [cpwVC setConfigDeviceType:ConfigDeviceTypeSoftAP];
    [self.navigationController pushViewController:cpwVC animated:YES];
    
//    if (_modalView) {
//        [self.view.window addSubview:_modalView];
//    }else{
//        _modalView = [[ConfigCueView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) NetAction:@selector(netAction) Cancel:@selector(cancel) Next:@selector(next) Delegate:self];
//        [self.view.window addSubview:_modalView];
//
//    }
//    [self modalViewShow];
}

- (void)modalViewShow{
    [UIView animateWithDuration:0.3 animations:^{
        _modalView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _modalView.bgView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)twoAction{

    [[Hekr sharedInstance] scanQRCode:self title:NSLocalizedString(@"扫一扫", @"") block:^(id str, id error) {
        if (str) {
            [self qrcode:str];
        }else if(error){
            DDLogVerbose(@"%@",error);
        }
    }];
}


-(void) qrcode:(NSString*) code{
    NSString* query = [[NSURL URLWithString:code] query];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString* q in [query componentsSeparatedByString:@"&"]) {
        NSArray * s = [q componentsSeparatedByString:@"="];
        if (s.firstObject && s.lastObject) {
            [dict setObject:s.lastObject forKey:s.firstObject];
        }
    }
    
    NSString * action = [dict objectForKey:@"action"];
    if ([action isEqualToString:@"rauth"]) {
        if (![self reverseAuthorization:dict]) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"暂不支持此二维码",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show];
        }
    }else if ([action isEqualToString:@"gateway"]){
        
        
    }else if ([action isEqualToString:@"bind"]){
        _bindKey = dict[@"bindKey"];
        _devTid = dict[@"devTid"];
        if (!_bindKey || !_devTid) {
            return;
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
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //    _visualEffectView.backgroundColor = [UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1.0];
        [_backwhite addSubview:_visualEffectView];
        [UIView animateWithDuration:0.3 animations:^{
            _backwhite.alpha = 1;
        } completion:^(BOOL finished) {
            _animationView = [[ConfigAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, Height) isScan:YES];
            _animationView.center = CGPointMake(Width/2, Height/2);
            _animationView.delegata = self;
            [self.view addSubview:_animationView];
            
            NSDictionary *dic = @{@"devTid":_devTid,
                                @"bindKey":_bindKey};
            //配网逻辑
            [self performSelector:@selector(configLogic:) withObject:dic afterDelay:3.0];
        }];
        
    }/*else if ([action isEqualToString:@"conf"]){
        
    }*/else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"暂不支持此二维码",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show];
    }
}

-(BOOL) reverseAuthorization:(NSDictionary*) infos{
    NSString * tmpID = [infos objectForKey:@"token"];
    if (tmpID) {
        NSLog(@"-----%@",[NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization/reverse/register?reverseTemplateId=%@&grantee=%@",tmpID,[Hekr sharedInstance].user.uid]);
        [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:[NSString stringWithFormat:@"http://user.openapi.hekr.me/authorization/reverse/register?reverseTemplateId=%@&grantee=%@",tmpID,[Hekr sharedInstance].user.uid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogInfo(@"[扫码请求授权]：%@",responseObject);
            [self.view.window makeToast:NSLocalizedString(@"已向对方请求授权，请等待对方同意",nil) duration:1.0 position:@"center"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString *str = APIError(error);
            if (APIErrorCode(error) == 6400017) {
               [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示",nil) message:NSLocalizedString(@"无法授权给相同账号",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定",nil) otherButtonTitles:nil] show]; 
            }else if ([str isEqualToString:@"0"]) {
                [self.view.window makeToast:NSLocalizedString(@"请求发送失败",nil) duration:1.0 position:@"center"];
            }else{
                [self.view.window makeToast:NSLocalizedString(str,nil) duration:1.0 position:@"center"];
            }
        }];
        return YES;
    }
    return NO;
}

- (void)cancel{
    [UIView animateWithDuration:0.3 animations:^{
        _modalView.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _modalView.alpha = 0;
        } completion:^(BOOL finished) {
            [_modalView removeFromSuperview];
        }];
    }];
    }
- (void)next{
    [UIView animateWithDuration:0.3 animations:^{
        _modalView.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _modalView.alpha = 0;
//            [self.navigationController pushViewController:[WIFIConfigViewController new] animated:NO];
            
            ConfigPWViewController *cpwVC = [[ConfigPWViewController alloc] initWithNibName:@"ConfigPWViewController" bundle:nil];
            [cpwVC setConfigDeviceType:ConfigDeviceTypeSoftAP];
            [self.navigationController pushViewController:cpwVC animated:NO];
            
        } completion:^(BOOL finished) {
            [_modalView removeFromSuperview];
        }];
    }];
    
    
}
- (void)netAction{
    if ([lang() isEqualToString:@"en-US"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hekr.daikeapp.com/kb/articles/1688"]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hekr.daikeapp.com/kb/articles/1672"]];
    }
    
}

#pragma mark ------------- 2G扫码
- (void)configLogic:(NSDictionary *)dic{
//    NSDictionary *dic = @{@"devTid":devTid,
//                          @"bindKey":bindKey};
    //获取绑定状态 是否被绑 是否允许强绑
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://user.openapi.hekr.me/deviceBindStatus" parameters:@[dic] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[设备是否允许强绑]：%@",responseObject);
        id logoInfo = responseObject;
        DDLogVerbose(@"check devices:[%@]%@",_devTid,responseObject);
        id dict = [responseObject firstObject];
        if ([[dict objectForKey:@"devTid"] isEqualToString:_devTid] && (![dict[@"bindToUser"] boolValue] || [dict[@"forceBind"] boolValue])) {
            //绑定
            [[Hekr sharedInstance]bindDevice:dic callback:^(id responseObject, NSError * error) {
                DDLogInfo(@"[绑定设备（old）]：tid:%@\n%@",_devTid,responseObject);
                if (responseObject && [responseObject objectForKey:@"ctrlKey"] && [responseObject objectForKey:@"logo"]) {
                    DDLogVerbose(@"bind devices:%@",_devTid);
                    [_logoArray addObject:responseObject];
                    NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil userInfo:@{@"info":responseObject}];
                    [[NSNotificationCenter defaultCenter]postNotification:notification];
                    [_animationView stopAnamation:_logoArray];
                }else{
                    //已绑
                    [_animationView configFail];
                }
            }];
        }else{
            
            //获取被绑定设备属主信息
            [[[Hekr sharedInstance] sessionWithDefaultAuthorization]POST:@"http://user.openapi.hekr.me/queryOwner" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                DDLogInfo(@"[查询设备属主信息]：%@",responseObject);
                NSString *str = isEN() == YES ? logoInfo[0][@"categoryName"][@"en_US"] : logoInfo[0][@"categoryName"][@"zh_CN"];
                NSArray *cidNameArray = [str componentsSeparatedByString:@"/"];
                NSDictionary *devInfo = @{@"message":responseObject[@"message"],
                                          @"logo":logoInfo[0][@"logo"],@"cidName":cidNameArray[1]};
                
                [_logoArray addObject:devInfo];
                [_animationView stopAnamation:_logoArray];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [_animationView configFail];
                DDLogVerbose(@"deviceControl error:[%@]%@",_devTid,error);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_animationView configFail];
        DDLogVerbose(@"check devices:[%@]%@",_devTid,error);
    }];
  
}

#pragma mark ------------- 动画代理
- (void)animationViewCancel{
    [_logoArray removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        _animationView.center = CGPointMake(self.view.center.x, self.view.center.y-44);
        _animationView.alpha = 0;
    } completion:^(BOOL finished) {
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
- (void)animationViewWillConfig{
    [_logoArray removeAllObjects];
}
- (void)animationViewConfig{
    NSDictionary *dic = @{@"devTid":_devTid,
                          @"bindKey":_bindKey};
    //配网逻辑
    [self performSelector:@selector(configLogic:) withObject:dic afterDelay:3.0];
}
- (void)animationViewsolve{
        [self animationViewCancel];
    InstrucDetailViewController *detailView = [[InstrucDetailViewController alloc]initWithTitle:NSLocalizedString(@"配网问题帮助", nil) Number:4];
    [self.navigationController pushViewController:detailView animated:YES];
}
- (void)animationViewWillPop{
//    NSNotification *notification = [NSNotification notificationWithName:@"configStop" object:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
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
