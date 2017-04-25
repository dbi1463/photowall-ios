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
	[self.photoView setImageWithPath:photo.portraitPath andPlaceholder:nil];
	NSDateFormatter* formatter = [NSDateFormatter new];
	formatter.dateFormat = @"YYYY/MM/dd";
	self.timestamp.text = [formatter stringFromDate:photo.timestamp];
}

@end
