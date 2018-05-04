//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPageLoginViewController.h"

@interface VXWalkthroughPageLoginViewController ()
@end

@implementation VXWalkthroughPageLoginViewController

- (instancetype)init {
	if(self =  [super init]) {
	}
	return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
	};
	
	return self;
}
	
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.loginField.placeholder = @"info@domain.com";
	self.loginField.keyboardType = UIKeyboardTypeEmailAddress;
	self.loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.loginField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.loginField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.loginField.returnKeyType = UIReturnKeyNext;
	self.loginField.delegate = self;
	
	self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
	self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.passwordField.returnKeyType = UIReturnKeyNext;
	self.passwordField.delegate = self;

	[self enableActionButton:false];
}
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.actionButton.layer.masksToBounds = true;
	self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height * 0.25f;
	
}
-(void)startAnimating {
	[self enableActionButton:false];
	[self pulse:self.imageView toSize:0.8f withDuration:2.0f];
}
-(void)stopAnimating {
	[self enableActionButton:true];
	[self pulse:self.imageView toSize:0.8f withDuration:0.0f];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[self validateInput];
	return true;
}

-(void)enableActionButton:(BOOL)pIsEnabled {
	self.actionButton.enabled = pIsEnabled;
	self.actionButton.alpha = pIsEnabled ? 1.0f : 0.5f;
	
}
-(BOOL)validateInput {
	// enable button if input valid
	[self enableActionButton:false];
	if(self.loginField.text && self.loginField.text.length != 0) {
		if(self.passwordField.text && self.passwordField.text.length != 0) {
			if([self isValidEmail:self.loginField.text strict:YES]) {
				[self enableActionButton:true];
			}
		}
	}
		
	return true;
}

-(void)setItem:(NSDictionary *)pItem {
	[super setItem:pItem];
	
	if(pItem[VX_ERROR]) {
		// there was an error, show error
		[self stopAnimating];
		
		self.titleText = pItem[VX_ERROR];
	} else if (pItem[VX_SUCCESS]) {
		[self stopAnimating];
		
		self.titleText = pItem[VX_SUCCESS];
		// there was success, hide fields
		self.actionButton.hidden = true;
		
		self.loginLabel.hidden = true;
		self.passwordLabel.hidden = true;
		
		self.loginField.hidden = true;
		self.passwordField.hidden = true;
	} else {
		[self enableActionButton:false];
		
		// setup fields
		[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
		
		self.loginLabel.text = pItem[VX_LOGINPROMPT];
		self.passwordLabel.text = pItem[VX_PASSWORDPROMPT];
		
		self.loginField.text = pItem[VX_LOGINVALUE];
		self.passwordField.text = pItem[VX_PASSWORDVALUE];
		
		if (pItem[VX_PLACEHOLDERVALUE]) {
			self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
			self.passwordField.placeholder = pItem[VX_PLACEHOLDERVALUE];
		}

	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		
		// start process
		[self startAnimating];
		
		NSDictionary* options = @{VX_LOGINVALUE: self.loginField.text, VX_PASSWORDVALUE: self.passwordField.text };
		[self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
	}
}

+ (NSString *)storyboardID {
	return @"WalkthroughPageLogin";
}


@end
