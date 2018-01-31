//
//  HekrMainViewController.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/28.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
#import <HekrAPI.h>
#import <HekrSDK.h>

@interface HekrMainViewController : UIViewController
@property (nonatomic ,strong ,readonly,nullable) HekrNavigationBarView *nav;

- (void)initNavView;



@end
