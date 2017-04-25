//
//  PhotoManager.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoManager.h"

#import "RestClient.h"
#import "LocationAwarePhotoUploadTask.h"

@implementation PhotoManager {
	RestClient* _client;
	NSMutableArray* _tasks;
	NSMutableArray* _photos;
}

#pragma mark - Initializers
- (instancetype)initWithClient:(RestClient*)client {
	if (self = [super init]) {
		_client = client;
		_photos = [NSMutableArray new];
		_tasks = [NSMutableArray new];
	}
	return self;
}

#pragma mark - Public Methods
- (void)uploadPhoto:(NSData*)photoData withHandler:(PhotoHandler)handler {
	LocationAwarePhotoUploadTask* task = [[LocationAwarePhotoUploadTask alloc] initWithData:photoData];
	[_tasks addObject:task];
	[task uploadWithClient:_client andHandler:^(NSError* error, NSArray* photos) {
		[_tasks removeObject:task];
		for (Photo* photo in photos) {
			[self addPhoto:photo];
		}
		if (handler != nil) {
			handler(error, photos);
		}
	}];
}

- (void)refreshWithHandler:(PhotoHandler)handler {
	[[_client path:@"/photos"] get:^(RestResponse* response) {
		if (response.succeeded) {
			for (id json in response.result) {
				[self addPhoto:[Photo photoFromJson:json]];
			}
			if (handler) {
				handler(nil, _photos);
			}
		}
		else {
			if (handler) {
				handler(response.error, nil);
			}
		}
	}];
}

- (void)loadMoreWithHandler:(PhotoHandler)handler {
	
}

- (NSArray*)photos {
	return _photos;
}

#pragma mark - Private Methods
- (void)addPhoto:(Photo*)photo {
	NSArray* results = [_photos filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", photo.identifier]];
	if (results.count > 0) {
		[_photos removeObjectsInArray:results];
	}
	[_photos addObject:photo];
}

@end
