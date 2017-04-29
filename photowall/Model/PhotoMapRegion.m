//
//  PhotoMapRegion.m
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoMapRegion.h"

@implementation PhotoMapRegion

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude andRadius:(double)radius {
	if (self = [super init]) {
		_latitude = latitude;
		_longitude = longitude;
		_radius = radius;
	}
	return self;
}

@end
