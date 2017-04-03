//
//  AccountManagerTests.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "RestClient.h"
#import "AccountManager.h"

@interface AccountManagerTests : XCTestCase

@property (nonatomic) id client;
@property (nonatomic) AccountManager* testee;

@end

@implementation AccountManagerTests

- (void)setUp {
    [super setUp];
	self.client = [[RestClient alloc] initWithEndPoint:@"http://localhost:4567/ws"];
	self.testee = [[AccountManager alloc] initWithClient:self.client];
}

- (void)tearDown {
//	[self.client verify];

	self.client = nil;
	self.testee = nil;

	[super tearDown];
}

- (void)testRegister {
	id delegate = [OCMockObject mockForProtocol:@protocol(AuthenticationDelegate)];
	self.testee.authDelegate = delegate;
	[self.testee registerWithEmail:@"xyz@aaa.ccc" nickname:@"XYZ" andPassword:@"xyzaabbb"];
	XCTestExpectation* expection = [self expectationWithDescription:@"wait for network"];
	[self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
		
	}];
}

@end
