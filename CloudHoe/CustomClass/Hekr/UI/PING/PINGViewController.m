//
//  PINGViewController.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "PINGViewController.h"
#import "Tool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <HekrAPI.h>
#import "STDPingServices.h"

@interface PINGViewController ()
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet UILabel *line3;
@property (weak, nonatomic) IBOutlet UILabel *line4;
@property (weak, nonatomic) IBOutlet UILabel *isNetwork;
@property (weak, nonatomic) IBOutlet UILabel *networkType;
@property (weak, nonatomic) IBOutlet UILabel *phoneIP;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UILabel *url1;
@property (weak, nonatomic) IBOutlet UILabel *url2;
@property (weak, nonatomic) IBOutlet UILabel *url3;
@property (weak, nonatomic) IBOutlet UILabel *url4;
@property (weak, nonatomic) IBOutlet UILabel *isNet;
@property (weak, nonatomic) IBOutlet UILabel *netType;
@property (weak, nonatomic) IBOutlet UILabel *ipAddress;
@property (weak, nonatomic) IBOutlet UILabel *ping1;
@property (weak, nonatomic) IBOutlet UILabel *ping2;
@property (weak, nonatomic) IBOutlet UILabel *ping3;
@property (weak, nonatomic) IBOutlet UILabel *ping4;

@property (nonatomic, strong) STDPingServices    *pingServices1;
@property (nonatomic, strong) STDPingServices    *pingServices2;
@property (nonatomic, strong) STDPingServices    *pingServices3;
@property (nonatomic, strong) STDPingServices    *pingServices4;
@end

@implementation PINGViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = getViewBackgroundColor();
    _line1.backgroundColor = getCellLineColor();
    _line2.backgroundColor = getCellLineColor();
    _line3.backgroundColor = getCellLineColor();
    _line4.backgroundColor = getCellLineColor();
    _isNetwork.textColor = getTitledTextColor();
    _networkType.textColor = getTitledTextColor();
    _phoneIP.textColor = getTitledTextColor();
    _testLabel.textColor = getTitledTextColor();
    _url1.textColor = getTitledTextColor();
    _url2.textColor = getTitledTextColor();
    _url3.textColor = getTitledTextColor();
    _url4.textColor = getTitledTextColor();
    _isNet.textColor = getDescriptiveTextColor();
    _netType.textColor = getDescriptiveTextColor();
    _ipAddress.textColor = getDescriptiveTextColor();
    _ping1.textColor = getDescriptiveTextColor();
    _ping2.textColor = getDescriptiveTextColor();
    _ping3.textColor = getDescriptiveTextColor();
    _ping4.textColor = getDescriptiveTextColor();
    [self initNavView];
    [self isHaveNet];
    [self getNetType];
    [self getIpAddress];
    [self getPing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initNavView
{
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.navigationController.navigationBar.barTintColor = getNavBackgroundColor();
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 0, 100, 30)];
//    titLabel.backgroundColor = [UIColor clearColor];
//    titLabel.textAlignment = NSTextAlignmentCenter;
//    titLabel.text = NSLocalizedString(@"网络诊断", nil);
//    titLabel.font = [UIFont systemFontOfSize:18];
//    titLabel.textColor = getNavTitleColor();
//    self.navigationItem.titleView = titLabel;
//    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:getNavPopBtnImg()] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
//    left.tintColor = [UIColor blackColor];
//    
//    self.navigationItem.leftBarButtonItem = left;
    
    HekrNavigationBarView *nav = [[HekrNavigationBarView alloc]initWithFrame:BarViewRectMake withTitle:@"网络诊断" leftBarButtonAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    } withRightTitle:nil leftBarButtonAction:nil];
    [self.view addSubview:nav];
}

- (void)popClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)isHaveNet{
    if ([[[Hekr sharedInstance] reachability] isReachable]) {
        _isNet.text = @"YES";
    }else{
        _isNet.text = @"NO";
    }
}

- (void)getNetType{
    if ([[[Hekr sharedInstance] reachability] isReachable]) {
        if ([[[Hekr sharedInstance] reachability] isReachableViaWWAN]) {
            _netType.text = @"2G/3G/4G";
        }else if ([[[Hekr sharedInstance] reachability] isReachableViaWiFi]){
            _netType.text = @"Wi-Fi";
        }else{
            _netType.text = @"UNKOWN";
        }
    }
}

- (void)getIpAddress{
    _ipAddress.text = [self getIPAddress];
}

- (NSString *)getIPAddress {
    NSString *address = @"UNKOWN";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (void)getPing{
    _pingServices1 = [STDPingServices startPingAddress:[[_url1.text componentsSeparatedByString:@" "] lastObject] callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            _ping1.text = pingItem.description;
        }
    }];
    _pingServices2 = [STDPingServices startPingAddress:[[_url2.text componentsSeparatedByString:@" "] lastObject] callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            _ping2.text = pingItem.description;
        }
    }];
    _pingServices3 = [STDPingServices startPingAddress:[[_url3.text componentsSeparatedByString:@" "] lastObject] callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            _ping3.text = pingItem.description;
        }
    }];
    _pingServices4 = [STDPingServices startPingAddress:[[_url4.text componentsSeparatedByString:@" "] lastObject] callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            _ping4.text = pingItem.description;
        }
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
