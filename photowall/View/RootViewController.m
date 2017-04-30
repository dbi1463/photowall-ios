//
//  RootViewController.m
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "RootViewController.h"

#import "ProfileViewController.h"
#import "FriendsViewController.h"
#import "PhotoMapViewController.h"
#import "PhotoGridViewController.h"

#import "UIView+Utils.h"
#import "UIColor+Defaults.h"

#import "PhotoManager.h"

@implementation RootViewController {
	ProfileViewController* _profileViewController;
	FriendsViewController* _friendsViewController;
	PhotoMapViewController* _photoMapViewController;
	PhotoGridViewController* _photoGridViewController;

	NSArray* _titles;
	NSArray* _tabButtons;
	NSArray* _viewControllers;

	NSInteger _selectedIndex;
	UIViewController* _currentController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
	_tabButtons = @[ _friendsTabButton, _gridTabButton, _photoMapTabButton, _profileTabButton ];

	_selectedIndex = 0;

	_profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:nil];
	_photoMapViewController = [[PhotoMapViewController alloc] initWithNibName:@"PhotoMapView" bundle:nil];
	_photoGridViewController = [[PhotoGridViewController alloc] initWithNibName:@"PhotoGridView" bundle:nil];
	_friendsViewController = [[FriendsViewController alloc] initWithNibName:@"FriendsListView" bundle:nil];

	_viewControllers = @[ _friendsViewController, _photoGridViewController, _photoMapViewController, _profileViewController ];

	_profileViewController.rootViewController = self;
	_profileViewController.accountManager = self.accountManager;

	_photoGridViewController.rootViewController = self;
	_photoGridViewController.userManager = self.userManager;
	_photoGridViewController.photoManager = self.photoManager;

	_photoMapViewController.rootViewController = self;
	_photoMapViewController.userManager = self.userManager;
	_photoMapViewController.photoManager = self.photoManager;

	_friendsViewController.rootViewController = self;
	_friendsViewController.userManager = self.userManager;

	[self setSelectedIndex:0];
	[self setTitle:@"Friends"];
}

- (void)showPhotosOfUser:(NSString*)userId {
	PhotoGridViewController* controller = [[PhotoGridViewController alloc] initWithNibName:@"PhotoGridView" bundle:nil];
	controller.posterId = userId;
	controller.userManager = self.userManager;
	controller.photoManager = self.photoManager;
	[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - IBActions
- (IBAction)tabButtonPressed:(id)sender {
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton* button = (UIButton*)sender;
		[self setSelectedIndex:(button.tag - 1)];
	}
}

- (IBAction)takePictureButtonPressed:(id)sender {
	UIImagePickerController* picker = [UIImagePickerController new];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
	NSData* pngData = UIImagePNGRepresentation(image);
	[self.photoManager uploadPhoto:pngData withHandler:^(NSError* error, NSArray* photos) {
		[_photoGridViewController refreshPhotos];
	}];
}

#pragma mark - Private Methods
- (void)setSelectedIndex:(NSInteger)index {
	if (index < 0 || index > [_viewControllers count]) {
		return;
	}
	_selectedIndex = index;
	for (NSUInteger i = 0; i < _tabButtons.count; i++) {
		[[_tabButtons objectAtIndex:i] setSelected:(i == index)];
	}
	UIViewController* controller = [_viewControllers objectAtIndex:index];
	if (_currentController == controller) {
		return;
	}
	[_currentController.view removeFromSuperview];
	[self.viewContainer addSubview:controller.view fit:YES];
	_currentController = controller;
}

@end
