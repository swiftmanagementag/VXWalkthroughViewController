//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPagePermissionViewController.h"

@interface VXWalkthroughPagePermissionViewController ()
@end

@implementation VXWalkthroughPagePermissionViewController


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
}
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	self.actionButton.layer.masksToBounds = true;
	self.actionButton.layer.cornerRadius = self.actionButton.frame.size.height * 0.25f;
	
}
-(void)enableActionButton:(BOOL)pIsEnabled {
	self.actionButton.enabled = pIsEnabled;
	self.actionButton.alpha = pIsEnabled ? 1.0f : 0.5f;
	
}

-(void)startAnimating {
	[self enableActionButton:false];
	[self pulse:self.imageView toSize:0.8f withDuration:2.0f];
}
-(void)stopAnimating {
	[self enableActionButton:true];
	[self pulse:self.imageView toSize:0.8f withDuration:0.0f];
}


-(void)setItem:(NSDictionary *)pItem {
	[super setItem:pItem];
	
	if(pItem[VX_ERROR]) {
		// there was an error, show error
		[self stopAnimating];
		
		self.titleText = pItem[VX_ERROR];
		
		// Assumber user denied request
		self.actionButton.hidden = true;
		
	} else if (pItem[VX_SUCCESS]) {
		[self stopAnimating];
		
		self.titleText = pItem[VX_SUCCESS];
		// there was success, hide fields
		self.actionButton.hidden = true;
		
	} else {
		[self enableActionButton:true];
		
		// setup fields
		[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		// start process
		[self startAnimating];
		
		NSDictionary* options = @{};
		[self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
	}
}

+ (NSString *)storyboardID {
	return @"WalkthroughPagePermission";
}

@end
