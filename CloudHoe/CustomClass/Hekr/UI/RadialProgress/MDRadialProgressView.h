//
// MDRadialProgressView.h
// MDRadialProgress
//
//
//  Created by Info on 16/2/25.
//  Copyright © 2016年 skogt. All rights reserved.

#import <UIKit/UIKit.h>


static NSString *keyThickness = @"theme.thickness";


@class MDRadialProgressTheme;
@class MDRadialProgressLabel;


@interface MDRadialProgressView : UIView

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme;

// The total number of steps in the progress view.
@property (assign, nonatomic) NSUInteger progressTotal; //已连接

@property (assign, nonatomic) NSUInteger authorizedCounter; //被授权

@property (assign, nonatomic) NSUInteger grantedCounter; //已授权

// The number of steps currently completed.
@property (assign, nonatomic) NSUInteger onlinceCounter; //在线

// Whether the progress is drawn clockwise (YES) or anticlockwise (NO)
@property (assign, nonatomic) BOOL clockwise;

// The index of the slice where the first completed step is.
@property (assign, nonatomic) NSUInteger startingSlice;

// The theme currently used
@property (strong, nonatomic) MDRadialProgressTheme *theme;

// The label shown in the view's center.
@property (strong, nonatomic) MDRadialProgressLabel *label;

@end
