//
//  PersonalModel.h
//  Recruitment
//
//  Created by ZhangWeiLiang on 2017/9/9.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSCoding>

@property(nonatomic,strong) NSString *Token;
@property(nonatomic,strong) NSString *userId;

@property(nonatomic,assign) NSInteger cellHeight;

@end
