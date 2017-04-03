//
//  ProfileViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountManager.h"

@interface ProfileViewController : UIViewController<AccountEditDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView* portrait;
@property (weak, nonatomic) IBOutlet UITextField* nicknameField;

@property (weak, nonatomic) IBOutlet UIButton* updateButton;
@property (weak, nonatomic) IBOutlet UIButton* changePortraitButton;

@property AccountManager* accountManager;
@property (weak) UIViewController* rootViewController;

@end
