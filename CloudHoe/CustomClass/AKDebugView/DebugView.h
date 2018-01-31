//
//  DebugView.h
//  HekrSDKAPP
//
//  Created by 单天赛 on 16/5/12.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyCustomLoggeer.h"
@interface DebugView : UIView<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong) NSMutableArray *logArray;

@property(nonatomic,strong) NSMutableArray *logErrorArray;

@property(nonatomic,strong) NSMutableArray *logWarningArray;
@property(nonatomic,strong) NSMutableArray *logInfoArray;

@property(nonatomic,strong) NSMutableArray *logDebugArray;
@end
