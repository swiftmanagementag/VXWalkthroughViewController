//
//  VXWalkthroughPageViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughPageViewController.h"


@interface VXWalkthroughPageSignupViewController : VXWalkthroughPageViewController<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *emailField;

@property (nonatomic,weak) IBOutlet UILabel *emailLabel;

@property (nonatomic,weak) IBOutlet UILabel *messageLabel;
	
@property (nonatomic,weak) IBOutlet UIButton *actionButton;

- (IBAction)actionClicked:(id)sender;
	
@end
