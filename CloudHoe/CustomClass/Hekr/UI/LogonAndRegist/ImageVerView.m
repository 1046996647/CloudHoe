//
//  ImageVerView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/8/9.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ImageVerView.h"
#import "Tool.h"
#import "HekrAPI.h"
#import <UIButton+WebCache.h>
#import "GiFHUD.h"

#define SIZE self.frame.size

@interface ImageVerView ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *imageVer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UIButton *send;
@property (nonatomic, copy) NSString *captchaToken;
@property (nonatomic, copy) NSString *rid;



@end

@implementation ImageVerView

- (void)awakeFromNib{
    [super awakeFromNib];
    [GiFHUD setGifWithImageName:@"loading@3x.gif"];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _mainView.layer.cornerRadius = 10;
    _mainTitle.text = NSLocalizedString(@"输入图形验证码", nil);
    _subTitle.text = NSLocalizedString(@"获取校验短信", nil);
    [_cancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [_cancel setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_send setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
    [_send setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    [_activity setHidesWhenStopped:YES];
    [self showImageVer];
    [_textField becomeFirstResponder];
}

- (void)showImageVer{
    [_imageVer setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
    [_activity startAnimating];
    _rid = [self getRid];
    [_imageVer sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://uaa.openapi.hekr.me/images/getImgCaptcha?rid=%@",_rid]] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_activity stopAnimating];
        if (error) {
            [_imageVer setTitle:NSLocalizedString(@"点击重试", nil) forState:UIControlStateNormal];
        }
    }];
}

- (IBAction)getImageVer:(UIButton *)sender {
    [self showImageVer];
}

- (IBAction)sendAction:(UIButton *)sender {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    NSDictionary *dic = @{@"rid":_rid,
                          @"code":_textField.text};
    [[[Hekr sharedInstance] sessionWithDefaultAuthorization] POST:@"http://uaa.openapi.hekr.me/images/checkCaptcha" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DDLogInfo(@"[校验图形验证码]：%@",responseObject);
        [GiFHUD showWithOverlay];

        _captchaToken = responseObject[@"captchaToken"];
        [self performSelector:@selector(perSend) withObject:nil afterDelay:1.0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _subTitle.text = NSLocalizedString(@"输入错误，请重新输入", nil);
        _subTitle.textColor = [UIColor redColor];
        [self showImageVer];
        _textField.text = @"";
    }];
    
}

- (void)perSend{
    [GiFHUD dismiss];
    [self.delegate getSMS:_captchaToken];
    [self removeFromSuperview];
}

- (IBAction)imgCancelAction:(UIButton *)sender {
    [self removeFromSuperview];
    
}

//随机rid
- (NSString *)getRid{
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 3; i++) {
        NSInteger arc = (arc4random() % 100000) + 1000000;
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)arc]];
    }
    
    NSString *rid = [arr componentsJoinedByString:@"hekr"];
    return rid;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
