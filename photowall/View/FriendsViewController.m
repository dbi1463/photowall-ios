//
//  FriendsViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "FriendsViewController.h"

#import "UserManager.h"

#import "FriendCell.h"
#import "RootViewController.h"

#import "UIColor+Defaults.h"

@implementation FriendsViewController {
	NSArray* _friends;
	NSMutableArray* _others;
	NSMutableArray* _favorites;
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	_favorites = [NSMutableArray new];
	_others = [NSMutableArray new];
	_friends = @[ _favorites, _others ];
	[self updateFriends];
	UINib* nib = [UINib nibWithNibName:@"FriendCell" bundle:nil];
	[self.friendsView registerNib:nib forCellReuseIdentifier:FriendCellIdentifier];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usersSynchronized) name:UsersSynchronizedNotificationName object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"Friends"];
	[self.friendsView reloadData];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
	return YES;
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString* title = indexPath.section == 0 ? @"Unlike" : @"Like";
	UITableViewRowAction* action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction* _Nonnull action, NSIndexPath* _Nonnull path) {
		[self updateFavoriteStateAtIndexPath:path];
	}];
	return @[ action ];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	User* user = [self userAtIndexPath:indexPath];
	[self.rootViewController showPhotosOfUser:user.identifier];
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0)? @"Favorites" : @"Others";
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel* label = [UILabel new];
	UIFont* font = [UIFont boldSystemFontOfSize:12];
	label.text = (section == 0)? @"  Favorites" : @"  Others";
	label.font = font;
	label.textColor = [UIColor main];
	label.backgroundColor = [UIColor secondaryAuxiliary];
	return label;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return [_friends count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [[_friends objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	User* poster = [self userAtIndexPath:indexPath];
	FriendCell* cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier forIndexPath:indexPath];
	[cell setFriend:poster];
	return cell;
}

#pragma mark - Private Methods
- (void)usersSynchronized {
	[self updateFriends];
	[self.friendsView reloadData];
}

- (void)updateFriends {
	[_others removeAllObjects];
	[_favorites removeAllObjects];
	for (User* user in self.userManager.users) {
		if (user.favoriteValue) {
			[_favorites addObject:user];
		}
		else {
			[_others addObject:user];
		}
	}
}

- (void)updateFavoriteStateAtIndexPath:(NSIndexPath*)indexPath {
	User* user = [self userAtIndexPath:indexPath];
	if (user.favoriteValue) {
		[self.userManager unmarkFavorite:user];
	}
	else {
		[self.userManager markAsFavorite:user];
	}
	[self updateFriends];
	NSIndexPath* pathToInsert = [self indexPathOfPoster:user];
	[self.friendsView beginUpdates];
	[self.friendsView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationLeft];
	[self.friendsView insertRowsAtIndexPaths:@[ pathToInsert ] withRowAnimation:UITableViewRowAnimationRight];
	[self.friendsView endUpdates];
}

- (User*)userAtIndexPath:(NSIndexPath*)indexPath {
	return [[_friends objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSIndexPath*)indexPathOfPoster:(User*)poster {
	NSUInteger row = [_favorites indexOfObject:poster];
	if (row != NSNotFound) {
		return [NSIndexPath indexPathForRow:row inSection:0];
	}
	else {
		return [NSIndexPath indexPathForRow:[_others indexOfObject:poster] inSection:1];
	}
}

@end
