//
//  PhotoGridSectionHeader.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString* const PhotoGridSectionHeaderIdentifier;

@interface PhotoGridSectionHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel* dateLabel;

@end
