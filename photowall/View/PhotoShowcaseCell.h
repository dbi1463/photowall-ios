//
//  PhotoShowcaseCell.h
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

FOUNDATION_EXPORT NSString* const PhotoShowcaseCellIdentifier;

@interface PhotoShowcaseCell : UICollectionViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView* preivew;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* loadingIndicator;

- (void)updateZoom;

- (void)setPhoto:(Photo*)photo;

@end
