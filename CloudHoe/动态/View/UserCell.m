//
//  UserCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 55, 55)];
        //        _imgView.image = [UIImage imageNamed:@"food"];
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.layer.cornerRadius = _imgView.height/2;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        
//        _imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_imgView.width-16, _imgView.height-16, 16, 16)];
//        //        _imgView.image = [UIImage imageNamed:@"food"];
//        _imgView1.backgroundColor = [UIColor redColor];
//        [_imgView addSubview:_imgView1];
        
        _label = [UILabel labelWithframe:CGRectMake(0, _imgView.bottom+5, _imgView.width, 13) text:@"赵诗怡" font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentCenter textColor:@"#6F6F6F"];
        [self.contentView addSubview:_label];
    }
    return self;
}

@end
