//
//  VXWalkthroughPageViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughPageViewController.h"

@interface VXWalkthroughPageActionViewController : VXWalkthroughPageViewController

@property (nonatomic,weak) IBOutlet UIButton *actionButton;

- (IBAction)actionClicked:(id)sender;

@end
