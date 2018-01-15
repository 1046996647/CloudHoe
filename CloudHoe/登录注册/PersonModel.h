//
//  PersonalModel.h
//  Recruitment
//
//  Created by ZhangWeiLiang on 2017/9/9.
//  Copyright © 2017年 ZhangWeiLiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject<NSCoding>

@property(nonatomic,strong) NSString *nikename;
@property(nonatomic,strong) NSString *headimg;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,strong) NSString *birthday;
@property(nonatomic,strong) NSString *tab;
@property(nonatomic,strong) NSString *introduce;

@end
