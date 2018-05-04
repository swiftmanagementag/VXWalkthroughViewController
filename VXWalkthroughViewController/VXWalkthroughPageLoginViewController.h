//
//  VXWalkthroughPageViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughPageViewController.h"


@interface VXWalkthroughPageLoginViewController : VXWalkthroughPageViewController<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *loginField;
@property (nonatomic,weak) IBOutlet UITextField *passwordField;

@property (nonatomic,weak) IBOutlet UILabel *loginLabel;
@property (nonatomic,weak) IBOutlet UILabel *passwordLabel;
	
@property (nonatomic,weak) IBOutlet UIButton *actionButton;

- (IBAction)actionClicked:(id)sender;
	
@end
