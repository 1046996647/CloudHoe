//
// MDRadialProgressView.m
// MDRadialProgress
//
//
//  Created by Info on 16/2/25.
//  Copyright © 2016年 skogt. All rights reserved.


#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"


@interface MDRadialProgressView ()

// Padding from the view bounds to the outer circumference of the view.
// Useful because at times the circle may appear "cut" by one or two pixels
// since it's drawing over the view bounds.
@property (assign, nonatomic) NSUInteger internalPadding;

@end


@implementation MDRadialProgressView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:theme];
    }
    return self;
}

- (void)awakeFromNib
{
    [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
}

- (void)dealloc {
    [self removeObserver:self.label forKeyPath:keyThickness];
}

- (void)internalInitWithTheme:(MDRadialProgressTheme *)theme
{
    // Default values for public properties
	self.progressTotal = 1;
	self.onlinceCounter = 0;
    self.authorizedCounter = 0;
    self.grantedCounter = 0;
	self.startingSlice = 1;
    self.clockwise = NO;
	
	// Use standard theme by default
	self.theme = theme;
	
	// Init the progress label, even if not visible.
	self.label = [[MDRadialProgressLabel alloc] initWithFrame:self.bounds andTheme:self.theme];
	[self addSubview:self.label];
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	
	// Important to avoid showing artifacts
	self.backgroundColor = [UIColor clearColor];
	
	// Register the progress label for changes in the thickness so that it can be repositioned.
	[self addObserver:self.label forKeyPath:keyThickness options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Setters

- (void)setOnlinceCounter:(NSUInteger)onlinceCounter
{
	_onlinceCounter = onlinceCounter;
//	[self notifyProgressChange];
	[self setNeedsDisplay];
}

- (void)setProgressTotal:(NSUInteger)progressTotal
{
	_progressTotal = progressTotal;
//	[self notifyProgressChange];
	[self setNeedsDisplay];
}

- (void)setAuthorizedCounter:(NSUInteger)authorizedCounter
{
    _authorizedCounter = authorizedCounter;
    [self setNeedsDisplay];
}
- (void)setGrantedCounter:(NSUInteger)grantedCounter
{
    _grantedCounter = grantedCounter;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGSize viewSize = self.bounds.size;
	CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
	
    // Draw the slices.
	CGFloat radius = viewSize.width / 2 - self.internalPadding;
    [self drawSlices:self.progressTotal
		   completed:self.onlinceCounter
			  radius:radius
			  center:center
		   inContext:contextRef];
	
	// Draw the slice separators.
	[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(CGFloat)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
    NSUInteger startingSlice = self.startingSlice -1;
    
	if (!self.theme.sliceDividerHidden && self.theme.sliceDividerThickness > 0) {
		// Draw one arc at a time.
        
        CGFloat sliceAngle = (2 * M_PI ) / slicesCount;
        for (int i =0; i < slicesCount; i++) {
            CGFloat startValue = (sliceAngle * i) + sliceAngle * startingSlice;
            CGFloat startAngle = 0.0f, endAngle = 0.0f;
            if (self.clockwise) {
                startAngle = - M_PI_2 + startValue;
				endAngle = startAngle + sliceAngle;
            } else {
                startAngle = - M_PI_2 - startValue;
				endAngle = startAngle - sliceAngle;
            }
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius,
							startAngle, endAngle, cgClockwise);
            
            CGColorRef color = self.theme.incompletedColor.CGColor;
            
            if (i < slicesCompleted) {
                color = self.theme.onlineColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    } else {
		// Draw just two arcs, one for the completed slices and one for the
		// uncompleted ones.
        CGFloat originAngle = 0.0f, endAngle = 0.0f;
        CGFloat sliceAngle = (2 * M_PI) / self.progressTotal;
        CGFloat startingAngle = sliceAngle * startingSlice;
        
        if (!self.progressTotal) {
            originAngle = -M_PI_2;
            endAngle = originAngle + 2 * M_PI;
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGFloat startAngle = endAngle;
            endAngle = originAngle;
            CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
            CGColorRef color = self.theme.incompletedColor.CGColor;
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
            return;
        }
        
        //在线，(被授权，已授权)
        if ((self.onlinceCounter && !self.authorizedCounter && !self.grantedCounter) || (!self.onlinceCounter && !self.authorizedCounter && !self.grantedCounter)) { //在线设备
            CGFloat progressAngle = sliceAngle * self.onlinceCounter;
            
            if (self.onlinceCounter == 0) {
                originAngle = -M_PI_2;
                endAngle = originAngle + 2 * M_PI;
            } else {
                if (self.clockwise) {
                    originAngle = -M_PI_2 + startingAngle;
                    endAngle = originAngle + progressAngle;
                } else {
                    originAngle = -M_PI_2 - startingAngle;
                    endAngle = originAngle - progressAngle;
                }
            }
            
            // Draw the arcs grouped instead of individually to avoid
            // artifacts between one slice and another.
            if (!self.onlinceCounter) {
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, center.x, center.y);
                CGFloat startAngle = endAngle;
                endAngle = originAngle;
                CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
                CGColorRef color = self.theme.incompletedColor.CGColor;
                CGContextSetFillColorWithColor(context, color);
                CGContextFillPath(context);
            }
            else {
                // Completed slices.
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, center.x, center.y);
                CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, cgClockwise);
                CGColorRef color = self.theme.onlineColor.CGColor;
                CGContextSetFillColorWithColor(context, color);
                CGContextFillPath(context);
                
                if (self.onlinceCounter < self.progressTotal) {
                    // Incompleted slices
                    CGContextBeginPath(context);
                    CGContextMoveToPoint(context, center.x, center.y);
                    CGFloat startAngle = endAngle;
                    endAngle = originAngle;
                    CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
                    color = self.theme.incompletedColor.CGColor;
                    CGContextSetFillColorWithColor(context, color);
                    CGContextFillPath(context);
                }
            }
        }
        else { //被授权，已授权
            CGFloat OriAngle;
            
//            if (self.onlinceCounter == 0) {
//                originAngle = -M_PI_2;
//                endAngle = originAngle + 2 * M_PI;
//                OriAngle = originAngle;
//            } else {
                if (self.clockwise) {
                    originAngle = -M_PI_2 + startingAngle;
                    OriAngle = originAngle;
                } else {
                    originAngle = -M_PI_2 - startingAngle;
                    OriAngle = originAngle;
                }
//            }
            
            // 被授权设备.
            if (self.authorizedCounter) {
                CGFloat progressAuthAngle = sliceAngle * self.authorizedCounter;
                if (self.clockwise) {
                    endAngle = originAngle + progressAuthAngle;
                }
                else {
                    endAngle = originAngle - progressAuthAngle;
                }
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, center.x, center.y);
                CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, cgClockwise);
                CGColorRef authorizedColor = self.theme.authorizedColor.CGColor;
                CGContextSetFillColorWithColor(context, authorizedColor);
                CGContextFillPath(context);
            }
            
            //已授权设备
            if (self.grantedCounter) {
                CGFloat progressGrantedAngle = sliceAngle * self.grantedCounter;
                originAngle = self.authorizedCounter ? endAngle : OriAngle;
                if (self.clockwise) {
                    endAngle = originAngle + progressGrantedAngle;
                }
                else {
                    endAngle = originAngle - progressGrantedAngle;
                }
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, center.x, center.y);
                CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, cgClockwise);
                CGColorRef grantedColor = self.theme.grantedColor.CGColor;
                CGContextSetFillColorWithColor(context, grantedColor);
                CGContextFillPath(context);
            }
            
            
            if (self.authorizedCounter + self.grantedCounter < self.progressTotal) { //绘制未完成的
                // Incompleted slices
                CGContextBeginPath(context);
                CGContextMoveToPoint(context, center.x, center.y);
                CGFloat startAngle = endAngle;
                endAngle = OriAngle;
                CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, endAngle, cgClockwise);
                CGColorRef incompletedColor = self.theme.incompletedColor.CGColor;
                CGContextSetFillColorWithColor(context, incompletedColor);
                CGContextFillPath(context);
            }

        }
	}
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int outerDiameter = viewSize.width;
    float outerRadius = outerDiameter / 2 - self.internalPadding;
    int innerDiameter = outerDiameter - self.theme.thickness;
    float innerRadius = innerDiameter / 2;
    
    if (! self.theme.sliceDividerHidden) {
        NSUInteger sliceCount = self.progressTotal;
        float sliceAngle = (2 * M_PI) / sliceCount;
        CGContextSetLineWidth(contextRef, self.theme.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
        for (int i = 0; i < sliceCount; i++) {
            double startAngle = sliceAngle * i - M_PI_2;
			double endAngle = sliceAngle * (i + 1) - M_PI_2;
            
			CGContextBeginPath(contextRef);
			CGContextMoveToPoint(contextRef, center.x, center.y);
			
			// Draw the outer arc
			CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
			// Draw the inner arc. The separator line is drawn automatically when moving from
			// the point where the outer arc ended to the point where the inner arc starts.
			CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
			
			CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
			CGContextStrokePath(contextRef);
        }
    }
}

- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	CGFloat innerDiameter = viewSize.width - self.theme.thickness;
    float innerRadius = innerDiameter / 2;
	
	CGContextSetLineWidth(contextRef, self.theme.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.theme.centerColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}

# pragma mark - Accessibility

- (UIAccessibilityTraits)accessibilityTraits
{
	return [super accessibilityTraits] | UIAccessibilityTraitUpdatesFrequently;
}

# pragma mark - Notifications

- (void)notifyProgressChange
{
	// Update the accessibilityValue and the progressSummaryView text.
	float percentageCompleted = (100.0f / self.progressTotal) * self.onlinceCounter;
	
	self.accessibilityValue = [NSString stringWithFormat:@"%.2f", percentageCompleted];
	self.label.text = [NSString stringWithFormat:@"%.0f", percentageCompleted]; //不显示比例
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}

@end
