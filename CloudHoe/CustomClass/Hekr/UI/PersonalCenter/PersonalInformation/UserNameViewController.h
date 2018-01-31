//
//  UserNameViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/4/15.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserNameDelegate <NSObject>

-(void)saveUserName:(NSString *)name;

@end

@interface UserNameViewController : UIViewController
@property (nonatomic, weak)id<UserNameDelegate>delegate;

- (instancetype)initWIthName:(NSString *)name;

@end
