//
//  RestRequestTests.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <Nocilla/Nocilla.h>

#import "RestRequest.h"
#import "RestResponse.h"

@interface RestRequestTests : XCTestCase

@end

@implementation RestRequestTests

- (void)setUp {
	[super setUp];
	[[LSNocilla sharedInstance] start];
}

- (void)tearDown {
	[super tearDown];
	[[LSNocilla sharedInstance] clearStubs];
	[[LSNocilla sharedInstance] stop];
}

- (void)testQuery {
	RestRequest* request = [[RestRequest alloc] initWithURL:@"http://localhost:4567/ws/accounts"];
	XCTAssert(request == [request query:@"nickname" withValue:@"Spirit Tu"]);
	XCTAssertEqual(1, [request.queryParameters count]);
	XCTAssertEqual(@"Spirit Tu", request.queryParameters[@"nickname"]);
	XCTAssertEqualObjects(@"http://localhost:4567/ws/accounts?nickname=Spirit%20Tu", request.completeURL);
}

- (void)testResolve {
	RestRequest* request = [[RestRequest alloc] initWithURL:@"http://localhost:4567/ws/accounts/{id}"];
	XCTAssert(request == [request resolve:@"id" withValue:@"2d2b1f79-940c-45c1-bdd8-1ed539aad2ab"]);
	XCTAssertEqual(1, [request.pathParameters count]);
	XCTAssertEqual(@"2d2b1f79-940c-45c1-bdd8-1ed539aad2ab", request.pathParameters[@"id"]);
	XCTAssertEqualObjects(@"http://localhost:4567/ws/accounts/2d2b1f79-940c-45c1-bdd8-1ed539aad2ab", request.completeURL);
}

- (void)testHader {
	RestRequest* request = [[RestRequest alloc] initWithURL:@"http://localhost:4567/ws/authentications"];
	XCTAssert(request == [request setValue:@"2d2b1f79-940c-45c1-bdd8-1ed539aad2aa" forHeader:@"Auth-Token"]);
	XCTAssertEqual(1, [request.headers count]);
	XCTAssertEqual(@"2d2b1f79-940c-45c1-bdd8-1ed539aad2aa", request.headers[@"Auth-Token"]);
}

- (void)testGetSucceeded {
	// set up mock server
	stubRequest(@"GET", @"http://localhost/ws/profiles")
		.withHeader(@"Auth-Token", @"aaa")
		.andReturn(200)
		.withBody(@"{\"data\": [{\"id\":\"2d2b1f79-940c-45c1-bdd8-1ed539aad2aa\",\"nickname\":\"Spirit Tu\"}]}")
		.withHeader(@"Content-Type", @"application/json");

	XCTestExpectation* expectation = [self expectationWithDescription:@"wait for get result"];
	RestRequest* request = [[RestRequest alloc] initWithURL:@"http://localhost/ws/profiles"];
	[request setValue:@"aaa" forHeader:@"Auth-Token"];
	[request get:^(RestResponse* response) {
		if (response.succeeded) {
			id json = response.result;
			XCTAssertEqual(1, [json count]);
			id profile = [json objectAtIndex:0];
			XCTAssertEqualObjects(@"Spirit Tu", [profile objectForKey:@"nickname"]);
			[expectation fulfill];
		}
	}];
	[self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
		if (error != nil) {
			XCTFail(@"handler is not called as expected");
		}
	}];
}

- (void)testPostFailed {
	id body = @{
		@"email": @"aaa@bbb.ccc",
		@"nickname": @"AAA",
		@"password": @"badpassword"
	};
	// set up mock server
	stubRequest(@"POST", @"http://localhost/ws/accounts")
		.withHeader(@"Content-Length", @"81")
		.withBody([NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil])
		.andReturn(400)
		.withBody(@"{\"error\":{\"code\":-1,\"message\":\"the email has been used!\"}}")
		.withHeader(@"Content-Type", @"application/json");

	XCTestExpectation* expectation = [self expectationWithDescription:@"wait for post request"];
	RestRequest* request = [[RestRequest alloc] initWithURL:@"http://localhost/ws/accounts"];
	[request post:body withHandler:^(RestResponse* response) {
		if (!response.succeeded) {
			XCTAssertEqual(-1, response.error.code);
			XCTAssertEqual(400, response.statusCode);
			XCTAssertEqualObjects(@"the email has been used!", response.error.domain);
			[expectation fulfill];
		}
	}];
	[self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
		if (error != nil) {
			XCTFail(@"handler is not called as expected");
		}
	}];
}

@end
