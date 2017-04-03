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

@interface UserManager : NSObject

- (instancetype)initWithClient:(RestClient*)client;

- (User*)getUser:(NSString*)userId;

- (void)synchronize;

@property (readonly) NSArray* users;

@end
