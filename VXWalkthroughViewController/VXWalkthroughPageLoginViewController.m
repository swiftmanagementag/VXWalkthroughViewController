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
	
	self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
	self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.passwordField.returnKeyType = UIReturnKeyNext;
	
	
}
-(void)setItem:(NSDictionary *)pItem {
	[super setItem:pItem];
	
	if(pItem[VX_ERROR]) {
		// there was an error, show error
		self.titleText = pItem[VX_ERROR];
	} else if (pItem[VX_SUCCESS]) {
		self.titleText = pItem[VX_SUCCESS];
		// there was success, hide fields
		self.actionButton.hidden = true;
		
		self.loginLabel.hidden = true;
		self.passwordLabel.hidden = true;
		
		self.loginField.hidden = true;
		self.passwordField.hidden = true;
	} else {
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
		NSDictionary* options = @{VX_LOGINVALUE: self.loginField.text, VX_PASSWORDVALUE: self.passwordField.text };
		[self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
	}
}

+ (NSString *)storyboardID {
	return @"WalkthroughPageLogin";
}


@end
