//
//  DbugHeader.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/8/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DbugHeaderDelegata <NSObject>
- (void)changeLogWithLevel:(NSUInteger)index;

@end

@interface DbugHeader : UIView <UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *seachBar;
@property (strong, nonatomic) UISegmentedControl *segment;
@property (nonatomic, strong) UIView * maskingView;
@property (nonatomic, strong)UISearchDisplayController *searchDC;

//装着搜索结果的数据源
@property (nonatomic, strong)NSMutableArray *searchResultArray;
@property(nonatomic,weak)id<DbugHeaderDelegata>delegate;
@end
