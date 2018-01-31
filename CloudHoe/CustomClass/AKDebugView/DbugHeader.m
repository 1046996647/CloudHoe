//
//  DbugHeader.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/8/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "DbugHeader.h"
#import "EasyMacro.h"
#import "DebugView.h"




@implementation DbugHeader

-(instancetype)initWithFrame:(CGRect)frame{
    
   self = [super initWithFrame:frame];
    
    if (self) {
        [self creatHeadView];
    }
    return self;
}
-(void)creatHeadView{
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height , self.frame.size.width, Vrange(235))];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(10,1, self.frame.size.width - Hrange(56), 1)];
    
    separator.backgroundColor = [UIColor blackColor];
    
    [self addSubview:separator];
    
    _seachBar=[[UISearchBar alloc] initWithFrame:CGRectMake(10,  CGRectGetMaxY(separator.frame) , self.frame.size.width - 20 ,Vrange(94))];
    
    _seachBar.placeholder = @"Text,filename,etc,";
    _seachBar.backgroundColor=[UIColor clearColor];
    _seachBar.delegate = self;
    _seachBar.showsCancelButton = YES;
    _seachBar.searchBarStyle = UISearchBarStyleMinimal;
    
    NSArray *segmentedItem = @[@"Verbose",@"Debug",@"Info",@"Warn",@"Error"];
    _segment = [self addSegmentWithArray:segmentedItem frame:CGRectMake(20,CGRectGetMaxY(_seachBar.frame) + 10,  self.frame.size.width - 40,Vrange(59)) selectedSegmentIndex:0 action:@selector(changeLog:)];
    
    [self addSubview:_segment];
    [self addSubview:_seachBar];
    
}

- (UISegmentedControl *)addSegmentWithArray:(NSArray *)segmentArray  frame:(CGRect)frame selectedSegmentIndex:(NSInteger )Index action:(SEL)action
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    segment.frame = frame;
    segment.selectedSegmentIndex = Index;
    [segment addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    return segment;
}

-(void)changeLog:(UISegmentedControl *)sender{

    if ([_delegate respondsToSelector:@selector(changeLogWithLevel:)]) {
        [self.delegate changeLogWithLevel:sender.selectedSegmentIndex];
    }
}

@end

