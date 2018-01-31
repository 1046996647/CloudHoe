//
//  EmptyDeviceView.m
//  HekrSDKAPP
//
//  Created by Info on 16/2/26.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "EmptyDeviceView.h"
#import "FXBlurView.h"
#import <HekrAPI.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#define DevViewHeight 125.f

@interface EmptyDeviceView()

@property (nonatomic,strong) UIView *airClearView;
@property (nonatomic,strong) UIView *lampView;
@property (nonatomic,strong) UIView *curtainView;

@property (nonatomic,strong) FXBlurView *tintView;

@property (nonatomic,strong) UIView *div1;
@property (nonatomic,strong) UIView *div2;
@property (nonatomic,strong) UIView *div3;

@end

@implementation EmptyDeviceView
{
    NSArray *_dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat width = self.bounds.size.width;
        CGFloat height = self.bounds.size.height;
        
        UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 20)];
        titLabel.text = NSLocalizedString(@"体验智能设备",nil);
        titLabel.textColor = [UIColor whiteColor];
        titLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titLabel];
        
        //提示
        NSString *tintStr = NSLocalizedString(@"您也可以点击右上角的+添加新设备", nil) ;
        CGSize tintStrSize = [tintStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
        _tintView = [[FXBlurView alloc] init];
        _tintView.frame = CGRectMake((width - ceilf(tintStrSize.width)-40) / 2, 165+(height - 195) / 2, ceilf(tintStrSize.width)+40, 30);
        _tintView.tintColor = [UIColor clearColor];
//        _tintView.alpha = 0.3;
        _tintView.layer.cornerRadius = 15;
        [self addSubview:_tintView];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tintView.frame.size.width, _tintView.frame.size.height)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.alpha = 0.1;
        [_tintView addSubview:bgView];
        
        UILabel *tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 7.5, _tintView.frame.size.width, 15)];
        tintLabel.text = tintStr;
        tintLabel.font = [UIFont systemFontOfSize:13.0];
        tintLabel.textColor = [UIColor whiteColor];
        tintLabel.textAlignment = NSTextAlignmentCenter;
        [_tintView addSubview:tintLabel];
        [self getDataFromUrl];
    }
    return self;
}

- (void)getDataFromUrl{
//    HekrUserToken *token = [Hekr sharedInstance].user;
    if (![Hekr sharedInstance].user) {
        return;
    }
    AFHTTPSessionManager *manager = [[Hekr sharedInstance] sessionWithDefaultAuthorization];
    [manager GET:@"https://console-openapi.hekr.me/external/device/default/static" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[获取体验设备]：%@",responseObject);
        _dataArray = responseObject;
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"kHekrStaticDevice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self updateStaticDevicesView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ((_dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHekrStaticDevice"])) {
            [self updateStaticDevicesView];
        }
        
    }];
}

- (void)updateStaticDevicesView{
    if (_dataArray.count >= 1) {
        if (_airClearView != nil) {
            _airClearView = nil;
            [_airClearView removeFromSuperview];
        }

        _airClearView = [self createView:_dataArray[0][@"logo"] name:NSLocalizedString(_dataArray[0][@"name"],nil) devType:DeviceTypeAirClear];
        [self addSubview:_airClearView];
    }
    if (_dataArray.count >= 2) {
        if (_lampView != nil) {
            _lampView = nil;
            [_lampView removeFromSuperview];
        }
        _lampView = [self createView:_dataArray[1][@"logo"] name:NSLocalizedString(_dataArray[1][@"name"],nil) devType:DeviceTypeLamp];
        [self addSubview:_lampView];
    }
    if (_dataArray.count >= 3) {
        if (_curtainView != nil) {
            _curtainView = nil;
            [_curtainView removeFromSuperview];
        }
        _curtainView = [self createView:_dataArray[2][@"logo"] name:NSLocalizedString(_dataArray[2][@"name"],nil) devType:DeviceTypeCurtain];
        [self addSubview:_curtainView];
    }
}

- (UIView *)createView:(NSString *)imgStr name:(NSString *)nameStr devType:(DeviceType)devType
{
    CGFloat width = self.bounds.size.width / 3;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, width-10, width-10)];
    bgView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    bgView.alpha = 0.1;
    bgView.layer.cornerRadius = 10;
    [view addSubview:bgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, width);
    btn.tag = devType;
    [btn addTarget:self action:@selector(addNewDevice:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    CGSize imgSize = CGSizeMake((120/1334.0)*[[UIScreen mainScreen] bounds].size.height, (120/1334.0)*[[UIScreen mainScreen] bounds].size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-imgSize.width)/2, (DevViewHeight-imgSize.height-20)/2-7, imgSize.width, imgSize.height)];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
//    imageView.image = [UIImage imageNamed:imgStr];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"icon-device_default"]];
    [view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(bgView.frame)-27, width - 10, 15)];
    nameLabel.text = nameStr;
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    nameLabel.layer.shadowOffset = CGSizeMake(1,1.5);
    nameLabel.layer.shadowOpacity = 0.2;
    nameLabel.layer.shadowRadius = 1.0;
    [view addSubview:nameLabel];
    
    
    return view;
}

- (void)addNewDevice:(UIButton *)btn{

    NSInteger count = btn.tag;
    switch (count) {
        case 124:
            [self.delegate addEmptyDevice:_dataArray[0][@"iosH5Page"]];
            break;
        case 125:
            [self.delegate addEmptyDevice:_dataArray[1][@"iosH5Page"]];
            break;
        case 126:
            [self.delegate addEmptyDevice:_dataArray[2][@"iosH5Page"]];
            break;
            
        default:
            break;
    }
    
    
    
}

- (void)viewLoad{
    if (_airClearView == nil) {
        [self getDataFromUrl];
    }

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    
    _airClearView.frame = CGRectMake(0, 40, width / 3, DevViewHeight);
    _lampView.frame = CGRectMake(width / 3, 40, width / 3, DevViewHeight);
    _curtainView.frame = CGRectMake((width / 3)*2, 40, width/3, DevViewHeight);
    
//    _div1.frame = CGRectMake(0, 40, width, 0.5);
//    _div2.frame = CGRectMake(width/2, 40, 0.5, DevViewHeight);
//    _div3.frame = CGRectMake(0, 165, width, 0.5);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
