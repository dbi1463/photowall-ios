//
//  FriendCell.h
//  photowall
//
//  Created by Spirit on 4/8/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

FOUNDATION_EXPORT NSString* const FriendCellIdentifier;

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* portraitView;
@property (weak, nonatomic) IBOutlet UIImageView* favoriteView;

- (void)setFriend:(User*)aFriend;

@end
