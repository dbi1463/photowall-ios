//
//  PhotoMapRegion+Utils.m
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoMapRegion+Utils.h"

@implementation PhotoMapRegion (Utils)

+ (PhotoMapRegion*)fromMKCoordinateRegion:(MKCoordinateRegion)region {
	double latitude = region.center.latitude;
	double longitude = region.center.longitude;
	return [[PhotoMapRegion alloc] initWithLatitude:latitude longitude:longitude andRadius:0];
}

- (MKCoordinateRegion)toMKCoordinateRegion {
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.latitude, self.longitude);
	return MKCoordinateRegionMake(center, MKCoordinateSpanMake(0, 0));
}

@end
