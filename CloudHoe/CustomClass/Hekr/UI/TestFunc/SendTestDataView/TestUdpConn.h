//
//  TestUdpConn.h
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncUdpSocket.h"

@protocol TestUdpConnDelegate <NSObject>

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext;

@end

@interface TestUdpConn : NSObject

-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate;

@end
