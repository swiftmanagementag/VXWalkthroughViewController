//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPageLoginViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface VXWalkthroughPageLoginViewController ()
@property (assign, nonatomic) BOOL keyboardIsVisible;
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
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.keyboardIsVisible = NO;
	
	self.loginField.placeholder = @"info@domain.com";
	self.loginField.keyboardType = UIKeyboardTypeEmailAddress;
	self.loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.loginField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.loginField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.loginField.returnKeyType = UIReturnKeyNext;
	self.loginField.delegate = self;
	if (@available(iOS 11.0, *)) {
		self.loginField.textContentType = UITextContentTypeEmailAddress;
	}
	self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
	self.passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordField.spellCheckingType = UITextSpellCheckingTypeNo;
	self.passwordField.returnKeyType = UIReturnKeyDone;
	self.passwordField.delegate = self;
	if (@available(iOS 11.0, *)) {
		self.passwordField.textContentType = UITextContentTypePassword;
	}

	[self.loginField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventEditingChanged];
	[self.passwordField addTarget:self action:@selector(validateInput) forControlEvents:UIControlEventEditingChanged];
	[self.passwordField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	[self enableActionButton:false];
	[self enableScanButton:false];
}
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.actionButton.layer.masksToBounds = true;
	self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height * 0.25f;
	self.scanButton.layer.masksToBounds = true;
	self.scanButton.layer.cornerRadius = self.actionButton.frame.size.height * 0.25f;
	
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
-(void)enableScanButton:(BOOL)pIsEnabled {
	BOOL isEnabled = false;
	if (@available(iOS 11.0, *)) {
		isEnabled = true;
		
	}

	isEnabled = pIsEnabled && isEnabled;
	
	self.scanButton.hidden = !isEnabled;
	self.scanButton.enabled = isEnabled;
	self.scanButton.alpha = isEnabled ? 1.0f : 0.5f;
	self.actionTrailingMargin.constant = isEnabled ?  -(12.0f + self.scanButton.frame.size.width) : 0.0f;
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
		
		[self enableActionButton:true];
		if (pItem[VX_SCANENABLED] && [pItem[VX_SCANENABLED] isEqualToString:@"YES"]) {
			[self enableScanButton:true];
		}
		
	} else if (pItem[VX_SUCCESS]) {
		[self stopAnimating];
		
		self.titleText = pItem[VX_SUCCESS];
		// there was success, hide fields
		self.actionButton.hidden = true;
		
		self.loginLabel.hidden = true;
		self.passwordLabel.hidden = true;
		
		self.loginField.hidden = true;
		self.passwordField.hidden = true;
		self.scanButton.hidden = true;
	} else {
		[self enableActionButton:false];
		[self enableScanButton:false];
		
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
		
		if (pItem[VX_SCANENABLED] && [pItem[VX_SCANENABLED] isEqualToString:@"YES"]) {
			[self enableScanButton:true];
		}
	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		[self.loginField resignFirstResponder];
		[self.passwordField resignFirstResponder];
        
        [UIView animateWithDuration:0.1 animations:^{
            [self startAnimating];
        } completion:^(BOOL finished) {
            // start process
            NSDictionary* options = @{VX_LOGINVALUE: self.loginField.text, VX_PASSWORDVALUE: self.passwordField.text };
            [self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
        }];
    }
}

- (IBAction)scanClicked:(id)sender {
	
	if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
		QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
		// Instantiate the view controller
		QRCodeReaderViewController *vc = [QRCodeReaderViewController readerWithCancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:YES];

		// Set the presentation style
		vc.delegate = self;
		vc.modalPresentationStyle = UIModalPresentationFormSheet;

		// Or use blocks
		[reader setCompletionWithBlock:^(NSString *qrCodeString) {
			NSLog(@"%@", qrCodeString);
			//https://truck.app.link/truck?voucher=JOPJ-OI6I-VWKO&teacher=L025&flavor=ch_truck_premium

			if([qrCodeString hasPrefix:@"http"]) {
				NSURLComponents *urlComponents = [NSURLComponents componentsWithString:qrCodeString];
				NSArray *queryItems = urlComponents.queryItems;
				NSMutableArray *someIDs = [NSMutableArray new];
				for (NSURLQueryItem *item in queryItems) {
					NSLog(@"%@", item);
					
					if ([item.name isEqualToString:@"voucher"]) {
						self.passwordField.text = item.value;
					} else if ([item.name isEqualToString:@"teacher"]) {
						[[NSUserDefaults standardUserDefaults] setObject:item.value forKey:@"teacher_preference"];
						[[NSUserDefaults standardUserDefaults] synchronize];
					}
				}
			} else {
				self.passwordField.text = qrCodeString;
			}
			[vc dismissViewControllerAnimated:true completion:^{
				[self validateInput];
			}];
		}];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
                    
		[self.parent presentViewController:vc animated:YES completion:NULL];

	}
}
- (void)readerDidCancel:(QRCodeReaderViewController *)reader{
	[reader dismissViewControllerAnimated:true completion:^{
		NSLog(@"cancelled");
	}];
	
}
+ (NSString *)storyboardID {
	return @"WalkthroughPageLogin";
}


@end
