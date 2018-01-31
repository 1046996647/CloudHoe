//
//  DevCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/5/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DevCell.h"
#import <UIImageView+WebCache.h>
#import "EasyMacro.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define HEIGHT                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*WIDTH
//#define Vrange(x)  (x/1334.0)*HEIGHT
@implementation DevCell
{
    UIView *_imgNameView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imgNameView = [UIView new];
        [self.contentView addSubview:_imgNameView];
        _imgBgView = [UIView new];
        _imgBgView.layer.borderWidth = 1;
        _imgBgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_imgNameView addSubview:_imgBgView];
        _img = [UIImageView new];
        [_imgBgView addSubview:_img];
        _devDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [_devDelete setImage:[UIImage imageNamed:@"ic_devdelete"] forState:UIControlStateNormal];
        _devDelete.hidden = YES;
        [_devDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_devDelete];
        _name = [UILabel new];
        _name.textColor = [UIColor whiteColor];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.font = [UIFont systemFontOfSize:14];
        _name.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
        _name.layer.shadowOffset = CGSizeMake(1,1.5);
        _name.layer.shadowOpacity = 0.2;
        _name.layer.shadowRadius = 1.0;
        [_imgNameView addSubview:_name];
        _online = [UILabel new];
        _online.text = NSLocalizedString(@"离线", nil);
        _online.textAlignment = NSTextAlignmentRight;
        _online.textColor = rgb(255, 255, 255);
        _online.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_online];
        _hekrGroup = [UIImageView new];
        _hekrGroup.image = [UIImage imageNamed:@"aut-numbers"];
        [self.contentView addSubview:_hekrGroup];
        _hekrGroupNum = [UILabel new];
        _hekrGroupNum.textAlignment = NSTextAlignmentCenter;
        _hekrGroupNum.font = [UIFont systemFontOfSize:10];
        _hekrGroupNum.textColor = [UIColor whiteColor];
        _hekrGroupNum.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
        _hekrGroupNum.layer.shadowOffset = CGSizeMake(1,1.5);
        _hekrGroupNum.layer.shadowOpacity = 0.2;
        _hekrGroupNum.layer.shadowRadius = 1.0;
        [_hekrGroup addSubview:_hekrGroupNum];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.contentView.frame.size;
    
    _imgNameView.frame = CGRectMake(0, 0, size.width, size.width/3+4+20);
    _imgNameView.center = self.contentView.center;
    
    _imgBgView.frame = CGRectMake(0, 0, self.contentView.frame.size.width/3, self.contentView.frame.size.width/3);
    _imgBgView.center = CGPointMake(_imgNameView.frame.size.width/2, _imgBgView.frame.size.height/2);
    _imgBgView.layer.cornerRadius = _imgBgView.frame.size.width/2;
    
    _img.frame = CGRectMake(0, 0, _imgBgView.frame.size.width*0.6, _imgBgView.frame.size.width*0.6);
    _img.center = CGPointMake(_imgBgView.frame.size.width/2, _imgBgView.frame.size.width/2);
    
    _name.frame = CGRectMake(0, _imgNameView.frame.size.height-20, size.width, 20);
    
    _online.frame = CGRectMake(4 , size.height-20, size.width-8, 16);
    
    _hekrGroup.frame = CGRectMake(0, 0, _imgBgView.frame.size.width*0.8, 15);
    _hekrGroup.center = CGPointMake(size.width/2, _online.center.y);
    CGSize numSize = [self sizeWithText:@"10" maxSize:CGSizeMake(CGFLOAT_MAX, 15) font:[UIFont systemFontOfSize:13]];
    _hekrGroupNum.frame = CGRectMake(CGRectGetWidth(_hekrGroup.frame)-numSize.width, 0, numSize.width, 15);
    
    _devDelete.frame = CGRectMake(0, 0, 45, 45);
    [_devDelete setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 5, 5)];
    
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}


-(void) update:(HekrDevice*)data isHekrGroup:(BOOL)isHekrgroup GroupName:(NSString *)groupName lanDevices:(NSArray *)lanDevices{
    [_img sd_setImageWithURL:[NSURL URLWithString:[data.props objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"icon-device_default"]];
    NSString * name = nil;
    if (isHekrgroup == YES) {
        name = groupName;
    }else{
        name = [data.props objectForKey:@"name"];
    }
    
    if (name.length <= 0) {
        name = isEN() == YES ? data.props[@"productName"][@"en_US"] : data.props[@"productName"][@"zh_CN"];
        if (name.length <= 0) {
            name = isEN() == YES ? [[data.props[@"categoryName"][@"en_US"] componentsSeparatedByString:@"/"] lastObject] : [[data.props[@"categoryName"][@"zh_CN"] componentsSeparatedByString:@"/"] lastObject];
        }
    }
    self.name.text = name;
    if ([[Hekr sharedInstance] getLocalControl]==HekrLocalControlOn) {
        [self setDeviceState:[lanDevices containsObject:data.tid]];
        return;
    }
    [self setDeviceState:data.online];
}

-(void)setDeviceState:(BOOL)state{
    if (state) {
        _img.alpha = 1.0;
        _online.alpha = 1.0;
        _imgBgView.alpha = 1.0;
        _name.alpha = 1.0;
        _online.text = NSLocalizedString(@"在线", nil);
//        _imgBgView.backgroundColor = getDevOnlineColor();
    }else{
        _img.alpha = 0.7;
        _online.alpha = 0.7;
        _imgBgView.alpha = 0.7;
        _name.alpha = 0.7;
        _online.text = NSLocalizedString(@"离线", nil);
//        _imgBgView.backgroundColor = getDevOfflineColor();
    }
}

- (void)deleteAction:(UIButton *)btn{
    [self.delegate deleteDev:btn];
}


@end
