//
//  PromptCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/7/19.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "PromptCell.h"
#import "Tool.h"
#import <UIImageView+WebCache.h>

@interface PromptCell ()
@property (nonatomic, strong)UIView *view;
@property (nonatomic, strong)UIImageView *img;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UILabel *subLabel;
@end

@implementation PromptCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _view = [UIView new];
        _view.backgroundColor = rgb(228, 77, 77);
        _view.alpha = 0.3;
        _img = [UIImageView new];
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = getTitledTextColor();
        _label.textAlignment = NSTextAlignmentLeft;
        _subLabel = [UILabel new];
        _subLabel.font = [UIFont systemFontOfSize:15];
        _subLabel.textColor = getDescriptiveTextColor();
        _subLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_view];
        [self.contentView addSubview:_img];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_subLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewHeight = self.contentView.frame.size.height - 2 * Vrange(30);
    _view.frame = CGRectMake(Vrange(30), Vrange(30), viewHeight, viewHeight);
    _view.layer.cornerRadius = viewHeight/2;
    _img.frame = CGRectMake(0, 0, viewHeight/3*2, viewHeight/3*2);
    _img.center = _view.center;
    CGFloat oriX = CGRectGetMaxX(_view.frame)+Vrange(30);
    _label.frame = CGRectMake(oriX, 10, self.contentView.frame.size.width - oriX - Vrange(30), (CGRectGetHeight(self.contentView.frame) - 20)/2);
    _subLabel.frame = CGRectMake(oriX, CGRectGetMaxY(_label.frame), CGRectGetWidth(_label.frame), CGRectGetHeight(_label.frame));
    
}
//NSLocalizedString(@"已被 %@ 绑定",nil)
- (void)upData:(id)info{
    [_img sd_setImageWithURL:[NSURL URLWithString:info[@"logo"]]];
    if (info[@"bindResultMsg"]) {
        NSString *str = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] firstObject];
        if ([str isEqualToString:@"E001"]) {
            
            NSString *user = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] lastObject];
            if (validateMobile(user)) {
                user = [NSString stringWithFormat:@"%@****%@",[user substringWithRange:NSMakeRange(0, 3)],[user substringWithRange:NSMakeRange(7, 4)]];
            }else{
                NSArray *arr = [user componentsSeparatedByString:@"@"];
                if ([[arr firstObject] length] < 3) {
                    user = [NSString stringWithFormat:@"%@****@%@",[arr firstObject],[arr lastObject]];
                }else{
                    user = [NSString stringWithFormat:@"%@****@%@",[[arr firstObject] substringWithRange:NSMakeRange(0, 3)],[arr lastObject]];
                }
            }
            _subLabel.text = isEN() == YES ? [NSString stringWithFormat:@"bound by %@",user] : [NSString stringWithFormat:@"已被 %@ 绑定",user];
        }else if ([str isEqualToString:@"E002"]){
            _subLabel.text = NSLocalizedString(@"操作超时",nil);
        }else if ([str isEqualToString:@"E003"]){
            _subLabel.text = NSLocalizedString(@"不支持绑定",nil);
        }else if ([str isEqualToString:@"E004"]){
            _subLabel.text = NSLocalizedString(@"已被本账号绑定",nil);
        }else{
            _subLabel.text = NSLocalizedString(@"未知原因",nil);
        }
        NSString *devName = info[@"name"];
        if (devName.length > 0) {
            _label.text = devName;
        }else{
            NSString *productName = isEN() == YES ? info[@"productName"][@"en_US"] : info[@"productName"][@"zh_CN"];
            if (productName.length > 0) {
                _label.text = productName;
            }else{
                NSString *categoryName = isEN() == YES ? [[info[@"categoryName"][@"en_US"] componentsSeparatedByString:@"/"] lastObject] : [[info[@"categoryName"][@"zh_CN"] componentsSeparatedByString:@"/"] lastObject];
                _label.text = categoryName;
                
            }
        }

    }else{
        _label.text = info[@"cidName"];
        _subLabel.text = isEN() == YES ? [NSString stringWithFormat:@"bound by %@",info[@"message"]] : [NSString stringWithFormat:@"已被 %@ 绑定",info[@"message"]];
    }
}

//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
