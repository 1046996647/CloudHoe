//
//  MyCustomLoggeer.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "Tool.h"

@interface MyCustomLoggeer : DDAbstractLogger

@property(nonatomic, strong)  NSArray *logMessageArray;


+(instancetype)sharedInstance;
@end
