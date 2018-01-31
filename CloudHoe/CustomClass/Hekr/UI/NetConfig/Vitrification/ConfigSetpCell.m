//
//  ConfigSetpCell.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/1.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigSetpCell.h"
#import "Tool.h"
#import "UIImageView+ThemeColor.h"

@interface ConfigSetpCell ()

@property (nonatomic ,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic ,weak) IBOutlet UIImageView *stateImageView;
@property (nonatomic ,weak) IBOutlet UIImageView *failImageView;
@property (nonatomic ,weak) IBOutlet UIActivityIndicatorView *stepActivity;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleLeadContraint;

@end

@implementation ConfigSetpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setConfigStep:(ConfigDeviceStep )step state:(NSInteger )state{
    
    _failImageView.hidden = YES;
    _titleLabel.textColor = UIColorFromHex(0x666666);

    switch (state) {
        case 0:{
            _stepActivity.hidden = YES;
            [_stepActivity stopAnimating];

            _failImageView.hidden = NO;
            
            _stateImageView.image = [UIImage imageNamed:@"ic_fail"];
            _stateImageView.hidden = NO;
            
            _titleLabel.textColor = UIColorFromHex(0xfe3824);
            _titleLeadContraint.constant = Hrange(100);
        }
            break;
        case 1:{
            _stepActivity.hidden = YES;
            [_stepActivity stopAnimating];
            
            [_stateImageView setThemeImageNamed:@"ic_success"];
            
            _stateImageView.hidden = NO;
        }
            break;
        case 2:{
            _stateImageView.hidden = YES;
            
            _stepActivity.hidden = NO;
            [_stepActivity startAnimating];
        }
            break;
        case 3:{
            _stateImageView.hidden = YES;
            
            _stepActivity.hidden = YES;
            [_stepActivity stopAnimating];
        }
            break;
        default:
            break;
    }
    
    switch (step) {
        case ConfigDeviceStepFirst:{
            _titleLabel.text = NSLocalizedString(@"1. 获取配网安全码", nil);
        }
            break;
        case ConfigDeviceStepSecond:{
            _titleLabel.text = NSLocalizedString(@"2. 设备连接路由器", nil);
        }
            break;
        case ConfigDeviceStepThird:{
            _titleLabel.text = NSLocalizedString(@"3. 云端验证设备信息", nil);
        }
            break;
        case ConfigDeviceStepFourth:{
            _titleLabel.text = NSLocalizedString(@"4. 设备登陆云端", nil);
        }
            break;
        case ConfigDeviceStepFinish:{
            _titleLabel.text = NSLocalizedString(@"5. 设备绑定成功", nil);
        }
            break;
        default:
            break;
    }
    
}


@end
