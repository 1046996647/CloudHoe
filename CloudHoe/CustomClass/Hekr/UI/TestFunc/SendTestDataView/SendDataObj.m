//
//  SendDataObj.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/12/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "SendDataObj.h"

@interface SendDataObj ()
@property (nonatomic,strong) DevicesModel * model;//数据源model
@property (nonatomic,strong) NSArray * devices;//数据源model
@end

@implementation SendDataObj

+(instancetype) sharedInstance{
    static id __instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[SendDataObj alloc] init];
    });
    return __instance;
}
-(instancetype) init{
    self = [super init];
    if (self) {
//        self.model = [[DevicesModel alloc] initTool];
        self.devices = [NSArray array];
        self.isSendData = NO;
    }
    return self;
}

-(void)setDevData:(NSArray *)devs
{
    self.devices = devs;
}

-(NSArray *)getDevData
{
    return self.devices;
}




@end
