//
//  SafetyQuestionViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/9/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    changeBind,
    resetPassWord,
    setSafetyQuestion,
    resetSafetyQuestion,
} SafetyQuestionViewType;

@interface SafetyQuestionViewController : UIViewController

- (instancetype)initWithIsOne:(BOOL)isOne Num:(NSString *)num Title:(NSString *)title ViewType:(SafetyQuestionViewType)type;;

@end
