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
-(instancetype)init{
	if(self = [super init]) {
		self.scrollview = [[UIScrollView alloc] init];
		self.controllers = [NSMutableArray array];
        self.roundImages = true;
        self.bigImages = true;
        self.imageContentMode = UIViewContentModeScaleToFill;
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
        self.bigImages = true;
        self.imageContentMode = UIViewContentModeScaleToFill;
	};
	
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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

	// @["scrollview":self.scrollview]
}
-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.pageControl.numberOfPages = self.controllers.count;
	self.pageControl.currentPage = 0;
	
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"vxwalkthroughshown"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	
}
+(BOOL)walkthroughShown {
	NSString *walkthroughShown = [[NSUserDefaults standardUserDefaults] stringForKey:@"vxwalkthroughshown"];
	
	return [walkthroughShown isEqualToString:@"YES"];
}

+(instancetype)initWithDelegate:(UIViewController<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor {
	return [VXWalkthroughViewController initWithDelegate:pDelegate withBackgroundColor:pBackgroundColor withStyles:nil];
}
+(instancetype)initWithDelegate:(UIViewController<VXWalkthroughViewControllerDelegate>*)pDelegate withBackgroundColor:(UIColor*)pBackgroundColor withStyles:(NSDictionary*)pStyles{
	UIStoryboard *stb = [UIStoryboard storyboardWithName:@"VXWalkthroughViewController" bundle:nil];
	VXWalkthroughViewController* walkthrough = [stb instantiateViewControllerWithIdentifier:@"Walkthrough"];

	walkthrough.view.backgroundColor = pBackgroundColor;
	walkthrough.backgroundColor = pBackgroundColor;
	walkthrough.delegate = pDelegate;
	walkthrough.styles = pStyles;
	
	[walkthrough load];
	
	return walkthrough;
}
-(void)load {
	UIStoryboard *stb = [UIStoryboard storyboardWithName:@"VXWalkthroughViewController" bundle:nil];
	
	// setup pages
	NSInteger step = 0;
	NSString *stepKey = [NSString stringWithFormat:@"walkthrough_%li", (long)step];

	NSString* stepText = NSLocalizedString(stepKey, @"");

	while ([stepText length] != 0 && ![stepText isEqualToString:stepKey]) {
		VXWalkthroughPageViewController* vc = [stb instantiateViewControllerWithIdentifier:@"WalkthroughPage"];
		vc.styles = self.styles;
        vc.roundImages = self.roundImages;
        vc.bigImages = self.bigImages;
        vc.imageContentMode = self.imageContentMode;

		vc.view.backgroundColor = self.backgroundColor;
		vc.titleText = stepText;
		vc.imageName = [NSString stringWithFormat:@"walkthrough_%li.png", (long)step];
		[self addViewController:vc];
		
		step++;
		
		stepKey = [NSString stringWithFormat:@"walkthrough_%li", (long)step];
		stepText = NSLocalizedString(stepKey, @"");
		
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 // The index of the current page (readonly)
- (NSInteger)currentPage{
	return (NSInteger)(self.scrollview.contentOffset.x / self.view.bounds.size.width);
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
		self.lastViewConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-|"
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
	if(self.currentPage == self.controllers.count - 1){
		self.nextButton.hidden = true;
	}else{
		self.nextButton.hidden = false;
	}
	
	if(self.currentPage == 0){
		self.prevButton.hidden = true;
	}else{
		self.prevButton.hidden = false;
	}
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

- (void)setRoundImages:(BOOL)roundImages {
    _roundImages = roundImages;
    for (VXWalkthroughPageViewController *controller in self.controllers) {
        controller.roundImages = roundImages;
    }
}

- (void)setBigImages:(BOOL)bigImages {
    _bigImages = bigImages;
    for (VXWalkthroughPageViewController *controller in self.controllers) {
        controller.bigImages = bigImages;
    }
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    for (VXWalkthroughPageViewController *controller in self.controllers) {
        controller.imageContentMode = imageContentMode;
    }
}

/*
override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
	println("CHANGE")
}

override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
	println("SIZE")
}
*/
@end