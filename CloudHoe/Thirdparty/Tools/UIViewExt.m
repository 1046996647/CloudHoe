/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIViewExt.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) origin
{
	return self.frame.origin;
}

- (void) setOrigin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) size
{
	return self.frame.size;
}

- (void) setSize: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) height
{
	return self.frame.size.height;
}

- (void) setHeight: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void) setWidth: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat) top
{
	return self.frame.origin.y;
}

- (void) setTop: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat) left
{
	return self.frame.origin.x;
}

- (void) setLeft: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat) bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setBottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat) right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setRight: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;	
}

// UILabel
+ (UILabel *)labelWithframe:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment textColor:(NSString *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.text = text;
    label.textAlignment = textAlignment;
    //        _lab1.backgroundColor = [UIColor redColor];545354
    label.textColor = [UIColor colorWithHexString:color];
    
    return label;
}

// UIImageView
+ (UIImageView *)imgViewWithframe:(CGRect)frame icon:(NSString *)icon
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = [UIImage imageNamed:icon];
    imgView.clipsToBounds = YES;
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
    return imgView;
}

// UIButton
+ (UIButton *)buttonWithframe:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(NSString *)color backgroundColor:(NSString *)backColor normal:(NSString *)normal selected:(NSString *)selected
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:backColor];
    button.titleLabel.font = font;
    
    return button;
}

// UITextField
+ (UITextField *)textFieldWithframe:(CGRect)frame placeholder:(NSString *)placeholder font:(UIFont *)font leftView:(UIView *)leftView backgroundColor:(NSString *)backColor
{
    
    
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    
    tf.placeholder = placeholder;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.font = font;
//    tf.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = leftView;
    tf.backgroundColor = [UIColor colorWithHexString:backColor];
//    tf.returnKeyType = UIReturnKeySearch;


    return tf;
}

// UITableView
+ (UITableView *)tableViewWithframe:(CGRect)frame style:(UITableViewStyle)style
{
    UITableView *tableView = [[self alloc] initWithFrame:frame style:style];
    //        _tableView.scrollEnabled = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;// 滑动时收起键盘
    // UITableViewStyleGrouped：会影响第一headerSection的高度
    if (style == UITableViewStylePlain) {
        tableView.tableFooterView = [[UIView alloc] init];

    }
    tableView.backgroundColor = [UIColor clearColor];
    
    // 适配iOS11(iOS11后隐藏导航栏的MJRefresh下拉刷新控件会漏出来)
    if (@available(iOS 11.0, *)){
        
        [tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    return tableView;
}



// 在view中获取viewController
- (UIViewController *)viewController
{
    UIResponder *responder = self.nextResponder;
    while (![responder isKindOfClass:[UIViewController class]] && responder != nil) {
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}


@end
