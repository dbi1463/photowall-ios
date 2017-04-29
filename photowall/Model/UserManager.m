//
//  UserManager.m
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "UserManager.h"

#import <MagicalRecord/MagicalRecord.h>

#import "User.h"
#import "RestClient.h"

NSString* const UsersSynchronizedNotificationName = @"UsersSynchronized";

@implementation UserManager {
	RestClient* _client;
	NSMutableDictionary* _users;
}

- (instancetype)initWithClient:(RestClient*)client {
	if ([super init]) {
		_client = client;
		_users = [NSMutableDictionary new];
		NSArray* localUsers = [User MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
		for (User* user in localUsers) {
			[_users setObject:user forKey:user.identifier];
		}
	}
	return self;
}

- (void)markAsFavorite:(User*)user {
	user.favoriteValue = YES;
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)unmarkFavorite:(User*)user {
	user.favoriteValue = NO;
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)synchronize {
	[[_client path:@"/profiles"] get:^(RestResponse* response) {
		if (response.succeeded) {
			[self updateProfiles:response.result];
		}
		else {
			NSLog(@"synchronization failed, due to %@", response.error);
		}
	}];
}

- (User*)getUser:(NSString*)userId {
	return _users[userId];
}

- (NSArray*)users {
	return _users.allValues;
}

#pragma mark - Private Methods
- (void)updateProfiles:(id)json {
	for (id userJson in json) {
		NSString* userId = [userJson objectForKey:@"id"];
		User* user = [self getUser:userId];
		if (user == nil) {
			user = [[User alloc] initWithJson:userJson];
			[_users setObject:user forKey:userId];
		}
		else {
			[user updateWithJson:userJson];
		}
	}
	NSLog(@"synchronized %@ users", @([json count]));
	[[NSNotificationCenter defaultCenter] postNotificationName:UsersSynchronizedNotificationName object:self userInfo:nil];
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

@end
