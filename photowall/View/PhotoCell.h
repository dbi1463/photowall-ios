//
//  PhotoCell.h
//  photowall
//
//  Created by Spirit on 4/23/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

FOUNDATION_EXPORT NSString* const PhotoCellIdentifier;

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel* posterName;
@property (weak, nonatomic) IBOutlet UIImageView* photoView;

- (void)setPhoto:(Photo*)photo;

@end
