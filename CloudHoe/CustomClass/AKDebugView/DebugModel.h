//
//  DebugModel.h
//  HekrSDKAPP
//
//  Created by 张英 on 16/5/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DebugModel : NSObject

@property (nonatomic ,strong) NSString *log;

@property(nonatomic,assign) BOOL isSelected;

@property(nonatomic,strong) NSString *logLevel;
@end
