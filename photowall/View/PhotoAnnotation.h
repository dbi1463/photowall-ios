//
//  PhotoAnnotation.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Photo;

@interface PhotoAnnotation : NSObject<MKAnnotation>

@property (nonatomic) NSString* poster;

@property (weak, nonatomic) Photo* photo;

@end
