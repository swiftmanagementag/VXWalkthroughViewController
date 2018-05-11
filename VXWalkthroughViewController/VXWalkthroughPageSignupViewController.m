//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPageSignupViewController.h"

@interface VXWalkthroughPageSignupViewController ()
@property (assign, nonatomic) BOOL keyboardIsVisible;
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
	self.keyboardIsVisible = NO;
	
	self.emailField.placeholder = @"info@domain.com";
	self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
	self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.emailField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.emailField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.emailField.returnKeyType = UIReturnKeyNext;
	self.emailField.delegate = self;
	[self.emailField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventEditingChanged];

	[self.emailField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
}
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.actionButton.layer.masksToBounds = true;
	self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height * 0.25f;
	
}
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (IBAction)textFieldFinished:(id)sender {
	[sender resignFirstResponder];
}


-(void)startAnimating {
	[self enableActionButton:false];
	[self pulse:self.imageView toSize:0.8f withDuration:2.0f];
}
-(void)stopAnimating {
	[self enableActionButton:true];
	[self pulse:self.imageView toSize:0.8f withDuration:0.0f];
}


-(void)enableActionButton:(BOOL)pIsEnabled {
	self.actionButton.enabled = pIsEnabled;
	self.actionButton.alpha = pIsEnabled ? 1.0f : 0.5f;
	
}
- (void)keyboardWillShow:(NSNotification *)notification {
	if(_keyboardIsVisible) return;
	
	NSDictionary* info = [notification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	
	[UIView animateWithDuration:0.2f animations:^{
		CGRect f = self.view.frame;
		f.origin.y -= kbSize.height;
		self.view.frame = f;
	}];
	_keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	if(!_keyboardIsVisible) return;
	
	NSDictionary* info = [notification userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	
	[UIView animateWithDuration:0.2f animations:^{
		CGRect f = self.view.frame;
		f.origin.y += kbSize.height;
		self.view.frame = f;
	}];
	_keyboardIsVisible = NO;
}


-(BOOL)validateInput {
	// enable button if input valid
	[self enableActionButton:false];
	if(self.emailField.text && self.emailField.text.length != 0) {
		if([self isValidEmail:self.emailField.text strict:YES]) {
			[self enableActionButton:true];
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
		
		self.emailField.hidden = true;
		self.emailLabel.hidden = true;
	} else {
		[self enableActionButton:false];
		
		// setup fields
		[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
		
		self.emailLabel.text = pItem[VX_EMAILPROMPT];
		self.emailField.text = pItem[VX_EMAILVALUE];
		
		
	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		[self.emailField resignFirstResponder];
		
		// start process
		[self startAnimating];
		
		NSDictionary* options = @{VX_EMAILVALUE: self.emailField.text};
		[self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
	}
}

+ (NSString *)storyboardID {
	return @"WalkthroughPageSignup";
}


@end
