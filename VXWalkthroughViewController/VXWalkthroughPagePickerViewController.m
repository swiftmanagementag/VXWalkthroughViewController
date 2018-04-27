//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPagePickerViewController.h"

@interface VXWalkthroughPagePickerViewController ()
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
}
	
- (IBAction)actionClicked:(id)sender {
	
}
- (IBAction)nextClicked:(id)sender {
	
}
- (IBAction)previousClicked:(id)sender {
	
}

	+ (NSString *)storyboardID {
		return @"WalkthroughPagePicker";
	}

@end
