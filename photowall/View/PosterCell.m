//
//  PosterCell.m
//  photowall
//
//  Created by Spirit on 4/8/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PosterCell.h"

#import "User.h"

NSString* const PosterCellIdentifier = @"PosterCell";

@implementation PosterCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)setPoster:(User*)poster {
	self.nicknameLabel.text = poster.nickname;
}

@end
