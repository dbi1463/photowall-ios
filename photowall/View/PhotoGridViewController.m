//
//  PhotoGridViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoGridViewController.h"

#import "PhotoManager.h"

#import "PhotoCell.h"

@implementation PhotoGridViewController {
	CGFloat _cellSize;
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	_cellSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
	UINib* nib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
	[self.photosView registerNib:nib forCellWithReuseIdentifier:PhotoCellIdentifier];
	self.photosView.delegate = self;
	self.photosView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.rootViewController setTitle:@"Photos"];
	[self.photoManager refreshWithHandler:^(NSError *error, NSArray *photos) {
		[self.photosView reloadData];
	}];
}

#pragma mark - Public Methods
- (void)refreshPhotos {
	[self.photosView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
	PhotoCell* cell = (PhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
	[cell setPhoto:[self.photoManager.photos objectAtIndex:indexPath.row]];
	return cell;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.photoManager.photos count];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
	return CGSizeMake(_cellSize, _cellSize);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 1;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0, 0, 0, 0);  // top, left, bottom, right
}

@end
