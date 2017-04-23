//
//  AppDelegate.h
//  photowall
//
//  Created by Spirit on 3/25/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "UserManager.h"
#import "PhotoManager.h"
#import "AccountManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AuthenticationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UserManager* userManager;
@property (strong, nonatomic) PhotoManager* photoManager;
@property (strong, nonatomic) AccountManager* accountManager;

@end

