//
//  PersonDynamicCell1.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "PersonDynamicCell1.h"
#import "UILabel+WLAttributedString.h"

@implementation PersonDynamicCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
//        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_baseView];
        
        _imgView1 = [UIImageView imgViewWithframe:CGRectZero icon:@"shui"];
        _imgView1.contentMode = UIViewContentModeScaleAspectFill;
        [_baseView addSubview:_imgView1];
//        _imgView1.backgroundColor = [UIColor redColor];
        
        _contentLab = [UILabel labelWithframe:CGRectZero text:@"晖  成功浇水  多肉盆栽1" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter textColor:@"#313131"];
        [_baseView addSubview:_contentLab];
        [_contentLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"多肉盆栽1"];
        
        _timeLab = [UILabel labelWithframe:CGRectZero text:@"22 : 14" font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentRight textColor:@"#999999"];
        [_baseView addSubview:_timeLab];
    }
    return self;
}

- (void)setModel:(DynamicStateModel *)model
{
    _model = model;
    
    _imgView1.frame = CGRectMake(9, 10, 20, 20);
    _timeLab.frame = CGRectMake(kScreenWidth-30-42-15, _imgView1.centerY-7, 42, 15);
    _contentLab.frame = CGRectMake(_imgView1.right+10, _imgView1.centerY-9, _timeLab.left-(_imgView1.right+10)-10, 18);
    
    _baseView.frame = CGRectMake(15, 0, kScreenWidth-30, 40);
    //1.设置阴影颜色
    _baseView.layer.shadowColor = [UIColor colorWithHexString:@"#D3D5D7"].CGColor;
    _baseView.layer.shadowOffset = CGSizeMake(0,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _baseView.layer.shadowOpacity = 1;//阴影透明度，默认0
    //    self.xiaDanBtn.layer.shadowRadius = 2;//阴影半径，默认3

}

@end
