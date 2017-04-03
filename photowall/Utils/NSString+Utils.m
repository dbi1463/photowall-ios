//
//  NSString+Utils.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "NSString+Utils.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Digest)

- (NSString*)sha1 {
	NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, data.length, digest);
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x", digest[i]];
	}
	return output;
}

- (NSString*)base64 {
	NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
	return [data base64EncodedStringWithOptions:0];
}

+ (BOOL)notEmpty:(NSString*)string {
	return string == nil? NO : [string length] > 0;
}

@end
