//
//  HomeDeviceCells.m
//  HekrSDKAPP
//
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "HomeDeviceCells.h"
#import "DevicesModel.h"
#import <HekrSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Tool.h"
#import "UIColor+YYAdd.h"

@interface CircleView : UIView
@end
@implementation CircleView
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.layer.cornerRadius = CGRectGetWidth(frame) / 2.0;
}
@end

@implementation DeviceCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _imgBgView.layer.borderWidth = 2;
    
    
    
}

-(void) update:(HekrDevice*)data isHekrGroup:(BOOL)isHekrgroup GroupName:(NSString *)groupName{
    _imgBgView.layer.cornerRadius = _imgBgView.frame.size.height/2;
    [self.image sd_setImageWithURL:[NSURL URLWithString:[data.props objectForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"icon-device_default"]];
    NSString * name = nil;
    if (isHekrgroup == YES) {
        name = groupName;
    }else{
        name = [data.props objectForKey:@"name"];
    }
    
    if (name.length <= 0) {
//        NSString * key = [lang() isEqualToString:@"zh-CN"] ? @"name" : @"ename";
        name = [[[data.props objectForKey:@"cidName"] componentsSeparatedByString:@"/"] lastObject];
    }
    self.name.text = name;
        
    if (data.online == YES) {
        self.image.alpha = 1;
        self.offLine.hidden = YES;
        _imgBgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _name.textColor = [UIColor whiteColor];
    }else{
        self.image.alpha = 0.8;
        self.offLine.hidden = NO;
        _imgBgView.layer.borderColor = [[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0] CGColor];
        _name.textColor = [UIColor grayColor];
    }
    
//    NSDictionary * state = [data.infos objectForKey:@"state"];
//    if (![state isKindOfClass:[NSDictionary class]]) {
//        state = nil;
//    }
//    BOOL power = [[state objectForKey:@"power"] boolValue];
//
//    if (![data.UID isEqualToString:[[[Hekr sharedInstance] user] uid]]) {
//        self.share.image = [UIImage imageNamed:@"icon-share2"];
//    }else if([[data.infos objectForKey:@"isGranted"] boolValue]){
//        self.share.image = [UIImage imageNamed:@"icon-share"];
//    }else{
//        self.share.image = nil;
//    }
//    
//    NSString * curv = [[data.infos objectForKey:@"detail"] objectForKey:@"ver"];
//    NSString * lv = [data.infos objectForKey:@"binVersion"];
//    self.update.hidden = (lv && ![lv isEqualToString:curv]);
//    
//    NSString * power_name = data.online ? (power ? @"icon_on" : @"icon_off") : @"icon_offline";
//    NSString * power_text = data.online ? (power ? NSLocalizedString(@"开",nil) : NSLocalizedString(@"关",nil)) : NSLocalizedString(@"离线",nil);
//    self.powerText.textColor = data.online ? [UIColor whiteColor] : [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
//    self.powerText.text = power_text;
//    self.power.image = [UIImage imageNamed:power_name];
//    
//    BOOL showTimer = [[data.infos objectForKey:@"schedulerRuleTag"] boolValue];
//    self.timer.image = showTimer?[UIImage imageNamed:@"icon-time"] : nil;
//    self.fix.constant = showTimer ? 8 : 0;
}
@end

@implementation GroupCell
-(void) awakeFromNib{
    [super awakeFromNib];
    self.border.layer.borderColor = [[UIColor clearColor] CGColor];
    self.border.layer.borderWidth = 1;
    self.border.layer.cornerRadius = 5;
    self.border.layer.masksToBounds = YES;
    
//    self.countBorder.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.countBorder.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.25];
//    self.countBorder.layer.borderWidth = 1;
    self.countBorder.layer.cornerRadius = 5;
    self.countBorder.layer.masksToBounds = YES;
}
-(void) update:(HekrFold*)data isHekrGroup:(BOOL)isHekrgroup GroupName:(NSString *)groupName{
    self.name.text = data.name;
    self.name.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    self.name.layer.shadowOffset = CGSizeMake(1,1.5);
    self.name.layer.shadowOpacity = 0.2;
    self.name.layer.shadowRadius = 1.0;
    self.count.text = [@(data.count) description];
}
@end

@implementation HDeviceLineView
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    return self;
}
@end
@implementation VDeviceLineView
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    return self;
}
@end

@interface DeviceStatisticsView ()
@property (nonatomic,weak) IBOutlet UILabel * count;
@property (nonatomic,weak) IBOutlet UILabel * online;


@end

@implementation DeviceStatisticsView
-(instancetype) init{
    self = [super init];
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    return self;
}
-(void) setN_count:(NSUInteger)n_count{
    _n_count = n_count;
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"离线 %@ 台",nil),[@(n_count) description]];
    self.count.text = str;
}
-(void) setN_online:(NSUInteger)n_online{
    _n_online = n_online;
    NSString *str = [NSString stringWithFormat:NSLocalizedString(@"在线 %@ 台",nil),[@(n_online) description]];
    self.online.text  =str;
}

@end

@implementation NameEditView

@end
