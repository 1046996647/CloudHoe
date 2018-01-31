//
//  SsoBindTableViewCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/9/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SsoBindTableViewCell.h"
#import "Tool.h"
#import <Masonry.h>

@interface SsoBindTableViewCell()
@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UILabel *downLabel;
@property (nonatomic, strong)UIImageView *arrowhead;

@end

@implementation SsoBindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _img = [UIImageView new];
        _img.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_img];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = getListTitleFont();
        _titleLabel.textColor = getTitledTextColor();
        [self.contentView addSubview:_titleLabel];
        
        _statusLabel = [UILabel new];
        _statusLabel.font = getDescTitleFont();
        _statusLabel.textColor = getDescriptiveTextColor();
        [self.contentView addSubview:_statusLabel];
        
        _arrowhead = [UIImageView new];
        _arrowhead.image = [UIImage imageNamed:@"ic_user_arrowhead"];
        [self.contentView addSubview:_arrowhead];
        
        _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-sHrange(360), Vrange(100)-1, sHrange(360), 1)];
        _downLabel.backgroundColor = rgb(233, 233, 233);
        _downLabel.alpha = 0.5;
        [self.contentView addSubview:_downLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    WS(weakSelf);
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).offset(Hrange(56));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Vrange(36), Vrange(36)));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(Hrange(50));
        make.top.mas_equalTo(0);
        make.height.equalTo(weakSelf.contentView.mas_height);
    }];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-Hrange(32));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(Hrange(14), Vrange(24)));
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.arrowhead.mas_left).offset(-Hrange(50));
        make.top.mas_equalTo(0);
        make.height.equalTo(weakSelf.contentView.mas_height);
    }];
    [_statusLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
}

- (void)updataWithTitle:(NSString *)title Img:(NSString *)img Status:(NSString *)status{
    _titleLabel.text = NSLocalizedString(title, nil);
    _img.image = [UIImage imageNamed:img];
    _statusLabel.text = status;
//    if ([status isEqualToString:NSLocalizedString(@"已绑定", nil)]) {
//        _statusLabel.textColor = getDescriptiveTextColor();
//    }else{
//        _statusLabel.textColor = UIColorFromHex(0x06a4f0);
//    }
}


//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
