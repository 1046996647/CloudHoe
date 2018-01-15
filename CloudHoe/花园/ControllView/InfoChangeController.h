//
//  InfoChangeController.h
//  XiaoYing
//
//  Created by yinglaijinrong on 15/12/15.
//  Copyright © 2015年 MengFanBiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

//@class InfoChangeController;
//@protocol InfoChangeControllerDelegate <NSObject>
//
//- (void)sendText:(NSString *)text;
//
//@end
typedef void(^SendInfoBlock)(NSString *str);


@interface InfoChangeController : BaseViewController

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSIndexPath *indexPath;

//@property (nonatomic,weak) id<InfoChangeControllerDelegate> delegate;

@property (nonatomic, copy)SendInfoBlock block;


@end
