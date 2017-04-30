//
//  PhotoAnnotation.m
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoAnnotation.h"

#import "Photo.h"

@implementation PhotoAnnotation

- (CLLocationCoordinate2D)coordinate {
	return CLLocationCoordinate2DMake(self.photo.location.latitude, self.photo.location.longitude);
}

- (NSString*)title {
	return self.poster;
}

@end
