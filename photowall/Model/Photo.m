//
//  Photo.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "Photo.h"

@implementation PhotoLocation

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude {
	if (self = [super init]) {
		_latitude = latitude;
		_longitude = longitude;
	}
	return self;
}

@end

@implementation Photo

- (NSString*)fullSizeImagePath {
	return [NSString stringWithFormat:@"/photos/%@", self.identifier];
}

- (NSString*)thumbnailPath {
	return [NSString stringWithFormat:@"/photos/%@/thumbnail", self.identifier];
}

@end

@implementation Photo (JSON)

+ (instancetype)photoFromJson:(id)json {
	NSString* identifier = [json objectForKey:@"id"];
	NSString* posterId = [json objectForKey:@"posterId"];
	NSDate* timestamp = [NSDate dateWithTimeIntervalSince1970:[[json objectForKey:@"timestamp"] doubleValue] / 1000];
	PhotoLocation* location = nil;
	id locationJson = [json objectForKey:@"location"];
	if (locationJson != nil) {
		double latitude = [[locationJson objectForKey:@"latitude"] doubleValue];
		double longitude = [[locationJson objectForKey:@"longitude"] doubleValue];
		location = [[PhotoLocation alloc] initWithLatitude:latitude andLongitude:longitude];
	}
	return [[Photo alloc] initWithIdentifier:identifier posterId:posterId timestamp:timestamp andLocation:location];
}

- (instancetype)initWithIdentifier:(NSString*)identifier posterId:(NSString*)posterId timestamp:(NSDate*)timestamp andLocation:(PhotoLocation*)location {
	if (self = [super init]) {
		_identifier = identifier;
		_posterId = posterId;
		_timestamp = timestamp;
		_location = location;
	}
	return self;
}

@end
