//
//  DeviceRecordCell.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/11.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DeviceRecordCell.h"
#import "UILabel+WLAttributedString.h"

@implementation DeviceRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _stateBtn = [UIButton buttonWithframe:CGRectMake(0, 0, 45, 46) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#999999" backgroundColor:@"" normal:@"Rectangle 18" selected:@"bangd "];
        [self.contentView addSubview:_stateBtn];
        //        _xiaDanBtn.tag = 0;
        
        
        _nameLab = [UILabel labelWithframe:CGRectMake(_stateBtn.right, 0, kScreenWidth-_stateBtn.right-10, 46) text:@"设备号：12346 (在线)" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft textColor:@"#313131"];
        [self.contentView addSubview:_nameLab];
        [_nameLab wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#999999"] changeText:@"(在线)"];

        
    }
    return self;
}



@end
