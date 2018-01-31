//
//  DeviceManageCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/30.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DeviceManageCell.h"
#import "DevicesModel.h"
#import <UIImageView+WebCache.h>
#import <HekrAPI.h>
#import "Tool.h"

//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@implementation DeviceManageCell
{
    UIView *_bgView;
    UIImageView *_img;
    UILabel *_name;
    UILabel *_type;
    UILabel *_onLine;
    UILabel *_downLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = Hrange(100)/2;
        [self.contentView addSubview:_bgView];
        _img = [UIImageView new];
        [self.contentView addSubview:_img];
        _name = [UILabel new];
        _name.textColor = rgb(80, 80, 82);
        _name.font = getListTitleFont();
//        _name.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_name];
        _type = [UILabel new];
        _type.textColor = rgb(148, 148, 148);
        _type.font = getListTitleFont();
        [self.contentView addSubview:_type];
        _onLine = [UILabel new];
        _onLine.textColor = rgb(148, 148, 148);
        _onLine.font = getDescTitleFont();
        _onLine.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_onLine];
        
        _downLabel = [UILabel new];
        _downLabel.backgroundColor = getCellLineColor();
        _downLabel.alpha = 0.5;
        [self.contentView addSubview:_downLabel];
        
//        _bgView.backgroundColor = rgb(245, 103, 53);
//        _img.backgroundColor = [UIColor whiteColor];
//        _name.backgroundColor = rgb(80, 80, 82);
//        _type.backgroundColor = rgb(148, 148, 148);
//        _onLine.backgroundColor = rgb(148, 148, 148);
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _bgView.frame = CGRectMake(Hrange(30), (self.contentView.frame.size.height-Hrange(100))/2, Hrange(100), Hrange(100));
    _img.frame = CGRectMake(0, 0, Hrange(50), Hrange(50));
    _img.center = _bgView.center;
    _name.frame = CGRectMake(Hrange(150), self.contentView.frame.size.height/2-Vrange(10)-16, 180, 16);
    _type.frame = CGRectMake(Hrange(150), self.contentView.frame.size.height/2+Vrange(10), 200, 16);
    _onLine.frame = CGRectMake(self.contentView.frame.size.width-45, self.contentView.frame.size.height/2-8, 45, 16);
    _downLabel.frame = CGRectMake(0, self.contentView.frame.size.height-1, ScreenWidth, 1);
}

- (void)updata:(id )data lanDevices:(NSArray *)lanDevices{
    HekrDevice *dev = data;

    _name.text = dev.props[@"name"];
    _type.text = isEN() == YES ? dev.props[@"categoryName"][@"en_US"] : dev.props[@"categoryName"][@"zh_CN"];
    
    [_img sd_setImageWithURL:[NSURL URLWithString:dev.props[@"logo"]] placeholderImage:[UIImage imageNamed:@"icon-device_default"]];
    
    if ([[Hekr sharedInstance] getLocalControl]==HekrLocalControlOn) {
        if ([lanDevices containsObject:dev.tid]) {
            _onLine.text = NSLocalizedString(@"在线", nil);
            _bgView.backgroundColor = getButtonBackgroundColor();
        }
        else{
            _onLine.text = NSLocalizedString(@"离线", nil);
            _bgView.backgroundColor = rgb(200, 200, 200);
        }
        return;
    }
    if (dev.online == YES) {
        _onLine.text = NSLocalizedString(@"在线", nil);
        _bgView.backgroundColor = getButtonBackgroundColor();
    }else{
        _onLine.text = NSLocalizedString(@"离线", nil);
        _bgView.backgroundColor = rgb(200, 200, 200);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
