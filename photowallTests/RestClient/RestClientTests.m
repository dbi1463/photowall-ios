//
//  RestClientTests.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "RestClient.h"
#import "RestRequest.h"

@interface RestClientTests : XCTestCase

@end

@implementation RestClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPath {
	id authenticator = [OCMockObject mockForProtocol:@protocol(RequestAuthenticator)];
	RestClient* client = [[RestClient alloc] initWithEndPoint:@"http://localhost/ws" andAuthenticator:authenticator];

	[[authenticator expect] authenticate:[OCMArg checkWithBlock:^BOOL(id obj) {
		return [@"http://localhost/ws/accounts" isEqualToString:((RestRequest*)obj).completeURL];
	}]];
	RestRequest* request = [client path:@"/accounts"];
	XCTAssertNotNil(request);
	[authenticator verify];
}

@end
