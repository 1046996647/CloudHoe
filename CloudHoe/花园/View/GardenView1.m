//
//  GardenView1.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/27.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "GardenView1.h"
#import "UILabel+WLAttributedString.h"

@implementation GardenView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#EDEEEF"];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    
    //
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 138)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UILabel *label = [UILabel labelWithframe:CGRectMake(0, 36, kScreenWidth, 16) text:@"您的花园未种植任何花草！" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#999999"];
    [view addSubview:label];
    
    UIButton *addBtn = [UIButton buttonWithframe:CGRectMake(label.centerX-155/2, label.bottom+13, 155, 44) text:@"去添加植物" font:[UIFont systemFontOfSize:16] textColor:@"#50DBD1" backgroundColor:@"" normal:nil selected:nil];
    addBtn.layer.cornerRadius = addBtn.height/2;
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.borderWidth = 1;
    addBtn.layer.borderColor = [UIColor colorWithHexString:@"#50DBD1"].CGColor;
    [view addSubview:addBtn];
    self.addBtn = addBtn;
    
    UILabel *label1 = [UILabel labelWithframe:CGRectMake(label.centerX-216/2, view.bottom+15, 216, 16) text:@"您的个人信息还没有完善，去完善" font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#999999"];
    label1.userInteractionEnabled = YES;
    [self addSubview:label1];
    [label1 wl_changeColorWithTextColor:[UIColor colorWithHexString:@"#0380D9"] changeText:@"去完善"];
    
    UIButton *personBtn = [UIButton buttonWithframe:CGRectMake(label1.width-42, 0, 42, label1.height) text:@"" font:[UIFont systemFontOfSize:16] textColor:@"#50DBD1" backgroundColor:@"" normal:nil selected:nil];
    [label1 addSubview:personBtn];
    //    [personBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.personBtn = personBtn;
    
    self.height = label1.bottom+10;
    
}

@end
