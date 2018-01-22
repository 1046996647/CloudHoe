//
//  DynamicStateModel.m
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "DynamicStateModel.h"

@implementation TimeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headCellArray = [NSMutableArray array];
    }
    return self;
}

@end

@implementation Zanuser

@end

@implementation DynamicStateModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    
    NSArray *timeArr = [self.logtime componentsSeparatedByString:@" "];
//    self.logtime = dic[@"logtime"];
    self.firstTime = [timeArr firstObject];
    //        self.payTime = dic[@"payTime"];
    self.lastTime = [timeArr lastObject];
    
    
    return YES;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"zanuser": [Zanuser class]
             };
}

@end
