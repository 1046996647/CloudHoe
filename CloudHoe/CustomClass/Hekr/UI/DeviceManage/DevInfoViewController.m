//
//  DevInfoViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DevInfoViewController.h"
#import "THCircularProgressView.h"
#import <SHAlertViewBlocks.h>

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@interface DevInfoViewController ()
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)THCircularProgressView *progressView;
@property(nonatomic,strong)UIView *updateView;
@property(nonatomic)NSTimer *timer;
@end

@implementation DevInfoViewController
{
    BOOL _isUpdata;
    HekrDevice *_data;
    id _otarule;
    UIButton *_upDataButton;
    BOOL _isStop;
}

- (instancetype)initWIthupData:(BOOL)isUpdata Data:(HekrDevice *)data OtaRule:(id)otarule{
    self = [super init];
    if (self) {
        _isUpdata = isUpdata;
        _data = data;
        _otarule = otarule;
        _isStop = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = getViewBackgroundColor();
    // Do any additional setup after loading the view.
    [self initNavView];
    [self createView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"DevInfo"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [MobClick endLogPageView:@"DevInfo"];
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)initNavView
{
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"设备固件信息", nil);
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
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"设备固件信息" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createView{
    _updateView = [[UIView alloc]initWithFrame:CGRectMake(0, Vrange(10)+StatusBarAndNavBarHeight, ScreenWidth, Vrange(110))];
    _updateView.backgroundColor = getCellBackgroundColor();
    [self.view addSubview:_updateView];
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(34), 0, ScreenWidth/3*2, Vrange(110))];
    NSString *str = [NSString stringWithFormat:@"%@%@(%@)",NSLocalizedString(@"固件版本",nil),_data.props[@"binVersion"],_data.props[@"binType"]];
    _label.text = str;
    _label.font = getListTitleFont();
    _label.textColor = getTitledTextColor();
    [_updateView addSubview:_label];
    
    if (_isUpdata == NO) {
        UILabel *updataLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-Hrange(44)-100, 0, 100, Vrange(110))];
        updataLabel.textAlignment = NSTextAlignmentRight;
        updataLabel.text = NSLocalizedString(@"已更新", nil);
        updataLabel.textColor = getDescriptiveTextColor();
        updataLabel.font = getListTitleFont();
        [_updateView addSubview:updataLabel];
    }else{
        _upDataButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upDataButton.frame = CGRectMake(ScreenWidth-Hrange(20)-80, (Vrange(110)-30)/2, 80, 30);
        if (_data.online) {
            _upDataButton.backgroundColor = rgb(245, 103, 53);
            _upDataButton.userInteractionEnabled = YES;
        }else{
            _upDataButton.backgroundColor = rgb(128, 128, 130);
            _upDataButton.userInteractionEnabled = NO;
        }
        //        _upDataButton.backgroundColor = rgb(245, 103, 53);
        _upDataButton.layer.cornerRadius = 5;
        [_upDataButton setTitle:NSLocalizedString(@"更新固件", nil) forState:UIControlStateNormal];
        [_upDataButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _upDataButton.titleLabel.font = getListTitleFont();
        [_upDataButton addTarget:self action:@selector(upDataAction) forControlEvents:UIControlEventTouchUpInside];
        [_updateView addSubview:_upDataButton];
    }
}

- (void)upDataAction{
    _upDataButton.hidden = YES;
    _progressView = [[THCircularProgressView alloc]initWithFrame:CGRectMake(ScreenWidth - Hrange(70) - Hrange(40), (Vrange(110)-Hrange(40))/2, Hrange(40), Hrange(40))];
    _progressView.lineWidth = 2;
    _progressView.progressColor = rgb(245, 103, 53);
    //    _progressView.centerLabel.font = [UIFont boldSystemFontOfSize:radius];
    _progressView.centerLabelVisible = YES;
    [_updateView addSubview:_progressView];
    
    _isStop = NO;
    _timer=[NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    [self updateDeviceFirmware:_otarule device:_data];
}

-(void) updateDeviceFirmware:(id) info device:(HekrDevice*) dev{
    __weak typeof(self) wself = self;
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSDictionary * map = @{@"binUrl":@"binUrl",@"md5":@"md5",@"binType":@"latestBinType",@"binVer":@"latestBinVer",@"size":@"size"};
    for (id key in [map allKeys]) {
        id val = [info objectForKey:[map objectForKey:key]];
        if(val)
            [param setObject:val forKey:key];
    }
    [param setObject:dev.tid forKey:@"devTid"];
    [param setObject:dev.ctrlKey forKey:@"ctrlKey"];
    
    NSDictionary * command = @{@"action" : @"devUpgrade",
                               @"params" : param
                               };
    NSDictionary * filter = @{@"action" : @"devSend",
                              @"params" : @{
                                      @"devTid" : dev.tid,
                                      @"data" : @{
                                              @"upgradeProgress" : [NSNull null],  //百分比进度
                                              @"upgradeState" : [NSNull null]   // 0："成功" ，1："下载中" ， 2："固件校验失败" ， 3："超时" ，4："连接失败"
                                              }
                                      }
                              };
    [[Hekr sharedInstance] sendNet:command to:dev.tid timeout:20.0f callback:^(id data, NSError *err) {
        typeof(self) sself = wself;
        DDLogVerbose(@" recv response:%@",data);
        if(data){
            //upgrde start
        }else{
            
            [sself alertFail];
        }
    }];
    [[Hekr sharedInstance] recv:filter obj:self callback:^(id obj, id data,NSError* err) {
        typeof(self) sself = wself;
        DDLogVerbose(@" recv progress:%@",data);
        NSUInteger state = [[[[data objectForKey:@"params"] objectForKey:@"data"] objectForKey:@"upgradeState"] integerValue];
        NSUInteger progress = [[[[data objectForKey:@"params"] objectForKey:@"data"] objectForKey:@"upgradeProgress"] integerValue];
        switch (state) {
            case 0: //finish
            {
                [sself devSuccess];
            }
                break;
            case 1://upgrade
            case 2:
                sself.progressView.percentage = progress/100.0;
                //do progress [0 -- 100]
                break;
            case 3://fail
            case 4:
            {
                [sself alertFail];
            }
                break;
            default:
                break;
        }
    }];
}

-(void)devSuccess{
    [[Hekr sharedInstance] removeRecvOfObj:self];

    _progressView.hidden = YES;
    UILabel *updataLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-Hrange(44)-50, 0, 50, Vrange(110))];
    updataLabel.textAlignment = NSTextAlignmentRight;
    updataLabel.text = NSLocalizedString(@"已更新", nil);
    updataLabel.textColor = getDescriptiveTextColor();
    updataLabel.font = [UIFont systemFontOfSize:16];
    [_updateView addSubview:updataLabel];
//    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"固件版本 %@",nil),_otarule[@"latestBinVer"]];
    NSString *str = [NSString stringWithFormat:@"%@ %@(%@)",NSLocalizedString(@"固件版本",nil),_otarule[@"latestBinVer"],_otarule[@"latestBinType"]];
    _label.text = str;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVer" object:nil userInfo:_otarule];
}

- (void)alertFail{
    [[Hekr sharedInstance] removeRecvOfObj:self];
    if (_progressView.percentage > 0) {
        return;
    }
    _isStop = YES;
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
//    UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"升级失败，请重试", nil)];
//    [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
//        _progressView.hidden = YES;
//        _upDataButton.hidden = NO;
//    }];
//    [alert show];
    
    [self showAlertPromptWithTitle:@"升级失败，请重试" actionCallback:^(UIAlertAction * _Nonnull action) {
        _progressView.hidden = YES;
        _upDataButton.hidden = NO;
    }];
}

- (void)timerOut{
    if (_isStop == YES || _progressView.hidden == YES) {
        return;
    }
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
//    UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:nil withMessage:NSLocalizedString(@"Time out", nil)];
//    [alert SH_addButtonWithTitle:NSLocalizedString(@"我知道了", nil) withBlock:^(NSInteger theButtonIndex) {
//        _progressView.hidden = YES;
//        _upDataButton.hidden = NO;
//    }];
//    [alert show];
    
    [self showAlertPromptWithTitle:@"Time out" actionCallback:^(UIAlertAction * _Nonnull action) {
        _progressView.hidden = YES;
        _upDataButton.hidden = NO;
    }];
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
