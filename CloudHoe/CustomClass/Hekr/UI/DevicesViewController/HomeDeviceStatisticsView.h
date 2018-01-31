//
//  HomeDeviceStatisticsView.h
//  HekrSDKAPP
//
//  Created by Mike on 16/2/23.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDeviceStatisticsView : UIView
//@property (nonatomic,assign) NSUInteger n_count;
//@property (nonatomic,assign) NSUInteger n_online;
//@property (nonatomic,assign) NSUInteger n_authorized;
//@property (nonatomic,assign) NSUInteger n_beAuthorized;

- (void)updateDeviceData;

- (void)refreshAction;

- (void)refreshTheme;
@end
