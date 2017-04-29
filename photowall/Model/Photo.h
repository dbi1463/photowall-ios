//
//  Photo.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoLocation : NSObject

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

@end

@interface Photo : NSObject

@property (nonatomic, readonly) NSString* posterId;
@property (nonatomic, readonly) NSString* identifier;
@property (nonatomic, readonly) NSDate* timestamp;
@property (nonatomic, readonly) PhotoLocation* location;

@property (nonatomic, readonly) NSString* thumbnailPath;
@property (nonatomic, readonly) NSString* fullSizeImagePath;

@end

@interface Photo (JSON)

+ (instancetype)photoFromJson:(id)json;

@end
