//
//  MDRadialProgressLabel.h
//  MDRadialProgress
//
//  Created by Info on 16/2/25.
//  Copyright © 2016年 skogt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRadialProgressTheme;

@interface MDRadialProgressLabel : UILabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme;

// If adjustFontSizeToFitBounds is enabled, limit the size of the font to the bounds'width * pointSizeToWidthFactor.
@property (assign, nonatomic) CGFloat pointSizeToWidthFactor;

// Whether the algorithm to autoscale the font size is enabled or not.
@property (assign, nonatomic) BOOL adjustFontSizeToFitBounds;

@end
