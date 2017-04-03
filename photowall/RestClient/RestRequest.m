//
//  RestRequest.m
//  photowall
//
//  Created by Spirit on 3/25/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "RestRequest.h"

#import <AFNetworking/AFNetworking.h>

#import "RestResponse.h"

@interface RestRequest()

@property NSURLSessionDataTask* dataTask;
@property AFURLSessionManager* sessionManager;

@end

@implementation RestRequest {
	id _content;
	NSMutableDictionary* _headers;
	NSMutableDictionary* _pathParameters;
	NSMutableDictionary* _queryParameters;
}

#pragma mark - Initializers
- (instancetype)initWithURL:(NSString*)url {
	if (self = [super init]) {
		_url = url;
		_headers = [NSMutableDictionary new];
		_pathParameters = [NSMutableDictionary new];
		_queryParameters = [NSMutableDictionary new];
	}
	return self;
}

#pragma mark - Public Methods
- (RestRequest*)query:(NSString*)key withValue:(NSString*)value {
	[_queryParameters setObject:value forKey:key];
	return self;
}

- (RestRequest*)resolve:(NSString*)key withValue:(NSString*)value {
	[_pathParameters setObject:value forKey:key];
	return self;
}

- (RestRequest*)setValue:(NSString*)value forHeader:(NSString*)header {
	[_headers setObject:value forKey:header];
	return self;
}

- (void)post:(id)content withHandler:(ResponseHandler)handler {
	_content = content;
	[self invoke:@"POST" withHandler:handler];
}

- (void)put:(id)content withHandler:(ResponseHandler)handler {
	_content = content;
	[self invoke:@"PUT" withHandler:handler];
}

- (void)get:(ResponseHandler)handler {
	[self invoke:@"GET" withHandler:handler];
}

- (void)delete:(ResponseHandler)handler {
	[self invoke:@"DELETE" withHandler:handler];
}

- (void)upload:(NSData*)data withMethod:(NSString*)method andHandler:(ResponseHandler)handler {
	NSMutableURLRequest* request = [self requestWithMethod:method];
	[[[self session] uploadTaskWithRequest:request fromData:data progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
		if (handler != nil) {
			handler([[RestResponse alloc] initWithRequest:self rawResponse:response andResponseObject:responseObject]);
		}
	}] resume];
}

#pragma mark - Property Getters
- (NSDictionary*)headers {
	return _headers;
}

- (NSDictionary*)pathParameters {
	return _pathParameters;
}

- (NSDictionary*)queryParameters {
	return _queryParameters;
}

- (NSString*)completeURL {
	return [self appendQueryParameter:[self parameterResolvedURL]];
}

#pragma mark - Private Methods
- (void)invoke:(NSString*)method withHandler:(ResponseHandler)handler {
	NSMutableURLRequest* request = [self requestWithMethod:method];
	[[[self session] dataTaskWithRequest:request completionHandler:^(NSURLResponse* _Nonnull response, id  _Nullable responseObject, NSError* _Nullable error) {
		if (handler != nil) {
			handler([[RestResponse alloc] initWithRequest:self rawResponse:response andResponseObject:responseObject]);
		}
	}] resume];
}

- (NSMutableURLRequest*)requestWithMethod:(NSString*)method {
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.completeURL]];
	request.HTTPMethod = method;
	if (_content != nil) {
		request.HTTPBody = [NSJSONSerialization dataWithJSONObject:_content options:NSJSONWritingPrettyPrinted error:nil];
	}
	for (NSString* key in self.headers) {
		[request setValue:self.headers[key] forHTTPHeaderField:key];
	}
	return request;
}

- (AFURLSessionManager*)session {
	if (self.sessionManager != nil) {
		return self.sessionManager;
	}
	NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	return self.sessionManager;
}

- (NSString*)parameterResolvedURL {
	NSString* result = [NSString stringWithString:self.url];
	for (NSString* key in self.pathParameters.allKeys) {
		NSString* name = [NSString stringWithFormat:@"{%@}", key];
		NSString* value = [self.pathParameters[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
		result = [result stringByReplacingOccurrencesOfString:name withString:value];
	}
	return result;
}

- (NSString*)appendQueryParameter:(NSString*)url {
	if (self.queryParameters.count == 0) {
		return url;
	}
	NSMutableArray* parts = [NSMutableArray new];
	for (NSString* key in self.queryParameters.allKeys) {
		NSString* name = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		NSString* value = [self.queryParameters[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		[parts addObject:[NSString stringWithFormat:@"%@=%@", name, value]];
	}
	return [NSString stringWithFormat:@"%@?%@", url, [parts componentsJoinedByString:@"&"]];
}

@end
