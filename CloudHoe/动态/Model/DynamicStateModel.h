//
//  DynamicStateModel.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/2.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zanuser : NSObject

@property(nonatomic,strong) NSString *nikename;
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSString *userId;


@end

@interface DynamicStateModel : NSObject

@property(nonatomic,strong) NSString *nikename;
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *logcomment;
@property(nonatomic,strong) NSString *logimg;
@property(nonatomic,strong) NSString *logtime;
@property(nonatomic,strong) NSString *zannum;
@property(nonatomic,strong) NSString *zanstas; //本用户是否已赞，0为未赞，1为已赞
@property(nonatomic,strong) NSString *commentnum;
@property(nonatomic,strong) NSString *logid;
@property(nonatomic,strong) NSArray *zanuser;

@property(nonatomic,assign) NSInteger cellHeight;


@end
