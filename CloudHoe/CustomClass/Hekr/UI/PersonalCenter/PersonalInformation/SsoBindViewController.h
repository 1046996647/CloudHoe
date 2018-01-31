//
//  SsoBindViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/9/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SsoBindViewDelegate <NSObject>

- (void)refurbishSsoImg:(NSMutableDictionary *)dicData;

@end

@interface SsoBindViewController : UIViewController

@property (nonatomic, weak)id<SsoBindViewDelegate>deletage;

- (instancetype)initWithInfo:(NSMutableDictionary *)info;

@end
