//
//  UserManager.h
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@class RestClient;

FOUNDATION_EXPORT NSString* const UsersSynchronizedNotificationName;

@interface UserManager : NSObject

- (instancetype)initWithClient:(RestClient*)client;

- (User*)getUser:(NSString*)userId;

- (void)markAsFavorite:(User*)user;

- (void)unmarkFavorite:(User*)user;

- (void)synchronize;

@property (readonly) NSArray* users;

@end
