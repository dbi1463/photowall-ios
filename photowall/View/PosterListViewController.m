//
//  PosterListViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PosterListViewController.h"

#import "UserManager.h"

#import "PosterCell.h"

@implementation PosterListViewController {
	NSArray* _posters;
	NSMutableArray* _others;
	NSMutableArray* _favorites;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_posters = [NSMutableArray new];
	_favorites = [NSMutableArray new];
	_others = [NSMutableArray new];
	_posters = @[ _favorites, _others ];
	[self updatePosters];
	UINib* nib = [UINib nibWithNibName:@"PosterCell" bundle:nil];
	[self.postersView registerNib:nib forCellReuseIdentifier:PosterCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"Posters"];
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
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return (section == 0)? @"Favorites" : @"Others";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return [_posters count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [[_posters objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	User* poster = [self userAtIndexPath:indexPath];
	PosterCell* cell = [tableView dequeueReusableCellWithIdentifier:PosterCellIdentifier forIndexPath:indexPath];
	[cell setPoster:poster];
	return cell;
}

#pragma mark - Private Methods
- (void)updatePosters {
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
	[self updatePosters];
	NSIndexPath* pathToInsert = [self indexPathOfPoster:user];
	[self.postersView beginUpdates];
	[self.postersView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationLeft];
	[self.postersView insertRowsAtIndexPaths:@[ pathToInsert ] withRowAnimation:UITableViewRowAnimationRight];
	[self.postersView endUpdates];
}

- (User*)userAtIndexPath:(NSIndexPath*)indexPath {
	return [[_posters objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
