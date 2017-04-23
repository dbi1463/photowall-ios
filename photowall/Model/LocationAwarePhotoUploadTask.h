//
//  LocationAwarePhotoUploadTask.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "PhotoManager.h"

@interface LocationAwarePhotoUploadTask : NSObject<CLLocationManagerDelegate>

- (instancetype)initWithData:(NSData*)data;

- (void)uploadWithClient:(RestClient*)client andHandler:(PhotoHandler)handler;

@end
