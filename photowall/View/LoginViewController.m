//
//  LoginViewController.m
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "LoginViewController.h"

#import "NSString+Utils.h"
#import "UIViewController+Mask.h"

@implementation LoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addBorder:self.loginButton];
	[self addBorder:self.registerButton];
}

- (IBAction)loginButtonPressed:(id)sender {
	[self showMask];
	NSString* email = self.emailField.text;
	NSString* password = self.passwordField.text;
	[self.accountManager loginWithEmail:email andPassword:password];
}

- (IBAction)registerButtonPressed:(id)sender {
	[self showMask];
	NSString* email = self.emailField.text;
	NSString* password = self.passwordField.text;
	NSString* nickname = self.nicknameField.text;
	[self.accountManager registerWithEmail:email nickname:nickname andPassword:password];
}

- (IBAction)textFieldValueChanged:(id)sender {
	BOOL hasEmailAndPassword = [self isValidEmail] && self.passwordField.text.length > 0;
	[self.loginButton setEnabled:hasEmailAndPassword];
	BOOL hasConfirmedPassword = hasEmailAndPassword && [self.passwordField.text isEqualToString:self.confirmPasswordField.text];
	BOOL hasNickname = self.nicknameField.text.length > 0;
	[self.registerButton setEnabled:(hasConfirmedPassword && hasNickname)];
}

#pragma mark - Private Methods
- (BOOL)isValidEmail {
	NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:self.emailField.text];
}

- (void)addBorder:(UIButton*)button {
	button.layer.borderColor = [UIColor yellowColor].CGColor;
	button.layer.cornerRadius = 15;
	button.layer.borderWidth = 1;
}

@end
