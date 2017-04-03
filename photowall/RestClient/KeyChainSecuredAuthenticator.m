//
//  KeyChainSecuredAuthenticator.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "KeyChainSecuredAuthenticator.h"

#import <NitroKeychain/TNTKeychain.h>

#import "RestRequest.h"
#import "AccountManager.h"

@implementation KeyChainSecuredAuthenticator

- (void)authenticate:(RestRequest*)request {
	NSString* token = [TNTKeychain load:KeyChainTokenKey accessGroup:KeyChainGroup];
	if (token != nil) {
		[request setValue:token forHeader:@"Auth-Token"];
	}
}

@end
