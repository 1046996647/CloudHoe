//
//  TestUdpConn.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 2017/9/5.
//  Copyright © 2017年 Mike. All rights reserved.
//

#import "TestUdpConn.h"

@interface UdpConn : NSObject<GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong) GCDAsyncUdpSocket * socket;
@property (nonatomic,weak) id<TestUdpConnDelegate> delegate;
-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate;
@end

//广播
@interface BUdpConn : UdpConn

@end

//组播
@interface MUdpConn : UdpConn

@end

@interface TestUdpConn ()
@property(nonatomic ,strong) BUdpConn *broadcast;
@property(nonatomic ,strong) MUdpConn *multicast;

@end

@implementation TestUdpConn

-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate{
    self = [super init];
    if (self) {
        self.broadcast = [[BUdpConn alloc] initWithDelegate:delegate];
        self.multicast = [[MUdpConn alloc] initWithDelegate:delegate];
    }
    return self;
}

@end

@implementation UdpConn

-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    
    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"devConfig: %@",d);
//    [self.delegate udpSocket:sock didReceiveData:data fromAddress:address withFilterContext:filterContext];
}

@end

@implementation BUdpConn

-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *error = nil;
        
        [self.socket enableReusePort:YES error:&error];
        [self.socket bindToPort:24253 error:&error];
        [self.socket beginReceiving:&error];
        [self.socket enableBroadcast:YES error:&error];
        
        if (error) {
            NSLog(@"error: %@",error);
        }
        
        NSLog(@"begin scan");
        NSLog(@"start BroadcastUdpConn server");
        
    }
    return self;
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{

    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    NSLog(@"BroadcastUdpConn DidReceiveData:%@",d);
}

@end

@implementation MUdpConn

-(instancetype) initWithDelegate:(id<TestUdpConnDelegate>)delegate{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSError *error = nil;
        [self.socket enableReusePort:YES error:&error];
        [self.socket bindToPort:24254 error:&error];
        [self.socket beginReceiving:&error];
        [self.socket enableBroadcast:YES error:&error];
        [self.socket joinMulticastGroup:@"224.0.0.207" error:&error];
        
        if (error) {
            NSLog(@"error: %@",error);
        }
        NSLog(@"start MulticastUdpConn server");
        
    }
    return self;
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{

    NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];


    NSLog(@"MulticastUdpConn DidReceiveData:%@",d);
}

@end
