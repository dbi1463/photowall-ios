//
//  AnnotationCallOutView.h
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@interface AnnotationCallOutView : UIView

@property (weak, nonatomic) IBOutlet UILabel* nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* photoView;

- (void)setPhoto:(Photo*)photo withNickname:(NSString*)nickname;

@end
