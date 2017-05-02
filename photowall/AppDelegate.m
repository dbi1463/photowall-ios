//
//  AppDelegate.m
//  photowall
//
//  Created by Spirit on 3/25/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "AppDelegate.h"

#import <MagicalRecord/MagicalRecord.h>

#import "RestClient.h"
#import "KeyChainSecuredAuthenticator.h"

#import "RootViewController.h"
#import "LoginViewController.h"

#import "UIViewController+Mask.h"

@implementation AppDelegate {
	RestClient* _client;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	[MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"photowall"];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	KeyChainSecuredAuthenticator* authenticator = [KeyChainSecuredAuthenticator new];
	_client = [[RestClient alloc] initWithAuthenticator:authenticator];
	[self initializeManagers];
	if (self.accountManager.logined) {
		[self showRootView];
	}
	else {
		[self showLoginView];
	}
	[self.window makeKeyAndVisible];

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
	[MagicalRecord cleanUp];
}

#pragma mark - AuthenticationDelegate
- (void)logouted {
	[self.window.rootViewController hideMask];
	[self initializeManagers];
	[self showLoginView];
}

- (void)logoutFailed:(NSError *)error {
	// do nothing
	[self.window.rootViewController hideMask];
}

- (void)authenticated:(User*)me {
	NSLog(@"%@ authenticated", me);
	[self.window.rootViewController hideMask];
	[self showRootView];
}

- (void)authenticationFailed:(NSError*)error {
	[self.window.rootViewController hideMask];
	NSString* message = @"unable to login/register, please try again later";
	UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
	[controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
	[self.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)showLoginView {
	LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil];
	loginController.accountManager = self.accountManager;
	[self.window setRootViewController:loginController];
}

- (void)showRootView {
	RootViewController* root = [[RootViewController alloc] initWithNibName:@"RootView" bundle:nil];
	root.userManager = self.userManager;
	root.photoManager = self.photoManager;
	root.accountManager = self.accountManager;
	UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:root];
	[self.window setRootViewController:navigation];
	[self.userManager synchronize];
}

- (void)initializeManagers {
	self.userManager = [[UserManager alloc] initWithClient:_client];
	self.photoManager = [[PhotoManager alloc] initWithClient:_client];
	self.accountManager = [[AccountManager alloc] initWithClient:_client];
	self.accountManager.authDelegate = self;
}

@end
