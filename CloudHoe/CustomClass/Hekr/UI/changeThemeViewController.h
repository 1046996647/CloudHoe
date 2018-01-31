//
//  changeThemeViewController.h
//  HekrSDKAPP
//
//  Created by hekr on 16/10/24.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThemeViewDelegate <NSObject>

- (void)changeTheme:(NSString *)themeName;

@end

@interface changeThemeViewController : UIViewController

@end

@interface ThemeView : UIView

@property (nonatomic, weak)id<ThemeViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withThemeImage:(UIImage *)themeImage withThemeTitle:(NSString *)themeTitle;

- (void)setSelected:(UIColor *)color;

- (void)deselect;

@end
