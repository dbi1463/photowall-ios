//
//  AuthenticationManager.m
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "AccountManager.h"

#import <NitroKeychain/TNTKeychain.h>
#import <MagicalRecord/MagicalRecord.h>

#import "User.h"
#import "RestClient.h"
#import "NSString+Utils.h"

NSString* const UserDefaultsSelfIdKey = @"com.picowork.photowall.selfId";
NSString* const KeyChainTokenKey = @"photowall.token";
NSString* const KeyChainGroup = @"com.picowork";

@implementation AccountManager {
	NSString* _selfId;
	RestClient* _client;
}

- (instancetype)initWithClient:(RestClient*)client {
	if (self = [super init]) {
		_client = client;
		_selfId = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsSelfIdKey];
		if ([NSString notEmpty:_selfId]) {
			NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@", _selfId];
			_me = [User MR_findFirstWithPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
		}
	}
	return self;
}

- (void)changePortrait:(NSData*)portrait {
	[[_client path:@"/portraits/mine"] upload:portrait withMethod:@"POST" andHandler:^(RestResponse* response) {
		if (response.succeeded) {
			[self.editDelegate accountUpdated];
			_me.lastUpdated = [NSDate new];
		}
		else {
			[self.editDelegate updateFailed:response.error];
		}
	}];
}

- (void)changeNickname:(NSString*)nickname {
	id content = @{
		@"nickname": nickname
	};
	[[_client path:@"/profiles/mine"] put:content withHandler:[self updateNicknameIfSucceeded:nickname]];
}

- (void)registerWithEmail:(NSString*)email nickname:(NSString*)nickname andPassword:(NSString*)password {
	id content = @{
		@"email": email,
		@"nickname": nickname,
		@"password": [password sha1]
	};
	RestRequest* request = [_client path:@"/accounts"];
	[request post:content withHandler:[self saveAuthIfSucceeded]];
}

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)password {
	NSString* encodedInfo = [[NSString stringWithFormat:@"%@:%@", email, [password sha1]] base64];
	NSString* basicAuth = [NSString stringWithFormat:@"Basic %@", encodedInfo];
	[[[_client path:@"/authentications"] setValue:basicAuth forHeader:@"Authorization"] post:nil withHandler:[self saveAuthIfSucceeded]];
}

- (void)logout {
	[[_client path:@"/authentications/mine"] delete:[self removeAuthIfSucceeded]];
	[User MR_truncateAll];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (BOOL)logined {
	NSString* token = [TNTKeychain load:KeyChainTokenKey];
	return token != nil;
}

#pragma mark - Code Blocks
- (ResponseHandler)saveAuthIfSucceeded {
	return ^(RestResponse* response) {
		if (response.succeeded) {
			NSString* token = response.headers[@"Auth-Token"];
			[TNTKeychain save:KeyChainTokenKey data:token accessGroup:KeyChainGroup];
			_me = [[User alloc] initWithJson:response.result];
			[[NSManagedObjectContext MR_defaultContext] save:nil];
			[[NSUserDefaults standardUserDefaults] setObject:_me.identifier forKey:UserDefaultsSelfIdKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self.authDelegate authenticated:_me];
		}
		else {
			[self.authDelegate authenticationFailed:response.error];
		}
	};
}

- (ResponseHandler)removeAuthIfSucceeded {
	return ^(RestResponse* response) {
		if (response.succeeded) {
			[TNTKeychain delete:KeyChainTokenKey accessGroup:KeyChainGroup];
			if (_me != nil) {
				[[NSManagedObjectContext MR_defaultContext] deleteObject:_me];
			}
			[[NSManagedObjectContext MR_defaultContext] save:nil];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:UserDefaultsSelfIdKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self.authDelegate logouted];
		}
		else {
			[self.authDelegate logoutFailed:response.error];
		}
	};
}

- (ResponseHandler)updateNicknameIfSucceeded:(NSString*)nickname {
	return ^(RestResponse* response) {
		if (response.succeeded) {
			_me.nickname = nickname;
			_me.lastUpdated = [NSDate new];
			[[NSManagedObjectContext MR_defaultContext] save:nil];
			[self.editDelegate accountUpdated];
		}
		else {
			[self.editDelegate updateFailed:response.error];
		}
	};
}

@end
