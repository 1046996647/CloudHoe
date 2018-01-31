//
//  AuthorizationView.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "AuthorizationView.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>

@interface AuthorizationView ()
@property (nonatomic, weak)id info;
@property (nonatomic, copy)void (^block)(BOOL isTure);
@property (nonatomic, copy)AuBlock auBlock;
@end

@implementation AuthorizationView

- (instancetype)initWithFrame:(CGRect)frame Data:(id)info Block:(void (^)(BOOL))block{
    self = [super initWithFrame:frame];
    if (self) {
        _info = info;
        _block = block;
        [self createViews];
    }
    return self;
}

- (void)createViews{
    NSString * devName = [_info objectForKey:@"deviceName"];
    NSString * userName = [_info objectForKey:@"granteeName"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self addSubview:bgView];
    
    UIView *auView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Hrange(600), Vrange(324))];
    auView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2-StatusBarAndNavBarHeight);
    auView.layer.cornerRadius = 5;
    auView.backgroundColor = rgb(244, 244, 244);
    [self addSubview:auView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(auView.frame.size.width - 40, 10, 30, 30);
    [cancelBtn setImage:[UIImage imageNamed:@"iconfont-quxiao"] forState:UIControlStateNormal];
    [cancelBtn setImageEdgeInsets:UIEdgeInsetsMake((30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2, (30-Hrange(32))/2)];
    [cancelBtn addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
    [auView addSubview:cancelBtn];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(Hrange(56), Vrange(48), Hrange(128), Hrange(128))];
    img.layer.cornerRadius = img.frame.size.height/2;
    img.clipsToBounds = YES;
    if (![_info[@"granteeAvater"] isKindOfClass:[NSNull class]]) {
        if (_info[@"granteeAvater"][@"small"]) {
            [img sd_setImageWithURL:[NSURL URLWithString:_info[@"granteeAvater"][@"small"]] placeholderImage:[UIImage imageNamed:@"icon_user_default"]];
        }else{
            img.image = [UIImage imageNamed:@"icon_user_default"];
        }
    }
    else{
        img.image = [UIImage imageNamed:@"icon_user_default"];
    }
    [auView addSubview:img];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Hrange(130), Hrange(130))];
    view.layer.cornerRadius = view.frame.size.height/2;
    view.center = img.center;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 3;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    [auView addSubview:view];
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+Hrange(40), Vrange(68), auView.frame.size.width-Hrange(56)*2-img.frame.size.width-Hrange(40), 16)];
    if (userName.length>0) {
        name.text = userName;
    }else{
        name.text = NSLocalizedString(@"游客", @"");
    }
    name.textColor = getTitledTextColor();
    name.font = [UIFont systemFontOfSize:16];
    [auView addSubview:name];
    NSString *str;
    if (devName.length>0) {
        str = devName;
    }else{
        NSString *string = isEN() == YES ? _info[@"categoryName"][@"en_US"] : _info[@"categoryName"][@"zh_CN"];
        NSArray *arr = [string componentsSeparatedByString:@"/"];
        str = arr[1];
    }
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"请求共享%@",nil),str];
    CGFloat desheight = [self sizeWithText:string maxSize:CGSizeMake(CGRectGetWidth(name.frame), MAXFLOAT) font:[UIFont systemFontOfSize:13]].height;
    UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(name.frame)+Vrange(36), CGRectGetWidth(name.frame), desheight)];
    des.numberOfLines = 0;
    des.text = string;
    des.textColor = getDescriptiveTextColor();
    des.font = [UIFont systemFontOfSize:13];
    [auView addSubview:des];
    
    UILabel *hLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, auView.frame.size.height-Vrange(100)-0.5, auView.frame.size.width, 0.5)];
    hLabel.backgroundColor = rgb(232, 232, 232);
    [auView addSubview:hLabel];
    
    UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(auView.frame.size.width/2, auView.frame.size.height-Vrange(100), 0.5, Vrange(100))];
    vLabel.backgroundColor = rgb(232, 232, 232);
    [auView addSubview:vLabel];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, auView.frame.size.height-Vrange(100), auView.frame.size.width/2, Vrange(100));
    cancel.backgroundColor = [UIColor clearColor];
    [cancel setTitle:NSLocalizedString(@"拒绝", @"") forState:UIControlStateNormal];
    [cancel setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancel setExclusiveTouch:YES];
    [auView addSubview:cancel];
    
    UIButton *ture = [UIButton buttonWithType:UIButtonTypeCustom];
    ture.frame = CGRectMake(auView.frame.size.width/2+0.5, auView.frame.size.height-Vrange(100), auView.frame.size.width/2-0.5, Vrange(100));
    ture.backgroundColor = [UIColor clearColor];
    [ture setTitle:NSLocalizedString(@"允许", @"") forState:UIControlStateNormal];
    [ture setTitleColor:getButtonBackgroundColor() forState:UIControlStateNormal];
    ture.titleLabel.font = [UIFont systemFontOfSize:16];
    [ture addTarget:self action:@selector(tureAction) forControlEvents:UIControlEventTouchUpInside];
    [ture setExclusiveTouch:YES];
    [auView addSubview:ture];

}

- (void)removeAction{
    _auBlock();
}

- (void)cancelAction{
    _block(NO);
}

- (void)tureAction{
    _block(YES);
    
}

-(void)removeAction:(AuBlock)block{
    _auBlock=block;
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize font:(UIFont *)font{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
