//
//  PhotoCell.m
//  photowall
//
//  Created by Spirit on 4/23/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoCell.h"

#import "Photo.h"

#import "UIImageView+WebImage.h"

NSString* const PhotoCellIdentifier = @"PhotoCell";

@implementation PhotoCell

- (void)setPhoto:(Photo*)photo {
	[self.photoView setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
}

@end
