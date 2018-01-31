//
//  MyCustomLoggeer.m
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/16.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "MyCustomLoggeer.h"
#import "DebugModel.h"

@implementation MyCustomLoggeer

+(instancetype)sharedInstance{
    static MyCustomLoggeer *myCustomLoggeer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        myCustomLoggeer = [[self alloc] init];
          
        
    });
    
    return  myCustomLoggeer;
}
-(void)logMessage:(DDLogMessage *)logMessage{
    
 
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    NSString *logMsg = logMessage.message;
    if(self->_logFormatter)
        logMsg = [self->_logFormatter formatLogMessage:logMessage];
    
    if (logMsg) {
        if (!_logMessageArray) {
            
            _logMessageArray = [NSMutableArray array];
        }
       
        DebugModel *model = [[DebugModel alloc] init];
        
        model.log = [NSString stringWithFormat:@"%@ %@ | %@", logLevel, [self getTime], logMsg];
        model.isSelected = NO;
        model.logLevel = logLevel;

//        [[self mutableArrayValueForKeyPath:@"logMessageArray"] insertObject:[NSString stringWithFormat:@"%@  %@",[self getTime],logMsg] atIndex:0];
        [[self mutableArrayValueForKeyPath:@"logMessageArray"] insertObject:model atIndex:0];
        
    }
    
   
}

-(NSString *)getTime{
    
    NSDate *  sendDate=[NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    
    NSString * locationString=[formatter stringFromDate:sendDate];
    
    return locationString;
}

@end
