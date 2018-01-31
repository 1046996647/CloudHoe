//
//  SocialView.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/6/13.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SocialView.h"
#import <WeixinSDK/WXApi.h>
#import "Tool.h"
#import <HekrAPI.h>

@interface SocialView ()
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *wbBtn;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *twBtn;
@property (weak, nonatomic) IBOutlet UIButton *googleBtn;

@end

@implementation SocialView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.socialLable.text =  NSLocalizedString(@"社交账号登录",nil);
    self.socialLable.textColor = UIColorFromHex(0xc0c0c0);
    [_qqBtn setImage:[[UIImage imageNamed:@"ic_sso_qq_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_wechat setImage:[[UIImage imageNamed:@"ic_sso_wx_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_wbBtn setImage:[[UIImage imageNamed:@"ic_sso_wb_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_fbBtn setImage:[[UIImage imageNamed:@"ic_sso_fb_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_twBtn setImage:[[UIImage imageNamed:@"ic_sso_tw_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_googleBtn setImage:[[UIImage imageNamed:@"ic_sso_go_nom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    NSDictionary *socialData = [Tool getProfileJsonData];
    
    _wbBtn.hidden = ![[socialData objectForKey:KeyOfSocialWeibo] boolValue];
    _qqBtn.hidden = ![[socialData objectForKey:KeyOfSocialQQ] boolValue];
    _wechat.hidden = ![[socialData objectForKey:KeyOfSocialWeixin] boolValue];
    _googleBtn.hidden = ![[socialData objectForKey:KeyOfSocialGoogle] boolValue];
    _fbBtn.hidden = ![[socialData objectForKey:KeyOfSocialFacebook] boolValue];
    _twBtn.hidden = ![[socialData objectForKey:KeyOfSocialTwitter] boolValue];
    
    if ([WXApi isWXAppInstalled]) {
        _wechat.hidden = _wechat.hidden?:NO;
    }else{
        _wechat.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}
- (IBAction)sdf:(id)sender {
    if ([_delegate respondsToSelector:@selector(socialLoginAction:)]) {
              [self.delegate socialLoginAction:sender];
    }
}

@end
