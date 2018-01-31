//
//  EnvironmentView.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "EnvironmentView.h"
#import <HekrAPI.h>
#import <HekrSDK.h>
#import "Tool.h"
#import "TNKRefreshControl.h"
#import "StatusBar.h"
#import "TestViewController.h"

extern NSDictionary * ApiMap;
extern NSString * SocketMap;

@interface EnvironmentView ()
@property(nonatomic,strong)  UISegmentedControl *segment;
@property(nonatomic,strong)  UISegmentedControl *segmentSoket;
@property(nonatomic,strong)  UISegmentedControl *segmentHttp;
@property(nonatomic,strong) UIButton *showButton;

@end
@implementation EnvironmentView

static  int sgmentSelect;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self ) {
        
        [self createView];
    }
    
    return self;
}
-(void)createView{

    NSArray *segmentItem = @[@"线上",@"测试"];
    //显示进入app是当前的环境为正式还是测试
    sgmentSelect = [[StatusBar sharedInstance] getEnvironmentType] == HekrEnvironmentTypeTest?1:0;
    _segment = [self addSegmentWithArray:segmentItem frame:CGRectMake(10, 5, self.frame.size.width - 20, 25) selectedSegmentIndex:sgmentSelect action:@selector(changeEnvironment:)];
    
    _segment.tag = 1001;
    [self addSubview:_segment];
    
    NSArray *segmentItemSocket = @[@"socket线上",@"socket测试"];
    _segmentSoket = [self addSegmentWithArray:segmentItemSocket frame:CGRectMake(10, 40, self.frame.size.width - 20, 25) selectedSegmentIndex:sgmentSelect action:@selector(changeEnvironment:)];
    _segmentSoket.tag = 1002;
    [self addSubview:_segmentSoket];
    
    _showButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 75, (self.frame.size.width - 20)/2, 25)];
    [_showButton addTarget:self action:@selector(showSendTestData:) forControlEvents:UIControlEventTouchUpInside];
    _showButton.backgroundColor = [UIColor whiteColor];
    [_showButton setTitle:@"发送测试数据" forState:UIControlStateNormal];
    [_showButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _showButton.layer.cornerRadius = 5;
    _showButton.layer.borderWidth = 1;
    _showButton.layer.borderColor = [UIColor blueColor].CGColor;
    [self addSubview:_showButton];

//
//    NSArray *segmentItemHttp = @[@"不加密",@"加密"];
//    _segmentHttp = [self addSegmentWithArray:segmentItemHttp frame:CGRectMake(10, 70, self.frame.size.width - 20, 25) selectedSegmentIndex:sgmentSelectHttp action:@selector(changeEnvironment:)];
//    _segmentHttp.tag = 1003;
//    [self addSubview:_segmentHttp];
    
    
}

- (UISegmentedControl *)addSegmentWithArray:(NSArray *)segmentArray  frame:(CGRect)frame selectedSegmentIndex:(NSInteger )Index action:(SEL)action
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    
    segment.frame = frame;
    
    segment.selectedSegmentIndex = Index;
    
    [segment addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    return segment;
}
-(void)changeEnvironment:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex == 1 ) {
        ApiMap = @{@"user.openapi.hekr.me":@"http://test-user-openapi.hekr.me",@"uaa.openapi.hekr.me":@"http://test-uaa-openapi.hekr.me",@"console.openapi.hekr.me":@"http://test-console-openapi.hekr.me"};
        SocketMap = @"wss://test-asia-dev.hekr.me:186";
        sgmentSelect = 1;
        DDLogVerbose(@"切换为测试模式");
        
    }else{
        
        ApiMap = @{@"user.openapi.hekr.me":@"https://user-openapi.hekr.me",@"uaa.openapi.hekr.me":@"https://uaa-openapi.hekr.me",@"console.openapi.hekr.me":@"https://console-openapi.hekr.me"};
        SocketMap = @"wss://asia-app.hekr.me:186";
         sgmentSelect = 0;
        DDLogVerbose(@"切换为线上模式");
    }
    _segment.selectedSegmentIndex = sgmentSelect;
    _segmentSoket.selectedSegmentIndex = sgmentSelect;
    [[StatusBar sharedInstance] setEnvironmentType:sgmentSelect==1?HekrEnvironmentTypeTest:HekrEnvironmentTypeFormal];
    [[Hekr sharedInstance] logout];
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"clearData" object:nil]];
    [self.superview removeFromSuperview];
}

-(void)showSendTestData:(id)sender{
    [self.superview removeFromSuperview];
    
    id result = [self getCurrentVC];
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [result topViewController];
    }
    UIViewController *resultVC = (UIViewController *)result;
    if ([resultVC isKindOfClass:[TestViewController class]]) {
        return;
    }
    UIStoryboard *addDeviceStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TestViewController *testVC = [addDeviceStoryBoard instantiateViewControllerWithIdentifier:@"SendTestVC"];
    [resultVC.navigationController pushViewController:testVC animated:YES];
}

//获取当前屏幕显示的viewcontroller
- (id)getCurrentVC
{
    id result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController ;
        
    }
    return result;
}

@end
