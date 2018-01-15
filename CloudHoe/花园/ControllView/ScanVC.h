//
//  ScanVC.h
//  Rice
//
//  Created by ZhangWeiLiang on 2018/1/3.
//  Copyright © 2018年 ZhangWeiLiang. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScanBlock)(NSString *str);

@interface ScanVC : BaseViewController

@property(nonatomic,copy) ScanBlock block;


@end
