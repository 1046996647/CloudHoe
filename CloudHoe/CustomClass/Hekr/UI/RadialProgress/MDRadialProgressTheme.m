//
//  MDRadialProgressTheme.m
//  MDRadialProgress
//
//  Created by Info on 16/2/25.
//  Copyright © 2016年 skogt. All rights reserved.//

#import "MDRadialProgressTheme.h"


// The font size is automatically adapted but this is the maximum it will get
// unless overridden by the user.
static const int kMaxFontSize = 64;


@implementation MDRadialProgressTheme

+ (id)themeWithName:(const NSString *)themeName
{
	return [[MDRadialProgressTheme alloc] init];
}

+ (id)standardTheme
{
	return [MDRadialProgressTheme themeWithName:STANDARD_THEME];
}

- (id)init
{
	self = [super init];
	if (self) {
		// View
		self.onlineColor = [UIColor greenColor];
        self.authorizedColor = [UIColor greenColor];
        self.grantedColor = [UIColor redColor];
		self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		self.sliceDividerColor = [UIColor whiteColor];
		self.centerColor = [UIColor clearColor];
		self.thickness = 15.f;
		self.sliceDividerHidden = YES;
		self.sliceDividerThickness = 2;
		
		// Label
		self.labelColor = [UIColor blackColor];
		self.dropLabelShadow = YES;
		self.labelShadowColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
		self.labelShadowOffset = CGSizeMake(1, 1);
		self.font = [UIFont systemFontOfSize:kMaxFontSize];
	}
	
	return self;
}

@end
