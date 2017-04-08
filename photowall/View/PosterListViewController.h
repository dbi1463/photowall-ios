//
//  PhotoListViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserManager;

@interface PosterListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak) UserManager* userManager;
@property (weak) UIViewController* rootViewController;

@property (weak, nonatomic) IBOutlet UITableView* postersView;

@end
