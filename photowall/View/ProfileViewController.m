//
//  ProfileViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "ProfileViewController.h"

#import <Photos/Photos.h>

#import "User.h"

#import "UIColor+Defaults.h"
#import "UIImageView+WebImage.h"
#import "UIViewController+Mask.h"

@implementation ProfileViewController

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.accountManager.editDelegate = self;
	self.portrait.layer.cornerRadius = 10;
	self.portrait.layer.masksToBounds = YES;
	self.portrait.layer.borderColor = [UIColor main].CGColor;
	self.portrait.layer.borderWidth = 1;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"Profile"];
	[self updateAllViews];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActons
- (IBAction)changePortraitButtonPressed:(id)sender {
	UIImagePickerController* picker = [UIImagePickerController new];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.delegate = self;
	[self.rootViewController presentViewController:picker animated:YES completion:nil];
}

- (IBAction)updateButtonPressed:(id)sender {
	[self showMask];
	[self.accountManager changeNickname:self.nicknameField.text];
}

- (IBAction)textFieldValueChanged:(id)sender {
	BOOL notEmpty = self.nicknameField.text.length > 0;
	BOOL hasChange = notEmpty && ![self.nicknameField.text isEqualToString:self.accountManager.me.nickname];
	[self.updateButton setEnabled:hasChange];
}

- (IBAction)logoutButtonPressed:(id)sender {
	[self.accountManager logout];
}

#pragma mark - AccountEditDelegate
- (void)accountUpdated {
	[self hideMask];
	[self updateAllViews];
	[self.updateButton setEnabled:NO];
}

- (void)updateFailed:(NSError*)error {
	[self hideMask];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString*, id> *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	[self showMask];
	NSURL* url = [info valueForKey:UIImagePickerControllerReferenceURL];
	PHAsset* asset = [[PHAsset fetchAssetsWithALAssetURLs:@[ url ] options:nil] firstObject];
	PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
	options.resizeMode = PHImageRequestOptionsResizeModeExact;
	options.normalizedCropRect = CGRectMake(0.5, 0.5, 320, 320);
	[[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData* imageData, NSString* dataUTI, UIImageOrientation orientation, NSDictionary* info) {
		if (imageData != nil) {
			[self.accountManager changePortrait:imageData];
		}
	}];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	[textField endEditing:YES];
	return YES;
}

#pragma mark - Private Methods
- (void)updateAllViews {
	self.nicknameField.text = self.accountManager.me.nickname;
	NSString* path = self.accountManager.me.portraitPath;
	[self.portrait setImageWithPath:path andPlaceholder:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
	NSDictionary* info = [notification userInfo];
	CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	NSInteger options = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	CGFloat offset = (self.updateButton.frame.origin.y + self.updateButton.frame.size.height) - (self.view.frame.size.height - size.height);
	if (offset > 0) {
		[UIView animateKeyframesWithDuration:duration delay:0 options:options animations:^{
			self.topConstraint.constant = 30 - offset;
			[self.view setNeedsLayout];
		} completion:nil];
	}
}

- (void)keyboardWillHide:(NSNotification*)notification {
	NSDictionary* info = [notification userInfo];
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	NSInteger options = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	[UIView animateWithDuration:duration delay:0 options:options animations:^{
		self.topConstraint.constant = 30;
		[self.view setNeedsLayout];
	} completion:nil];
}

@end
