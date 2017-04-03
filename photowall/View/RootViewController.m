//
//  RootViewController.m
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "RootViewController.h"

#import "ProfileViewController.h"
#import "PhotoMapViewController.h"
#import "PhotoListViewController.h"
#import "PhotoGridViewController.h"

#import "UIView+Utils.h"

@implementation RootViewController {
	ProfileViewController* _profileViewController;
	PhotoMapViewController* _photoMapViewController;
	PhotoListViewController* _photoListViewController;
	PhotoGridViewController* _photoGridViewController;

	NSInteger _selectedIndex;
	NSArray* _viewControllers;
	UIViewController* _currentController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_selectedIndex = 0;

	_profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:nil];
	_photoMapViewController = [[PhotoMapViewController alloc] initWithNibName:@"PhotoMapView" bundle:nil];
	_photoListViewController = [[PhotoListViewController alloc] initWithNibName:@"PhotoListView" bundle:nil];
	_photoGridViewController = [[PhotoGridViewController alloc] initWithNibName:@"PhotoGridView" bundle:nil];

	_viewControllers = @[ _photoListViewController, _photoGridViewController, _photoMapViewController, _profileViewController ];

	_profileViewController.rootViewController = self;
	_profileViewController.accountManager = self.accountManager;

	[self setSelectedIndex:0];
}

- (void)setSelectedIndex:(NSInteger)index {
	if (index < 0 || index > [_viewControllers count]) {
		return;
	}
	_selectedIndex = index;
	UIViewController* controller = [_viewControllers objectAtIndex:index];
	if (_currentController == controller) {
		return;
	}
	[_currentController.view removeFromSuperview];
	[self.viewContainer addSubview:controller.view fit:YES];
	_currentController = controller;
}

- (IBAction)tabButtonPressed:(id)sender {
	if ([sender isKindOfClass:[UIButton class]]) {
		UIButton* button = (UIButton*)sender;
		[self setSelectedIndex:(button.tag - 1)];
	}
}

@end
