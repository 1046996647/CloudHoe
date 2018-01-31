//
//  UserCell.m
//  HekrSDKAPP
//
//  Created by hekr on 16/3/31.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "UserCell.h"
#import "EasyMacro.h"
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
//#define Width                     [UIScreen mainScreen].bounds.size.width
//#define Height                    [UIScreen mainScreen].bounds.size.height
//#define Hrange(x)  (x/750.0)*Width
//#define Vrange(x)  (x/1334.0)*Height
@implementation UserCell
{
    UIView *_bgView;
    UIImageView *_image;
    UILabel *_titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGFloat orginY = (Vrange(110)-Hrange(54))/2;
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(Hrange(20), orginY, Hrange(54), Hrange(54))];
        _bgView.layer.cornerRadius = _bgView.frame.size.height/2;
        [self.contentView addSubview:_bgView];
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Hrange(30), Hrange(30))];
        _image.center = CGPointMake(_bgView.center.x, _bgView.center.y);
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Hrange(98), CGRectGetMinY(_bgView.frame), 100, CGRectGetHeight(_bgView.frame))];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = rgb(80, 80, 82);
        [self.contentView addSubview:_titleLabel];
        
    }
    
    return self;
}

- (void)updata:(NSString *)title img:(NSString *)img bgColor:(UIColor *)color{
    _titleLabel.text = title;
    _bgView.backgroundColor = color;
    _image.image = [UIImage imageNamed:img];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
