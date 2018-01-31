//
//  ConfigDevModel.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/8/31.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "ConfigDevModel.h"
#import "Tool.h"

@implementation ConfigDevModel

- (instancetype)initWithConfigDevModel:(NSDictionary *)data{
    self = [super init];
    if (self) {
        _tid = [data objectForKey:@"devTid"];
//        _step = [[data objectForKey:@"STEP"] integerValue];
//        _state = [[data objectForKey:@"code"] integerValue]==200;
        _state = YES;
        _data = data;
    }
    return self;
}

-(void)setConfigDevModel:(NSDictionary *)data{
//    _step = [[data objectForKey:@"STEP"] integerValue];
//    if (_step == ConfigDeviceStepFinish) {
//        _state = [ConfigDevModel devContentState:data];
//    }else{
//        _state = [[data objectForKey:@"code"] integerValue]==200;
//    }
    _data = data;
}

-(BOOL)changeCurrentState{
    if ([[_data objectForKey:@"STEP"] integerValue]>_step) {
        _step++;
        if ([[_data objectForKey:@"STEP"] integerValue]==_step) {
            if (_step == ConfigDeviceStepFinish) {
                _state = [ConfigDevModel devContentState:_data];
            }else{
                _state = [[_data objectForKey:@"code"] integerValue]==200;
            }
        }else{
            _state = YES;
        }
        return YES;
    }
    return NO;
}

+(BOOL)devContentState:(NSDictionary *)info{
    if (![info[@"bindResultCode"] boolValue]) {
        return YES;
    }else {
        if (info[@"bindResultMsg"]) {
            NSString *str = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] firstObject];
            if ([str isEqualToString:@"E004"]){
                return YES;
            }
        }
    }
    return NO;
}

+(NSString *)devFailReason:(NSDictionary *)info comeType:(BOOL)comeType{
    if (info[@"bindResultMsg"]) {
        NSString *str = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] firstObject];
        if ([str isEqualToString:@"E001"]) {
            
            NSString *user = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] lastObject];
//            user = @"494423787878787887475@qq.com";
            if (validateMobile(user)) {
                //user = [NSString stringWithFormat:@"%@***%@",[user substringWithRange:NSMakeRange(0, 3)],[user substringWithRange:NSMakeRange(7, 4)]];
            } else if (validateEmail(user)) {
                if (comeType) {
                    NSArray *arr = [user componentsSeparatedByString:@"@"];
                    if ([[arr firstObject] length] > 6) {
                        user = [NSString stringWithFormat:@"%@***@%@",[[arr firstObject] substringWithRange:NSMakeRange(0, 3)],[arr lastObject]];
                    }else{
                        //user = [NSString stringWithFormat:@"%@***@%@",[arr firstObject],[arr lastObject]];
                    }
                }
            }
            return isEN() == YES ? [NSString stringWithFormat:@"Bound by %@",user] : [NSString stringWithFormat:@"设备已被%@绑定",user];
        }else if ([str isEqualToString:@"E002"]){
            return NSLocalizedString(@"操作超时",nil);
        }else if ([str isEqualToString:@"E003"]){
            return NSLocalizedString(@"不支持绑定",nil);
        }else{
            return NSLocalizedString(@"未知原因",nil);
        }
        
    }else{
        return isEN() == YES ? [NSString stringWithFormat:@"Bound by %@",info[@"message"]] : [NSString stringWithFormat:@"已被 %@ 绑定",info[@"message"]];
    }
}

+(NSString *)devFailResult:(NSDictionary *)info{
    if (info[@"bindResultMsg"]) {
        NSString *str = [[info[@"bindResultMsg"] componentsSeparatedByString:@":"] firstObject];
        if ([str isEqualToString:@"E001"]) {
            return NSLocalizedString(@"被其他账号绑定", nil);
        }else if ([str isEqualToString:@"E002"]){
            return NSLocalizedString(@"操作超时",nil);
        }else if ([str isEqualToString:@"E003"]){
            return NSLocalizedString(@"不支持绑定",nil);
        }else{
            return NSLocalizedString(@"未知原因",nil);
        }
    }else{
        return NSLocalizedString(@"被其他账号绑定", nil);
    }
}

@end
