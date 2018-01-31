//
//  SideViewController.h
//  HekrSDKAPP
//
//  Created by Mike on 16/2/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"

@protocol SideViewSubViewDelegate <NSObject>

- (void)clickFrom:(NSString *)string;

@end

@interface MainContainer : UINavigationController

@end

@interface SideMenuController : LGSideMenuController
-(void) toggleLeftMenu:(id) sender;
@end

@interface SideViewController : UIViewController

@end

@interface SideViewSubView : UIView

@property (nonatomic, weak)id <SideViewSubViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andImg:(UIImage *)viewImg andTitle:(NSString *)viewTitle;

@end
