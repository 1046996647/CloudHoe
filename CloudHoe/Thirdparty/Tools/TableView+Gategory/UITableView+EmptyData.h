//
//  UITableView+EmptyData.h
//  piaojuke
//
//  Created by 毕青林 on 15/11/10.
//  Copyright © 2015年 毕青林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;

@end
