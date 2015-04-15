//
//  VXWalkthroughPageViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VXWalkthroughViewController.h"

enum VXWalkthroughAnimationType{
	Linear = 0,
	Curve = 1,
	Zoom = 2,
	InOut = 3
};

@interface VXWalkthroughPageViewController : UIViewController <VXWalkthroughPage>

@property (nonatomic) IBInspectable CGPoint speed;
@property (nonatomic) IBInspectable CGPoint speedVariance;
@property (nonatomic) IBInspectable enum VXWalkthroughAnimationType animationType;
@property (nonatomic) IBInspectable BOOL animateAlpha;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *imageName;

@property (nonatomic) NSDictionary *styles;
@property (nonatomic) BOOL roundImages;
@property (nonatomic) BOOL bigImages;


@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *imageViewAspectContstraint;
@property (nonatomic,weak) IBOutlet UILabel *titleView;

@end
