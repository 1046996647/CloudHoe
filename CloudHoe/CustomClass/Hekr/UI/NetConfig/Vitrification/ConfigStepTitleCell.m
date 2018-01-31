//
//  ConfigStepTitleCell.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigStepTitleCell.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>
#import "ConfigDevModel.h"
#import "UIImageView+ThemeColor.h"
#import "SectorImageView.h"
#import "ConfigDevModel.h"

@interface ConfigStepTitleCell ()

@property (nonatomic ,weak) IBOutlet UIImageView *showImageView;
@property (nonatomic ,weak) IBOutlet UIImageView *devImageView;
@property (nonatomic ,weak) IBOutlet UIImageView *stateImageView;
@property (nonatomic ,weak) IBOutlet UILabel *stepLabel;
@property (nonatomic ,strong) SectorImageView *stepImageView;

@end

@implementation ConfigStepTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_showImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _showImageView.contentMode =  UIViewContentModeScaleAspectFit;
    _stateImageView.layer.cornerRadius = Hrange(25);
    
    _stepImageView = [[SectorImageView alloc] initWithFrame:CGRectMake(0, 0, Hrange(50), Hrange(50))];
    [_stateImageView addSubview:_stepImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setConfigStepWithStep:(ConfigDeviceStep )step state:(BOOL)state device:(NSDictionary *)device show:(BOOL)show{
    
    _showImageView.image = show?[UIImage imageNamed:@"ic_pullup"]:[UIImage imageNamed:@"ic_dropdown"];
    _devImageView.hidden = YES;
    _stepImageView.hidden = NO;
    
    _stateImageView.image = nil;
    _stateImageView.backgroundColor = [UIColor clearColor];

    if (!state&&step!=ConfigDeviceStepFinish) {
        _stepImageView.hidden = YES;
        _stateImageView.image = [UIImage imageNamed:@"ic_dev_fail"];
        _stepLabel.text = NSLocalizedString(@"设备连接失败", nil);
        return;
    }
//    if (_stepImageView==nil) {
//        _stepImageView = [[SectorImageView alloc] initWithFrame:CGRectMake(0, 0, Hrange(50), Hrange(50)) step:step];
//        [_stateImageView addSubview:_stepImageView];
//    }
//    [_stepImageView setStrokeStep:step];
    [_stepImageView setSectorStep:step];
    
    switch (step) {
        case ConfigDeviceStepFirst:{
            _stepLabel.text = NSLocalizedString(@"1. 获取配网安全码", nil);
        }
            break;
        case ConfigDeviceStepSecond:{
            _stepLabel.text = NSLocalizedString(@"2. 设备连接路由器", nil);
        }
            break;
        case ConfigDeviceStepThird:{
            _stepLabel.text = NSLocalizedString(@"3. 云端验证设备信息", nil);
        }
            break;
        case ConfigDeviceStepFourth:{
            _stepLabel.text = NSLocalizedString(@"4. 设备登陆云端", nil);
        }
            break;
        case ConfigDeviceStepFinish:{
            if (!device[@"logo"]) {
                _stateImageView.image = [UIImage imageNamed:@"ic_dev_fail"];
            }else{
                _devImageView.hidden = NO;
                [_devImageView sd_setImageWithURL:[NSURL URLWithString:device[@"logo"]] completed:nil];
            }
            _stepImageView.hidden = YES;

            if (![device[@"bindResultCode"] boolValue]) {
                _stateImageView.backgroundColor = getButtonBackgroundColor();
                _stepLabel.text = [NSString stringWithFormat:@"%@%@",device[@"name"],NSLocalizedString(@"连接成功", nil)];
            }else{
                if (device[@"bindResultMsg"]) {
                    NSString *str = [[device[@"bindResultMsg"] componentsSeparatedByString:@":"] firstObject];
                    if ([str isEqualToString:@"E004"]){
                        _stepLabel.text = [NSString stringWithFormat:@"%@%@",device[@"name"],NSLocalizedString(@"连接成功", nil)];
                        _stateImageView.backgroundColor = getButtonBackgroundColor();
                        return;
                    }
                }
//                _stepLabel.text = [NSString stringWithFormat:@"%@%@",device[@"name"],NSLocalizedString(@"连接失败", nil)];
                _stepLabel.text = [NSString stringWithFormat:@"%@",[ConfigDevModel devFailReason:device comeType:YES]];
                _stateImageView.backgroundColor = UIColorFromHex(0xcccccc);
            }
        }
            break;
        default:
            break;
    }
    
}

@end
