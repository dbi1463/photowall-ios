//
//  AnnotationCallOutView.m
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "AnnotationCallOutView.h"

#import "Photo.h"

#import "UIImageView+WebImage.h"

@implementation AnnotationCallOutView

- (void)setPhoto:(Photo*)photo withNickname:(NSString*)nickname {
	self.nicknameLabel.text = nickname;
	[self.photoView setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
}

@end
