//
//  SendDataObj.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/12/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DevicesModel.h"

@interface SendDataObj : NSObject

@property(nonatomic)BOOL isSendData;

+(instancetype) sharedInstance;
-(void)setDevData:(NSArray *)devs;
-(NSArray *)getDevData;



@end
