//
//  TiaoGungView.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/5.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "TiaoGungView.h"
#import "PaletteView.h"
#import "UIImage+base.h"

@interface TiaoGungView ()

@property(nonatomic,strong) UIButton *moShiBtn;
@property(nonatomic,strong) UIButton *colorBtn;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) UIView *btnBgView;
@property(weak,nonatomic) PaletteView *paletteView;


@end

@implementation TiaoGungView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-416, kScreenWidth, 416)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    UIButton *delBtn = [UIButton buttonWithframe:CGRectMake(kScreenWidth-30-30, baseView.top-30-7, 30, 30) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"chhao" selected:nil];
    [self addSubview:delBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    [delBtn addTarget:self action:@selector(delAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *LiangGuangBtn = [UIButton buttonWithframe:CGRectMake(baseView.centerX-30, 0-30, 60, 60) text:@"" font:[UIFont systemFontOfSize:14] textColor:@"#999999" backgroundColor:nil normal:@"tiaoguang" selected:nil];
    [baseView addSubview:LiangGuangBtn];
    //    _evaBtn.userInteractionEnabled = NO;
    
    UIButton *moShiBtn = [UIButton buttonWithframe:CGRectMake(baseView.centerX-90, LiangGuangBtn.bottom, 90, 40) text:@"模式" font:[UIFont systemFontOfSize:16] textColor:@"#6F6F6F" backgroundColor:nil normal:@"" selected:nil];
    [baseView addSubview:moShiBtn];
    [moShiBtn setTitleColor:[UIColor colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
    [moShiBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:UIControlStateSelected];
    moShiBtn.selected = YES;
    moShiBtn.tag = 0;
    self.moShiBtn = moShiBtn;
    [moShiBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(moShiBtn.left, moShiBtn.bottom, moShiBtn.width, 2)];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#50DBD1"];
    [baseView addSubview:_lineView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, baseView.width, .5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [baseView addSubview:line];
    
    UIButton *colorBtn = [UIButton buttonWithframe:CGRectMake(moShiBtn.right, moShiBtn.top, 90, 40) text:@"色彩" font:[UIFont systemFontOfSize:16] textColor:@"#6F6F6F" backgroundColor:nil normal:@"" selected:nil];
    [baseView addSubview:colorBtn];
    [colorBtn setTitleColor:[UIColor colorWithHexString:@"#6F6F6F"] forState:UIControlStateNormal];
    [colorBtn setTitleColor:[UIColor colorWithHexString:@"#313131"] forState:UIControlStateSelected];
    self.colorBtn = colorBtn;
    colorBtn.tag = 1;
    [colorBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 模式
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, _lineView.bottom, kScreenWidth, 416-78)];
    btnBgView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:btnBgView];
    self.btnBgView = btnBgView;
    
    //    CGFloat interval = 31;
    CGFloat aWidth = kScreenWidth/4.0;
    NSArray *imgArr = @[@"20-2",@"20-3",@"20-4",@"20-5",@"20-6",@"20-7",@"20-8",@"20-9"];
    NSArray *imgArr1 = @[@"20-10",@"20-11",@"20-12",@"20-13",@"20-14",@"20-15",@"20-16",@"20-17"];
    //    NSArray *titleArr2 = @[@"职位管理",@"简历搜索",@"邀请面试记录",@"约聊招聘",@"我的信箱",@"在线投诉/留言"];
    NSArray *titleArr2 = @[@"睡眠",@"阅读",@"激情",@"唤醒",@"夜店",@"浪漫",@"自拍",@"影院"];
    for (int i=0; i<titleArr2.count; i++) {
        
        UIButton *forgetBtn = [UIButton buttonWithframe:CGRectMake((i%4)*aWidth, 39+(i/4)*(85+39), aWidth, 85) text:nil font:nil textColor:nil backgroundColor:@"#FFFFFF" normal:nil selected:nil];
        [btnBgView addSubview:forgetBtn];
        //        self.forgetBtn2 = forgetBtn;
        
        UIButton *forgetBtn1 = [UIButton buttonWithframe:CGRectMake((forgetBtn.width-55)/2, 0, 55, 55) text:nil font:nil textColor:nil backgroundColor:@"#FFFFFF" normal:imgArr[i] selected:imgArr1[i]];
        [forgetBtn addSubview:forgetBtn1];
        //        self.forgetBtn2 = forgetBtn;
        //        [forgetBtn1 addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
        forgetBtn1.tag = i;
        
        UILabel *label1 = [UILabel labelWithframe:CGRectMake(0, forgetBtn1.bottom+10, forgetBtn.width, 20) text:titleArr2[i] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter textColor:@"#6F6F6F"];
        [forgetBtn addSubview:label1];
        
    }
    
    // 拾色器
    CGFloat wh = 188;
    PaletteView *temp = [[PaletteView alloc] initWithFrame:CGRectMake(kScreenWidth/2-(wh)/2, _lineView.bottom+ 60, wh, wh)];
    [baseView addSubview:temp];
    self.paletteView = temp;
    self.paletteView.hidden = YES;
    self.paletteView.colorPickerImage = [UIImage imageForResizeWithImageName:@"se" resize:CGSizeMake(188, 188)];

    self.paletteView.currentColorBlock = ^(CGFloat R,CGFloat G,CGFloat B,CGFloat L) {
        
        NSLog(@"R: %f G: %f B: %f L: %f",R,G,B,L);
        
    };
}



- (void)selectAction:(UIButton *)btn
{
    if (btn.tag == 0) {
        _moShiBtn.selected = YES;
        _colorBtn.selected = NO;
        _btnBgView.hidden = NO;
        _paletteView.hidden = YES;

        _lineView.left = _moShiBtn.left;
    }
    else {
        _moShiBtn.selected = NO;
        _colorBtn.selected = YES;
        _btnBgView.hidden = YES;
        _paletteView.hidden = NO;

        _lineView.left = _colorBtn.left;
    }
}

- (void)delAction
{
    [self removeFromSuperview];
}

@end
