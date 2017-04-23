//
//  PhotoManager.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoManager.h"

#import "RestClient.h"

@implementation PhotoManager {
	RestClient* _client;
	NSMutableArray* _photos;
}

- (instancetype)initWithClient:(RestClient*)client {
	if (self = [super init]) {
		_client = client;
		_photos = [NSMutableArray new];
	}
	return self;
}

- (void)uploadPhoto:(NSData*)photo withHandler:(PhotoHandler)handler {
	
}

- (void)refreshWithHandler:(PhotoHandler)handler {
	
}

- (void)loadMoreWithHandler:(PhotoHandler)handler {
	
}

@end
