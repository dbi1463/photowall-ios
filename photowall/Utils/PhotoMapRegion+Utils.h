//
//  PhotoMapRegion+Utils.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoMapRegion.h"

#import <MapKit/MapKit.h>

@interface PhotoMapRegion (Utils)

+ (PhotoMapRegion*)fromMKCoordinateRegion:(MKCoordinateRegion)region;

- (MKCoordinateRegion)toMKCoordinateRegion;

@end
