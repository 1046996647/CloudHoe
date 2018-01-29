//
//  UserModel.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/8.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSString *nikename;
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSString *userId;

@end
