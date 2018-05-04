//
//  VXWalkthroughViewController.h
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VXWalkthroughViewControllerDelegate<NSObject>
@optional
-(void)walkthroughCloseButtonPressed:(id)sender;              // If the skipRequest(sender:) action is connected to a button, this function is called when that button is pressed.
-(void)walkthroughNextButtonPressed;               //
-(void)walkthroughPrevButtonPressed;               //
-(void)walkthroughPageDidChange:(NSInteger)pageNumber;     // Called when current page changes
-(void)walkthroughActionButtonPressed:(id)pSender withOptions:(NSDictionary*)pOptions;
@end

// Walkthrough Page:
// The walkthrough page represents any page added to the Walkthrough.
// At the moment it's only used to perform custom animations on didScroll.

@protocol VXWalkthroughPage
// While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
// While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
// The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
// This value can be used on the previous, current and next page to perform custom animations on page's subviews.

-(void)walkthroughDidScroll:(CGFloat)position withOffset:(CGFloat)offset;   // Called when the main Scrollview...scroll
@end

#define VX_TITLE @"title"
#define VX_IMAGE @"image"
#define VX_STORYBOARDID @"storyboardID"
#define VX_OPTIONS @"options"

#define VX_PICKERVALUE @"pickerValue"
#define VX_LOGINVALUE @"loginValue"
#define VX_EMAILVALUE @"emailValue"
#define VX_PASSWORDVALUE @"passwordValue"

#define VX_EMAILPROMPT @"emailPrompt"
#define VX_LOGINPROMPT @"loginPrompt"
#define VX_PASSWORDPROMPT @"passwordPrompt"
#define VX_BUTTONTITLE @"buttonTitle"
#define VX_PLACEHOLDERVALUE @"placeholderValue"

#define VX_SUCCESS @"success"
#define VX_ERROR @"error"

#define VX_KEY @"key"
#define VX_SORT @"sort"
#define VX_AVAILABLE @"available"

@interface VXWalkthroughViewController : UIViewController <UIScrollViewDelegate>

// Walkthrough Delegate:
// This delegate performs basic operations such as dismissing the Walkthrough or call whatever action on page change.
// Probably the Walkthrough is presented by this delegate.

@property (nonatomic) id<VXWalkthroughViewControllerDelegate> delegate;
@property (nonatomic) NSString *group;

// TODO: If you need a page control, next or prev buttons add them via IB and connect them with these Outlets
@property (nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UIButton *prevButton;
@property (nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic) BOOL roundImages;
@property (nonatomic) NSDictionary *styles;
@property (nonatomic) NSMutableDictionary *items;
@property (nonatomic) UIColor *backgroundColor;

@property (nonatomic, readonly) NSInteger currentPage;

-(void)addViewController:(UIViewController*)vc;
-(void)populate;
-(void)populateWithDefault:(BOOL)pDefault;
-(NSMutableDictionary*)createItem:(NSString*)pKey withOptions:(NSDictionary*)pDictionary;

+(BOOL)walkthroughShown;
+(instancetype)initWithDelegate:(UIViewController<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor;
+(instancetype)initWithDelegate:(UIViewController<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor withStyles:(NSDictionary*)pStyles;

@end
