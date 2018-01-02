/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import "UIColor+Expend.h"

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint origin;
@property CGSize size;

@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

@property CGFloat height;
@property CGFloat width;

@property CGFloat top;
@property CGFloat left;

@property CGFloat bottom;
@property CGFloat right;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;

// UILabel
+ (UILabel *)labelWithframe:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment textColor:(NSString *)color;

// UIImageView
+ (UIImageView *)imgViewWithframe:(CGRect)frame icon:(NSString *)icon;

// UIButton
+ (UIButton *)buttonWithframe:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(NSString *)color backgroundColor:(NSString *)backColor normal:(NSString *)normal selected:(NSString *)selected;

// UITextField
+ (UITextField *)textFieldWithframe:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font leftView:(UIView *)leftView backgroundColor:(NSString *)backColor;

// UITableView
+ (UITableView *)tableViewWithframe:(CGRect)frame style:(UITableViewStyle)style;


// 在view中获取viewController
- (UIViewController *)viewController;


@end
