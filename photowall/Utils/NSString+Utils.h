//
//  NSString+Utils.h
//  photowall
//
//  Created by Spirit on 3/27/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Digest)

- (NSString*)sha1;

- (NSString*)base64;

+ (BOOL)notEmpty:(NSString*)string;

@end
