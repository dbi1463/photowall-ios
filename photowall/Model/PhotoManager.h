//
//  PhotoManager.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "Photo.h"

@class RestClient;

typedef void(^PhotoHandler)(NSError* error, NSArray* photos);

@interface PhotoManager : NSObject<CLLocationManagerDelegate>

- (instancetype)initWithClient:(RestClient*)client;

- (void)uploadPhoto:(NSData*)photo withHandler:(PhotoHandler)handler;

- (void)refreshWithHandler:(PhotoHandler)handler;

- (void)loadMoreWithHandler:(PhotoHandler)handler;

@property (nonatomic, readonly) NSArray* photos;

@end
