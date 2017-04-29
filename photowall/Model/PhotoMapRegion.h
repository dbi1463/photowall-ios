//
//  PhotoMapRegion.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoMapRegion : NSObject

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude andRadius:(double)radius;

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) double radius;

@end
