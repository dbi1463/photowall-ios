//
//  FriendCell.m
//  photowall
//
//  Created by Spirit on 4/8/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "FriendCell.h"

#import "User.h"

#import "RestClient.h"
#import "UIColor+Defaults.h"
#import "UIImageView+WebImage.h"

NSString* const FriendCellIdentifier = @"FriendCell";

@implementation FriendCell

- (void)setFriend:(User*)aFriend {
	self.nicknameLabel.text = aFriend.nickname;

	self.portraitView.layer.masksToBounds = YES;
	self.portraitView.layer.borderColor = [UIColor main].CGColor;
	self.portraitView.layer.cornerRadius = self.portraitView.frame.size.width / 2;
	[self.portraitView setImageWithPath:aFriend.portraitPath andPlaceholder:nil];
}

@end
