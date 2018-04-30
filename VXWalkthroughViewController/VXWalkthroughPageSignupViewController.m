//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPageSignupViewController.h"

@interface VXWalkthroughPageSignupViewController ()
@end

@implementation VXWalkthroughPageSignupViewController

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
	
	self.emailField.placeholder = @"info@domain.com";
	self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
	self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.emailField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.emailField.returnKeyType = UIReturnKeyNext;

}
-(void)setItem:(NSDictionary *)pItem {
	[super setItem:pItem];
	
	[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
	
	self.emailLabel.text = pItem[VX_EMAILPROMPT];
	self.emailField.text = pItem[VX_EMAILVALUE];
	
}

- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		NSDictionary* options = @{VX_EMAILVALUE: self.emailField.text};
		[((VXWalkthroughViewController*)self.parentViewController).delegate walkthroughActionButtonPressed:self withOptions:options];
	}
}
+ (NSString *)storyboardID {
	return @"WalkthroughPageSignup";
}


@end
