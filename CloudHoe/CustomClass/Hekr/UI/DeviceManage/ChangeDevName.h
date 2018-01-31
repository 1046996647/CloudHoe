//
//  ChangeDevName.h
//  HekrSDKAPP
//
//  Created by hekr on 16/8/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeDevNameDelegate <NSObject>

- (void)changeDevName:(NSString *)devName;

@end
@interface ChangeDevName : UIView
@property (nonatomic, weak) id<ChangeDevNameDelegate> delegeate;
@end
