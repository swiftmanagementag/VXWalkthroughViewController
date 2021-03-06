//
//  VXWalkthroughViewController.m
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import "VXWalkthroughViewController.h"
#import "VXWalkthroughPageViewController.h"

@interface VXWalkthroughViewController ()

@property (nonatomic) UIScrollView *scrollview;
@property (nonatomic) NSMutableArray *controllers;
@property (nonatomic) NSArray *lastViewConstraint;

@end

@implementation VXWalkthroughViewController

+ (NSString *)storyboardName {
	return @"VXWalkthroughViewController";
}

+ (NSString *)storyboardID {
	return @"Walkthrough";
}

-(instancetype)init{
	if(self = [super init]) {
		self.scrollview = [[UIScrollView alloc] init];
		self.controllers = [NSMutableArray array];
		self.roundImages = true;
	};
	
	return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		// Setup the scrollview
		self.scrollview = [[UIScrollView alloc] init];
		self.scrollview.showsHorizontalScrollIndicator = false;
		self.scrollview.showsVerticalScrollIndicator = false;
		self.scrollview.pagingEnabled = true;
		
		// Controllers as empty array
		self.controllers = [NSMutableArray array];
		self.roundImages = true;
		
		
	};
	
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

	// load walkthrough
	[self load];
	
	// Do any additional setup after loading the view.
	self.scrollview.delegate = self;
	self.scrollview.translatesAutoresizingMaskIntoConstraints = false;
	
	[self.view insertSubview:self.scrollview atIndex: 0]; //scrollview is inserted as first view of the hierarchy

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scrollview]-0-|"
																	   options:0
																	   metrics:nil
																		 views:@{@"scrollview":self.scrollview}]];

	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scrollview]-0-|"
																	  options:0
																	  metrics:nil
																		views:@{@"scrollview":self.scrollview}]];

}
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.pageControl.numberOfPages = self.controllers.count;
	self.pageControl.currentPage = 0;
	[self updateUI];
	
	NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
	NSString *startInfoKey = [NSString stringWithFormat:@"vxwalkthroughshown_%@", appVersion];
	
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:startInfoKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)walkthroughShown {
	// check if the startup info has been shown for the current release
	NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
	NSString *startInfoKey = [NSString stringWithFormat:@"vxwalkthroughshown_%@", appVersion];
	
	NSString *walkthroughShown = [[NSUserDefaults standardUserDefaults] stringForKey:startInfoKey];
	
	return [walkthroughShown isEqualToString:@"YES"];
}

+(instancetype)initWithDelegate:(NSObject<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor {
	return [VXWalkthroughViewController initWithDelegate:pDelegate withBackgroundColor:pBackgroundColor withStyles:nil];
}
+(instancetype)initWithDelegate:(NSObject<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor withStyles:(NSDictionary*)pStyles{
	NSBundle* bundle = [NSBundle bundleForClass:self.classForCoder];
	
	UIStoryboard *stb = [UIStoryboard storyboardWithName:VXWalkthroughViewController.storyboardName bundle:bundle];
	if(!stb) {
		stb = [UIStoryboard storyboardWithName:VXWalkthroughViewController.storyboardName bundle:nil];
	}
	
	VXWalkthroughViewController* walkthrough = [stb instantiateViewControllerWithIdentifier: VXWalkthroughViewController.storyboardID];

	walkthrough.backgroundColor = pBackgroundColor;
	walkthrough.delegate = pDelegate;
	walkthrough.styles = pStyles;
	walkthrough.roundImages = YES;
	return walkthrough;
}
-(VXWalkthroughPageViewController*)createPageViewControllerWithTitle:(NSString*)pTitle  andImageName:(NSString*)pImageName {
	return [self createPageViewControllerWithItem:@{VX_TITLE: pTitle, VX_IMAGE: pImageName}];
}
-(VXWalkthroughPageViewController*)createPageViewControllerWithItem:(NSDictionary*)pItem {
	NSBundle* bundle = [NSBundle bundleForClass:self.classForCoder];
	
	UIStoryboard *stb = [UIStoryboard storyboardWithName:VXWalkthroughViewController.storyboardName bundle:bundle];
	if(!stb) {
		stb = [UIStoryboard storyboardWithName:VXWalkthroughViewController.storyboardName bundle:nil];
	}
	
	NSString *storyboardID = pItem[@"storyboardID"] ?: VXWalkthroughPageViewController.storyboardID;
	VXWalkthroughPageViewController* vc = [stb instantiateViewControllerWithIdentifier:storyboardID];
	
	vc.styles = self.styles;
	vc.roundImages = self.roundImages;
	vc.parent = self;
	vc.view.backgroundColor = self.backgroundColor;
	
	vc.item = pItem;
	
	return vc;
}

-(NSMutableDictionary*)createItem:(NSString*)pKey withOptions:(NSDictionary*)pDictionary {
	NSString *text = NSLocalizedString(pKey, nil);
	NSString *buttonTitle = NSLocalizedString([pKey stringByAppendingString:@"_button"], nil);
	
	NSString *imageName = [pKey stringByAppendingString:@".png"];
	NSNumber *sort = [NSNumber numberWithInteger:1];
	
	NSDictionary* item = @{VX_KEY: pKey, VX_TITLE: text, VX_IMAGE: imageName, VX_SORT: sort,VX_BUTTONTITLE: buttonTitle };
	
	NSMutableDictionary* itemResult  = [NSMutableDictionary dictionaryWithDictionary:item];
									
	[itemResult addEntriesFromDictionary:pDictionary];
	
	return itemResult;
}
-(void)populate {
	[self populateWithDefault:true];
}

-(void)populateWithDefault:(BOOL)pDefault {
	self.items = [[NSMutableDictionary alloc] init];
	
	if(pDefault) {
		// setup pages
		NSInteger step = 0;
		NSString *stepKey = [NSString stringWithFormat:@"walkthrough_%li", (long)step];

		NSString* stepText = NSLocalizedString(stepKey, @"");

		while ([stepText length] != 0 && ![stepText isEqualToString:stepKey]) {
			NSDictionary* item = @{VX_KEY: stepKey, VX_TITLE: stepText, VX_IMAGE: stepKey, VX_SORT: [NSNumber numberWithInteger:step * 10]};
			[self.items setObject:item forKey:stepKey];
		
			step++;
		
			stepKey = [NSString stringWithFormat:@"walkthrough_%li", (long)step];
			stepText = NSLocalizedString(stepKey, @"");
		}
	}
}
-(void)load {
	if(self.items == nil || self.items.count == 0) {
		[self populate];
	}
	
	if(self.controllers == nil || self.controllers.count == 0){
		NSArray *keys = [self.items keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
			if ([obj1[VX_SORT] integerValue] > [obj2[VX_SORT] integerValue]) {
		
				return (NSComparisonResult)NSOrderedDescending;
			}
			if ([obj1[VX_SORT] integerValue] < [obj2[VX_SORT] integerValue]) {
				
				return (NSComparisonResult)NSOrderedAscending;
			}
			
			return (NSComparisonResult)NSOrderedSame;
		}];
		
		for(NSString *key in keys) {
			NSDictionary* item = self.items[key];
			
			VXWalkthroughPageViewController* vc = [self createPageViewControllerWithItem:item];
			if (vc) {
				vc.key = key;
				[self addViewController:vc];
			}
			
		}
	}
	
	self.view.backgroundColor = self.backgroundColor;
}


 // The index of the current page (readonly)
- (NSInteger)currentPage{
	return (NSInteger)(self.scrollview.contentOffset.x / self.view.bounds.size.width);
}
-(VXWalkthroughPageViewController*)currentController {
	if (self.currentPage < self.controllers.count) {
		return self.controllers[self.currentPage];
	}
	return nil;
}
-(VXWalkthroughPageViewController*)controllerWithKey:(NSString*)pKey {
	NSInteger controllerIndex = [self.controllers indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return ([((VXWalkthroughPageViewController *)obj).key  isEqualToString:pKey]);
	}];

	if(controllerIndex >= 0 && controllerIndex < self.controllers.count) {
		return self.controllers[controllerIndex];
	} else {
		return nil;
	}
	
}
-(IBAction)nextPage{
	if (self.currentPage + 1 < self.controllers.count) {
		if([self.delegate respondsToSelector:@selector(walkthroughNextButtonPressed)]) {
			[self.delegate walkthroughNextButtonPressed];
		}
		CGRect frame = self.scrollview.frame;
		frame.origin.x = ((CGFloat)self.currentPage + 1.0f) * frame.size.width;
		[self.scrollview scrollRectToVisible:frame animated: true];
	}
}

-(IBAction)prevPage{
	if(self.currentPage > 0) {
		if([self.delegate respondsToSelector:@selector(walkthroughPrevButtonPressed)]) {
			[self.delegate walkthroughPrevButtonPressed];
		}
		CGRect frame = self.scrollview.frame;
		frame.origin.x = ((CGFloat)self.currentPage - 1.0f) * frame.size.width;
		[self.scrollview scrollRectToVisible:frame animated: true];
	}
}

// TODO: If you want to implement a "skip" option
// connect a button to this IBAction and implement the delegate with the skipWalkthrough
-(IBAction)close:(id)sender{
	if([self.delegate respondsToSelector:@selector(walkthroughCloseButtonPressed:)]) {
		[self.delegate walkthroughCloseButtonPressed:self];
	}
}

// Add a new page to the walkthrough.
// To have information about the current position of the page in the walkthrough add a UIVIewController which implements BWWalkthroughPage

-(void)addViewController:(UIViewController*)vc {
	[self.controllers addObject:vc];
	
	// Setup the viewController view
	vc.view.translatesAutoresizingMaskIntoConstraints = false;
	[self.scrollview addSubview:vc.view];
	
	// Constraints
	
	NSDictionary* metricDict = @{@"w": [NSNumber numberWithDouble:vc.view.bounds.size.width],@"h":[NSNumber numberWithDouble:vc.view.bounds.size.height]};
	
	// - Generic cnst
	[vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]"
																	  options:0
																	  metrics:metricDict
																		views:@{@"view":vc.view}]];
	[vc.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(w)]"
																	options:0
																	metrics:metricDict
																	  views:@{@"view":vc.view}]];

	[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]|"
																	options:0
																	metrics:nil
																	  views:@{@"view":vc.view}]];
	
	// cnst for position: 1st element
	
	if(self.controllers.count == 1){
		[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]"
																				options:0
																				metrics:nil
																				  views:@{@"view":vc.view}]];
		
		// cnst for position: other elements
		
	} else {
		
		UIViewController* previousVC = self.controllers[self.controllers.count-2];
		UIView* previousView = previousVC.view;
		
		[self.scrollview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-0-[view]"
																				options:0
																				metrics:nil
																				  views:@{@"previousView":previousView, @"view":vc.view}]];
		if(self.lastViewConstraint){
			[self.scrollview removeConstraints:self.lastViewConstraint];
		}
		self.lastViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-0-|"
												options:0
												metrics:nil
																			views:@{@"view":vc.view}];
		[self.scrollview addConstraints:self.lastViewConstraint ];
	}
}
//Update the UI to reflect the current walkthrough situation

-(void)updateUI{
	// Get the current page
	self.pageControl.currentPage = self.currentPage;
	
	// Notify delegate about the new page
	if([self.delegate respondsToSelector:@selector(walkthroughPageDidChange:)]) {
		[self.delegate walkthroughPageDidChange:self.currentPage];
	}
	// Hide/Show navigation buttons
	if(self.currentPage == self.controllers.count - 1 || self.controllers.count == 1){
		self.nextButton.hidden = true;
	}else{
		self.nextButton.hidden = false;
	}
	
	if(self.currentPage == 0 || self.controllers.count == 1){
		self.prevButton.hidden = true;
	}else{
		self.prevButton.hidden = false;
	}
	self.pageControl.hidden = (self.controllers.count <= 1);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	for(NSInteger i=0; i < self.controllers.count; i++) {
		id<VXWalkthroughPage> vc = self.controllers[i];
		if(vc){
			CGFloat mx = ((scrollView.contentOffset.x + self.view.bounds.size.width) - (self.view.bounds.size.width * (CGFloat)i)) / self.view.bounds.size.width;
			
			// While sliding to the "next" slide (from right to left), the "current" slide changes its offset from 1.0 to 2.0 while the "next" slide changes it from 0.0 to 1.0
			// While sliding to the "previous" slide (left to right), the current slide changes its offset from 1.0 to 0.0 while the "previous" slide changes it from 2.0 to 1.0
			// The other pages update their offsets whith values like 2.0, 3.0, -2.0... depending on their positions and on the status of the walkthrough
			// This value can be used on the previous, current and next page to perform custom animations on page's subviews.
			
			// print the mx value to get more info.
			// println("\(i):\(mx)")
			
			// We animate only the previous, current and next page
			if(mx < 2 && mx > -2.0){
				[vc walkthroughDidScroll:scrollView.contentOffset.x withOffset: mx];
			}
		}
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
	[self updateUI];
}

-(void) scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView {
	[self updateUI];
}
-(BOOL)shouldAutorotate {
    return NO;
}
@end
