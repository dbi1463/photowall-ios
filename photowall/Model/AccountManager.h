//
//  AuthenticationManager.h
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString* const UserDefaultsSelfIdKey;
FOUNDATION_EXPORT NSString* const KeyChainTokenKey;
FOUNDATION_EXPORT NSString* const KeyChainGroup;

@class User;
@class RestClient;

@protocol AuthenticationDelegate <NSObject>

- (void)authenticated:(User*)me;

- (void)authenticationFailed:(NSError*)error;

- (void)logouted;

- (void)logoutFailed:(NSError*)error;

@end

@protocol AccountEditDelegate <NSObject>

- (void)accountUpdated;

- (void)updateFailed:(NSError*)error;

@end

@interface AccountManager : NSObject

- (instancetype)initWithClient:(RestClient*)client;

- (void)changePortrait:(NSData*)portrait;

- (void)changeNickname:(NSString*)nickname;

- (void)registerWithEmail:(NSString*)email nickname:(NSString*)nickname andPassword:(NSString*)password;

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)password;

- (void)logout;

@property (nonatomic, readonly) User* me;
@property (nonatomic, readonly) BOOL logined;

@property (nonatomic, weak) id<AccountEditDelegate> editDelegate;
@property (nonatomic, weak) id<AuthenticationDelegate> authDelegate;

@end
