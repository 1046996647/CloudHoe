//
//  ManagerViewCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/4/25.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "ManagerViewCell.h"
#import "EasyMacro.h"
#import "Tool.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@implementation ManagerViewCell
{
    UIImageView *_image;
    UILabel *_label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _image = [UIImageView new];
        [self.contentView addSubview:_image];
        _label = [UILabel new];
        _label.textColor = getTitledTextColor();
        _label.font = getListTitleFont();
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _image.frame = CGRectMake(Hrange(30), (self.contentView.frame.size.height-Hrange(34))/2, Hrange(34), Hrange(34));
    _label.frame = CGRectMake(CGRectGetMaxX(_image.frame)+Hrange(30), 0, 200, self.contentView.frame.size.height);
}

- (void)upData:(NSString *)img Title:(NSString *)title{
    _image.image = [UIImage imageNamed:img];
    _label.text = NSLocalizedString(title, nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
