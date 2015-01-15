# VXWalkthroughViewController

VXWalkthroughViewController is a simple way to add an intro to your app.
Show your users the main features of your app, step by step. 
Your onboarding tutorial can include text, images and even simple html.

![VXWalkthroughViewController](https://raw.githubusercontent.com/swiftmanagementag/VXWalkthroughViewController/master/screenshot.png)

**VXWalkthroughViewController features:**

* Simple to integrate
* Uses existing localisation for configuration
* Images supported
* iPhone and iPad support

## Installation

### CocoaPods

If you want to use VXWalkthroughViewController with CocoaPods
`pod 'VXWalkthroughViewController', :head`

### Manually

* Drag the `VXWalkthroughViewController/VXWalkthroughViewController` folder into your project.
* `#import "VXWalkthroughViewController.h"`

## Usage

(see sample Xcode project in `/Demo`)

Check if you should display the walkthrough in `viewDidload`:

```objective-c
if(![VXWalkthroughViewController walkthroughShown]) {
	// this is to avoid timing issues
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		// show the walkthrough
		[self showWalkthrough];
	});
}

```

This is the simplest way using the convenience method `VXWalkthroughModalViewController`:

```objective-c
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
```

## Credits

VXWalkthroughViewController is based on Yari D'areglia [BWWalkthrough](https://github.com/ariok/BWWalkthrough) and Sam Vermettes [SVWebViewController](https://github.com/samvermette/SVWebViewController).
VXWalkthroughViewController is brought to you by [Swift Management AG](http://www.swift.ch) and [contributors to the project](https://github.com/swiftmanagementag/VXWalkthroughViewController/contributors). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/swiftmanagementag/VXWalkthroughViewController/issues/new). If you're using VXWalkthroughViewController in your project, attribution is always appreciated.
