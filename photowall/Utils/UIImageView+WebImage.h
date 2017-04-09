//
//  UIImageView+WebImage.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

- (void)setImageWithURL:(NSURL*)url andPlaceholder:(UIImage*)placeholder;

- (void)setImageWithPath:(NSString*)path andPlaceholder:(UIImage*)placeholder;

@end
