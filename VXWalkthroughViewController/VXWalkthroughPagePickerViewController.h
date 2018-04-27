//
//  VXWalkthroughPageViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughPageViewController.h"


@interface VXWalkthroughPagePickerViewController : VXWalkthroughPageViewController

	@property (nonatomic,weak) IBOutlet UIButton *previousButton;
	@property (nonatomic,weak) IBOutlet UIButton *nextButton;

	@property (nonatomic,weak) IBOutlet UIButton *actionButton;

- (IBAction)actionClicked:(id)sender;

	- (IBAction)nextClicked:(id)sender;
	- (IBAction)previousClicked:(id)sender;

@end
