//
//  UIImageView+WebImage.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "UIImageView+WebImage.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "RestClient.h"

@implementation UIImageView (WebImage)

- (void)setImageWithURL:(NSURL*)url andPlaceholder:(UIImage*)placeholder {
	self.tag = [url.absoluteString hash];
	[self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		if ([imageURL.absoluteString hash] != self.tag) {
			// The UIImageView has been assigned another URL
			return;
		}
		if (error != nil) {
			self.image = placeholder;
			return;
		}
		self.image = image;
	}];
}

- (void)setImageWithPath:(NSString*)path andPlaceholder:(UIImage*)placeholder {
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [RestClient defaultEndPoint], path]];
	[self setImageWithURL:url andPlaceholder:placeholder];
}

@end
