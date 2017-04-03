//
//  NSStringUtilsTests.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSString+Utils.h"

@interface NSStringDigestTests : XCTestCase

@end

@implementation NSStringDigestTests

- (void)testSHA1 {
	NSString* nilString = nil;
	XCTAssertNil([nilString sha1]);
	XCTAssertEqualObjects(@"60e66ead100defc917a7eca34e38e269a8174f4e", [@"message to digest" sha1]);
}

- (void)testBase64 {
	NSString* nilString = nil;
	XCTAssertNil([nilString base64]);
	XCTAssertEqualObjects(@"dGhpcyBpcyB0aGUgbWVzc2FnZSB0byBlbmNvZGU=", [@"this is the message to encode" base64]);
}

- (void)testNotEmpty {
	XCTAssertFalse([NSString notEmpty:nil]);
	XCTAssertFalse([NSString notEmpty:@""]);
	XCTAssertTrue([NSString notEmpty:@" "]);
	XCTAssertTrue([NSString notEmpty:@"a"]);
}

@end
