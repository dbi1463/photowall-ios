//
//  RestClient.m
//  photowall
//
//  Created by Spirit on 3/25/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "RestClient.h"

#import "RestRequest.h"

NSString* const DefaultEndPoint = @"http://localhost:4567/ws";

@implementation RestClient {
	NSString* _endPoint;
	id<RequestAuthenticator> _authenticator;
}

#pragma mark - Initializers
- (instancetype)initWithEndPoint:(NSString*)endPoint {
	return [self initWithEndPoint:endPoint andAuthenticator:nil];
}

- (instancetype)initWithEndPoint:(NSString*)endPoint andAuthenticator:(id<RequestAuthenticator>)authenticator {
	if (self = [super init]) {
		_endPoint = endPoint;
		_authenticator = authenticator;
	}
	return self;
}

#pragma mark - Public Methods
- (RestRequest*)path:(NSString*)path {
	NSString* url = [NSString stringWithFormat:@"%@%@", _endPoint, path];
	RestRequest* request = [[RestRequest alloc] initWithURL:url];
	[_authenticator authenticate:request];
	return request;
}

@end
