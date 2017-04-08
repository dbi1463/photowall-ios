//
//  RootViewController.h
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserManager;
@class AccountManager;

@interface RootViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* viewContainer;

@property (weak, nonatomic) IBOutlet UIButton* gridTabButton;
@property (weak, nonatomic) IBOutlet UIButton* profileTabButton;
@property (weak, nonatomic) IBOutlet UIButton* allPhotoTabButton;
@property (weak, nonatomic) IBOutlet UIButton* photoMapTabButton;
@property (weak, nonatomic) IBOutlet UIButton* takePictureTabButton;

@property UserManager* userManager;
@property AccountManager* accountManager;

@end
