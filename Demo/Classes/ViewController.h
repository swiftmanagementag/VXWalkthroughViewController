//
//  RootViewController.h
//  VXPromotionViewController
//
//  Created by Swift Management AG on 18.12.2014.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughViewController.h"

@interface ViewController : UIViewController<VXWalkthroughViewControllerDelegate>

- (IBAction)presentViewController;

@end
