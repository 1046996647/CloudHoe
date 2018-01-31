//
//  ConfigNet.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ConfigNet.h"
#import "EasyMacro.h"
#import "Tool.h"
#import "UIImageView+ThemeColor.h"

//#define WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define HEIGHT                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*WIDTH
//#define Vrange(x)  (x/1334.0)*HEIGHT

@interface ConfigNet ()
@property (weak, nonatomic) IBOutlet UIImageView *configImage;
@property (weak, nonatomic) IBOutlet UILabel *configNetClass;
@property (weak, nonatomic) IBOutlet UILabel *configNetNode;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ConfigNet

+(ConfigNet *)instanceConfigNetWitch:(NSString *)configImage configNetClassText:(NSString *)configNetClassText configNetClassTextColor:(UIColor *)configNetClassTextColor configNetNodeText:(NSString *)configNetNodeText configNetNodeTextColor:(UIColor *)configNetNodeTextColor{
    UIFont *font1;
    UIFont *font2;
    if (ScreenHeight >= 736) {
        font1 = [UIFont systemFontOfSize:20];
        font2 = [UIFont systemFontOfSize:15];
    }else if (ScreenHeight >= 667){
        font1 = [UIFont systemFontOfSize:18];
        font2 = [UIFont systemFontOfSize:14];
    }else if (ScreenHeight >= 568){
        font1 = [UIFont systemFontOfSize:16];
        font2 = [UIFont systemFontOfSize:13];
    }else if (ScreenHeight >= 480){
        font1 = [UIFont systemFontOfSize:14];
        font2 = [UIFont systemFontOfSize:12];
    }
    
    ConfigNet *cv = [[UINib nibWithNibName:@"ConfigNet" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    
    cv.configImage.image = [UIImage imageNamed:configImage];
    
    cv.configNetClass.text = NSLocalizedString(configNetClassText, nil);
    cv.configNetClass.textColor =configNetClassTextColor;
    cv.configNetClass.font = font1;
    cv.configNetNode.text =NSLocalizedString(configNetNodeText, nil);
    cv.configNetNode.numberOfLines = 0;
    cv.configNetNode.textColor =configNetNodeTextColor;
    cv.configNetNode.font = font2;
   
    cv.bgView.layer.cornerRadius = 10.0f;
    cv.bgView.layer.masksToBounds = YES;
    cv.bgView.layer.shadowColor = UIColorFromHex(0x000000).CGColor;
    cv.bgView.layer.shadowOffset = CGSizeMake(8,8);
    cv.bgView.layer.shadowOpacity = 0.3;
    cv.bgView.layer.shadowRadius = 10;
    cv.bgView.backgroundColor = [UIColor whiteColor];

    cv.backgroundColor = [UIColor clearColor];
    
    return cv;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = getCellBackgroundColor();
    }
    return self;
}
@end
