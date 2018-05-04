//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPagePickerViewController.h"

@interface VXWalkthroughPagePickerViewController ()

@property (nonatomic,weak) NSArray*options;
@property (nonatomic) int activeOption;
@property (nonatomic) int selectedOption;

@end

@implementation VXWalkthroughPagePickerViewController



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
	
	self.nextButton.backgroundColor = self.view.backgroundColor;
	self.previousButton.backgroundColor = self.view.backgroundColor;
	
	self.nextButton.alpha = 1.0;
	self.previousButton.alpha = 1.0;
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
	} else if (pItem[VX_SUCCESS]) {
		[self stopAnimating];
		
		self.imageView.layer.borderWidth = 6;
		
		self.titleText = pItem[VX_SUCCESS];
		
	} else {
		[self enableActionButton:true];

		self.options = pItem[VX_OPTIONS];
		
		
		self.selectedOption = 0;
		
		[self setOption:0];
		
		self.nextButton.hidden = (self.options.count) <= 1;
		self.previousButton.hidden = true;
		
		// setup fields
		[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
		
	}
}
-(void)setOption:(int)pIndex {
	if(pIndex < self.options.count) {
		NSDictionary* item = self.options[pIndex];
		
		self.activeOption = pIndex;
		self.titleText = item[VX_TITLE];
		self.imageName = item[VX_IMAGE];
		
		self.imageView.layer.borderWidth = (pIndex == self.selectedOption) ? 6 : 3;
		
		self.previousButton.hidden = (self.activeOption == 0);
		self.nextButton.hidden = (self.activeOption >= (self.options.count - 1));
		
		NSNumber* isAvailable = item[VX_AVAILABLE];
		
		self.actionButton.hidden = (pIndex == self.selectedOption);
		
		[self enableActionButton:(isAvailable ? [isAvailable boolValue] : true)];
	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		
		// start process
		[self startAnimating];
	
		if(self.selectedOption < self.options.count) {
			NSDictionary* item = self.options[self.activeOption];
			
			NSDictionary* options = @{VX_PICKERVALUE: item[VX_KEY]};
			[self.parent.delegate walkthroughActionButtonPressed:self withOptions:options];
		}
	}
}



- (IBAction)nextClicked:(id)sender {
	if(self.activeOption < (self.options.count - 1)) {
		[self setOption:self.activeOption + 1];
	};
}
- (IBAction)previousClicked:(id)sender {
	if(self.activeOption > 0) {
		[self setOption:self.activeOption - 1];
	};
}

	+ (NSString *)storyboardID {
		return @"WalkthroughPagePicker";
	}

@end
