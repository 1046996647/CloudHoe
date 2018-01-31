//
//  AuthorizationView.h
//  HekrSDKAPP
//
//  Created by hekr on 16/7/7.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AuBlock)(void);

@interface AuthorizationView : UIView



- (instancetype)initWithFrame:(CGRect)frame Data:(id)info Block:(void (^)(BOOL isTure))block;
- (void)removeAction:(AuBlock)block;

@end
