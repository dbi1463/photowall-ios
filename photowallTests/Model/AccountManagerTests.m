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
	self.client = [OCMockObject mockForClass:[RestClient class]];
	self.testee = [[AccountManager alloc] initWithClient:self.client];
}

- (void)tearDown {
//	[self.client verify];

	self.client = nil;
	self.testee = nil;

	[super tearDown];
}

@end
