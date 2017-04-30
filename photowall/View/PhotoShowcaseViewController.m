//
//  PhotoShowcaseViewController.m
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoShowcaseViewController.h"

#import "PhotoShowcaseCell.h"

@implementation PhotoShowcaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UINib* nib = [UINib nibWithNibName:@"PhotoShowcaseCell" bundle:nil];
	[self.showcaseView registerNib:nib forCellWithReuseIdentifier:PhotoShowcaseCellIdentifier];
	self.showcaseView.delegate = self;
	self.showcaseView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSIndexPath* path = [NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0];
	[self.showcaseView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.photos count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
	Photo* photo = [self.photos objectAtIndex:indexPath.row];
	PhotoShowcaseCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoShowcaseCellIdentifier forIndexPath:indexPath];
	[cell setPhoto:photo];
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
	return self.showcaseView.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	// top, left, bottom, right
	return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - IBActions
- (IBAction)closeShowcaseButtonPressed:(id)sender {
	[self.host dismissViewControllerAnimated:YES completion:nil];
}

@end
