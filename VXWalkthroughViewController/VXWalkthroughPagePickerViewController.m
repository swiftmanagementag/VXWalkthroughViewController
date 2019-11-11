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
@property (nonatomic) NSInteger activeOption;
@property (nonatomic) NSInteger selectedOption;

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
	
	//self.nextButton.backgroundColor = self.view.backgroundColor;
	//self.previousButton.backgroundColor = self.view.backgroundColor;
	self.nextButton.backgroundColor = self.actionButton.backgroundColor;
	self.previousButton.backgroundColor = self.actionButton.backgroundColor;
	
	self.nextButton.layer.borderColor = [[UIColor whiteColor] CGColor];
	self.previousButton.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	self.nextButton.layer.borderWidth = 2.0f;
	self.previousButton.layer.borderWidth = 2.0f;
	
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
		
		self.actionButton.hidden = true;
	} else {
		[self enableActionButton:true];

		self.options = pItem[VX_OPTIONS];
		
		self.selectedOption = 0;
		
		self.selectedOption = [self.options indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			return ([((NSDictionary *)obj)[VX_KEY]  isEqualToString:pItem[VX_PICKERVALUE]]);
		}];

		[self setOption:self.selectedOption];
		
		// setup fields
		[self.actionButton setTitle:pItem[VX_BUTTONTITLE] forState:UIControlStateNormal];
		
	}
}
-(void)setOption:(int)pIndex {
	if(pIndex < self.options.count) {
		self.activeOption = pIndex;
		
		NSDictionary* selectedItem = self.options[self.activeOption];
		
		self.imageName = selectedItem[VX_IMAGE];
		
		self.imageView.layer.borderWidth = (pIndex == self.selectedOption) ? 6 : 3;
		
		self.previousButton.hidden = (self.activeOption == 0);
		self.nextButton.hidden = (self.activeOption >= (self.options.count - 1));
	
		if (pIndex == self.selectedOption) {
			self.titleText = [NSString stringWithFormat:self.item[VX_TITLE], selectedItem[VX_TITLE]] ;
			self.actionButton.hidden = true;
		} else {
			self.titleText = selectedItem[VX_TITLE];
			NSNumber* isAvailable = selectedItem[VX_AVAILABLE];
			
			self.actionButton.hidden = false;
			[self enableActionButton:(isAvailable ? [isAvailable boolValue] : true)];
		}
	}
}
- (IBAction)actionClicked:(id)sender {
	if([self.parent.delegate respondsToSelector:@selector(walkthroughActionButtonPressed:withOptions:)]) {
		[UIView animateWithDuration:0.1 animations:^{
            [self startAnimating];
        } completion:^(BOOL finished) {
            // start process
            if(self.activeOption < self.options.count) {
                self.selectedOption = self.activeOption;
                NSDictionary* selectedItem = self.options[self.selectedOption];
                
                NSDictionary *itemResult = @{VX_PICKERVALUE: selectedItem[VX_KEY]};
                
                [self.parent.delegate walkthroughActionButtonPressed:self withOptions:itemResult];
            }
            
        }];
        
		
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
