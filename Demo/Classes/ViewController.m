//
//  RootViewController.m
//  VXPromotionViewController
//
//  Created by Swift Management AG on 18.12.2014.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import "ViewController.h"
#import "VXWalkthroughViewController.h"


@implementation ViewController

-(void)viewDidLoad {
	[super viewDidLoad];

	if(![VXWalkthroughViewController walkthroughShown]) {
		// this is to avoid timing issues
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			// show the walkthrough
			[self showWalkthrough];
		});
	}
}

- (void)presentViewController {
	[self showWalkthrough];
}

#pragma mark - walkthrough

- (void)showWalkthrough{
	UIColor *backgroundColor = [UIColor colorWithRed:167.0f/255.0f green:131.0f/255.0f blue:82.0f/255.0f alpha:1.0f];

	// create the walkthough controller
	VXWalkthroughViewController* walkthrough = [VXWalkthroughViewController initWithDelegate:self withBackgroundColor:backgroundColor];
	
	// show it
	[self presentViewController:walkthrough animated:YES completion:nil];
}
-(void)walkthroughCloseButtonPressed:(id)sender{
	// delegate for handling close button
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end

