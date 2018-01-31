//
//  TestViewController.m
//  HekrSDKAPP
//
//  Created by 叶文博 on 16/12/8.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import "TestViewController.h"
#import "SendDataObj.h"
#import <HekrSDK.h>
#import <HekrAPI.h>
#import "DevicesModel.h"
#import "DDLog.h"
#import "Tool.h"
#import <SHAlertViewBlocks.h>
#import "TestUdpConn.h"

@interface TestViewController ()<TestUdpConnDelegate>

@property(nonatomic ,strong) NSMutableDictionary *selectDevs;
@property(nonatomic ,weak) IBOutlet UIButton *controlButton;
@property(nonatomic ,weak) IBOutlet UITableView *table;
@property(nonatomic ,weak) IBOutlet UISwitch *controlSwitch;

@property(nonatomic ,strong) NSTimer *sendTimer;

@property(nonatomic ,strong) NSMutableDictionary *dataOpen;
@property(nonatomic ,strong) NSMutableDictionary *dataClose;
@property(nonatomic ,strong) NSMutableDictionary *dataName;
@property(nonatomic ,strong) NSMutableDictionary *dataCount;
@property(nonatomic ,strong) NSMutableDictionary *dataNum;
@property (nonatomic ,strong) TestUdpConn *udpConn;

@property(nonatomic ) BOOL isLoading;
@property(nonatomic ) BOOL controlDeal;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _udpConn = [[TestUdpConn alloc] initWithDelegate:self];

    // Do any additional setup after loading the view.
    self.selectDevs = [NSMutableDictionary dictionary];
    self.dataOpen = [NSMutableDictionary dictionary];
    self.dataClose = [NSMutableDictionary dictionary];
    self.dataName = [NSMutableDictionary dictionary];
    self.dataCount = [NSMutableDictionary dictionary];
    self.dataNum = [NSMutableDictionary dictionary];

    [self initSendData];
    
    [self.controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.controlButton addTarget:self action:@selector(controlSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.controlButton setTitle:[NSString stringWithFormat:@"%@",[SendDataObj sharedInstance].isSendData?@"发送中":@"开启"] forState:UIControlStateNormal];
    
    self.controlDeal = NO;
    self.controlSwitch.on = NO;
    [self.controlSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];

    //开个SDK的通道...通过心跳或者websocket断开连接才传过来
    [[Hekr sharedInstance] callwebsocketHandle:^(id data, BOOL isLoop) {
        if (!self.controlDeal) {
            if (isLoop) {
                return ;
            }
            if (self.sendTimer) {
                [self.sendTimer invalidate];
                self.sendTimer = nil;
            }
            if ([SendDataObj sharedInstance].isSendData) {
                [self showAlertMessage:@"websocket断开链接，测试数据发送取消!"];
            }
            
            [SendDataObj sharedInstance].isSendData = NO;
            [self.controlButton setTitle:[NSString stringWithFormat:@"开启"] forState:UIControlStateNormal];
        }
        else{
            if (!isLoop) {
                if (self.sendTimer) {
                    [self.sendTimer invalidate];
                    self.sendTimer = nil;
                }
                if ([SendDataObj sharedInstance].isSendData) {
                    [self showAlertMessage:@"websocket断开链接，测试数据发送取消!"];
                }
                [SendDataObj sharedInstance].isSendData = NO;
                [self.controlButton setTitle:[NSString stringWithFormat:@"开启"] forState:UIControlStateNormal];
            }
            else{
                if ([SendDataObj sharedInstance].isSendData) {
                    return;
                }
                else{
                    if (self.isLoading) {
                        if (self.sendTimer) {
                            [self.sendTimer invalidate];
                            self.sendTimer = nil;
                        }
                        [SendDataObj sharedInstance].isSendData = YES;
                        [self.controlButton setTitle:[NSString stringWithFormat:@"发送中"] forState:UIControlStateNormal];
                        [self testLoopSendData];
                        self.sendTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(testLoopSendData) userInfo:nil repeats:YES];
                    }
                }
            }
        }
    }];
}

-(void)switchChange{
    self.controlDeal = self.controlSwitch.on;
    [self showAlertMessage:[NSString stringWithFormat:@"%@持续发送数据，关系到websocket断开后重连是否持续发送数据。",self.controlDeal?@"开启":@"关闭"]];

}

-(void)showAlertMessage:(NSString *)message{
    UIAlertView *alert=[UIAlertView SH_alertViewWithTitle:NSLocalizedString(@"提示", nil) withMessage:NSLocalizedString(message, nil)];
    [alert SH_addButtonCancelWithTitle:NSLocalizedString(@"知道了",nil) withBlock:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.sendTimer) {
        [self.sendTimer invalidate];
        self.sendTimer = nil;
    }
    [SendDataObj sharedInstance].isSendData = NO;
    [self.controlButton setTitle:[NSString stringWithFormat:@"%@",[SendDataObj sharedInstance].isSendData?@"发送中":@"开启"] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)controlSelect{
    if (![[Hekr sharedInstance] getWebsocketSendLoop]) {
        [self showAlertMessage:@"webSocket心跳还未开始，无法发送数据！"];
        return;
    }
    
    [SendDataObj sharedInstance].isSendData = ![SendDataObj sharedInstance].isSendData;
    [self.controlButton setTitle:[NSString stringWithFormat:@"%@",[SendDataObj sharedInstance].isSendData?@"发送中":@"开启"] forState:UIControlStateNormal];
    self.isLoading = [SendDataObj sharedInstance].isSendData;
    if (self.sendTimer) {
        [self.sendTimer invalidate];
        self.sendTimer = nil;
    }
    if ([SendDataObj sharedInstance].isSendData) {
        [self testLoopSendData];
        self.sendTimer=[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(testLoopSendData) userInfo:nil repeats:YES];
    }
}
static BOOL isOpen=NO;
-(void)testLoopSendData{
    isOpen=!isOpen;
    for (HekrDevice *dev in _selectDevs.allValues) {
        [self sendRemoveNet:dev.tid json:[self sendJsonData:dev]];
    }
}

-(id)sendJsonData:(HekrDevice *)dev{
    if (self.dataOpen[dev.tid]) {
        id json = nil;
        if (isOpen) {
            json = self.dataClose[dev.tid];
        }
        else{
            json = self.dataOpen[dev.tid];
        }
        id jsonData = @{@"action":@"appSend",
                   @"msgId":@"0",
                   @"params":@{@"appTid":@"",
                               @"ctrlKey":dev.ctrlKey,
                               @"data":json,
                               @"devTid":dev.tid}};
     
        return jsonData;
    }
    return nil;
}

-(void)sendRemoveNet:(id) devTid json:(id)json{
    if (json==nil) {
        DDLogError(@"tid : %@ 没有控制码！",devTid);
        return;
    }
    NSInteger num = [self.dataNum[devTid] integerValue];
    num++;
    [self.dataNum setObject:[NSNumber numberWithInteger:num] forKey:devTid];
    [[Hekr sharedInstance] sendNet:json to:devTid  timeout:10 callback:^(id responseObject, NSError *e) {
        if (e) {
            DDLogError(@"tid : %@ %@ \n%@的错误码！",devTid,self.dataName[devTid],e);
            if(e && [e code] == -1){
                NSInteger count = [self.dataCount[devTid] integerValue];
                count++;
                [self.dataCount setObject:[NSNumber numberWithInteger:count] forKey:devTid];
                DDLogWarn(@"tid : %@ %@ 设备测试数据超时没反应！%ld 次\n 共发送 %ld 次 \n%@",devTid,self.dataName[devTid],(long)count,(long)num,json);
            }
        }
        else if ([[responseObject objectForKey:@"code"]integerValue] != 200) {
            DDLogError(@"tid : %@ %@ \n%@的错误信息！",devTid,self.dataName[devTid],responseObject);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SendDataObj sharedInstance].getDevData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellIdentifier"];
    }
    NSArray *arr = [SendDataObj sharedInstance].getDevData;
    HekrDevice *dev = arr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",dev.tid,self.dataName[dev.tid]];
    
    if ([self.selectDevs objectForKey:dev.tid]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = [SendDataObj sharedInstance].getDevData;
    HekrDevice *dev = arr[indexPath.row];
    if (![self.selectDevs objectForKey:dev.tid]) {
        [self.selectDevs setObject:dev forKey:dev.tid];
    }
    else{
        [self.selectDevs removeObjectForKey:dev.tid];
    }
    [_table reloadData];
}

-(void)initSendData{
    //提前写好控制命令，可多控。
    [self setSendDataKey:@"ESP_2M_5CCF7F22CE5F"
                    Name:@"内衣柜"
                    Open:@{@"raw":@"48070202030157"}
                   Close:@{@"raw":@"48070202030157"}
                   Count:[NSNumber numberWithInteger:0]];
    
    [self setSendDataKey:@"ESP_2M_5CCF7F2445AE"
                    Name:@"插座"
                    Open:@{@"cmdId":@2,@"power":@1}
                   Close:@{@"cmdId":@2,@"power":@0}
                   Count:[NSNumber numberWithInteger:0]];
    
    [self setSendDataKey:@"ESP_2M_5CCF7F9CA9D6"
                    Name:@"净化器"
                    Open:@{@"raw":@"48190202020200000000000000000000000000000000000069"}
                   Close:@{@"raw":@"48190203020100000000000000000000000000000000000069"}
                   Count:[NSNumber numberWithInteger:0]];
    
    [self setSendDataKey:@"ESP_2M_6001940617A2"
                    Name:@"球泡灯"
                    Open:@{@"B":@0,@"G":@0,@"R":@0,@"W":@100,@"bright":@0,@"cmdId":@1}
                   Close:@{@"B":@0,@"G":@0,@"R":@0,@"W":@0,@"bright":@0,@"cmdId":@1}
                   Count:[NSNumber numberWithInteger:0]];

}

-(void)setSendDataKey:(NSString *)key Name:(NSString *)name Open:(id)open Close:(id)close Count:(NSNumber *)count{
    [self.dataName setObject:name forKey:key];
    [self.dataOpen setObject:open forKey:key];
    [self.dataClose setObject:close forKey:key];
    [self.dataCount setObject:count forKey:key];
    [self.dataNum setObject:count forKey:key];

}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{

}


@end
