//
//  UIColor+Defaults.m
//  photowall
//
//  Created by Spirit on 4/11/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "UIColor+Defaults.h"

@implementation UIColor (Defaults)

+ (instancetype)main {
	return [UIColor fromRed:35 green:10 blue:95 andAlpha:1.0];
}

+ (instancetype)hint {
	return [UIColor fromRed:113 green:15 blue:18 andAlpha:1.0];
}

+ (instancetype)primaryAuxiliary {
	return [UIColor fromRed:108 green:91 blue:169 andAlpha:1.0];
}

+ (instancetype)secondaryAuxiliary {
	return [UIColor fromRed:231 green:223 blue:235 andAlpha:1.0];
}

+ (instancetype)thirdlyAuxiliary {
	return [UIColor fromRed:64 green:46 blue:146 andAlpha:1.0];
}

+ (instancetype)fromRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue andAlpha:(CGFloat)alpha {
	CGFloat redFloat = @(red).floatValue / 255.0;
	CGFloat greenFloat = @(green).floatValue / 255.0;
	CGFloat blueFloat = @(blue).floatValue / 255.0;
	return [UIColor colorWithRed:redFloat green:greenFloat blue:blueFloat alpha:alpha];
}

@end
