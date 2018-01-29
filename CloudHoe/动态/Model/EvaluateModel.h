//
//  EvaluateModel.h
//  CloudHoe
//
//  Created by ZhangWeiLiang on 2018/1/4.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comuser : NSObject

@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *nikename;



@end


@interface EvaluateModel : NSObject

@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *nikename;
@property(nonatomic,strong) NSString *btoId;
@property(nonatomic,strong) NSString *btoname;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,strong) NSString *commentnum;
@property(nonatomic,strong) NSString *comid;
@property(nonatomic,strong) Comuser *comuser;
@property(nonatomic,strong) NSString *type;// 主评论用户评论（回复）则为1 ，如果是其人评论则为0

@property(nonatomic,assign) NSInteger cellHeight;


@end
