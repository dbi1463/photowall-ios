//
//  UIViewController+Mask.m
//  photowall
//
//  Created by Spirit on 4/23/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "UIViewController+Mask.h"

#import "UIView+Utils.h"

static UIView* maskView;

@implementation UIViewController (Mask)

- (void)showMask {
	if (maskView != nil) {
		return;
	}
	UIWindow* window = [[[UIApplication sharedApplication] windows] firstObject];
	maskView = [[[NSBundle mainBundle] loadNibNamed:@"MaskView" owner:nil options:nil] firstObject];
	[window addSubview:maskView fit:YES];
}

- (void)hideMask {
	[maskView removeFromSuperview];
	maskView = nil;
}

@end
