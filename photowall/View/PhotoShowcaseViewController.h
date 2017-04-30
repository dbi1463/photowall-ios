//
//  PhotoShowcaseViewController.h
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoShowcaseViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSArray* photos;
@property (nonatomic) NSInteger currentPhotoIndex;

@property (weak, nonatomic) UIViewController* host;

@property (weak, nonatomic) IBOutlet UICollectionView* showcaseView;

@end
