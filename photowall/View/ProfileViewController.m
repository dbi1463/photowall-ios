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

#import "UIImageView+WebImage.h"
#import "UIViewController+Mask.h"

@implementation ProfileViewController

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.accountManager.editDelegate = self;
	self.portrait.layer.cornerRadius = 10;
	self.portrait.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"Profile"];
	[self updateAllViews];
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

#pragma mark - Private Methods
- (void)updateAllViews {
	self.nicknameField.text = self.accountManager.me.nickname;
	NSString* path = self.accountManager.me.portraitPath;
	[self.portrait setImageWithPath:path andPlaceholder:nil];
}

@end
