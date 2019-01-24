# VXWalkthroughViewController

VXWalkthroughViewController is a simple way to add an intro to your app.
Show your users the main features of your app, step by step. 
Your onboarding tutorial can include text, images and even simple html.

![VXWalkthroughViewController](https://cloud.githubusercontent.com/assets/314516/5762993/a2ec59da-9ce6-11e4-9c93-690b48eb93b5.png)

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

Add some steps to your `Localizable.strings` file, so it can be found using NSLocalizedString.
You can add as many steps as you like, but start at 0 and make them without steps.
If you want images, add them to your project with the predetermined names of `walkthrough_0.png`, `walkthrough_1.png`, etc.

```objective-c
"walkthrough_0" = "See No Evil";
"walkthrough_1" = "Hear No Evil";
"walkthrough_2" = "Speak No Evil";
```

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

## Release notes

### 1.0.16
Added task specific pageview controllers (e.g. login, signup, action, etc)
Added option to scan QR Code on login page view

### 1.0.15
Fix for IOS 11

### 1.0.12
Better handling of startup in different orientations
Locking of rotations once started to prevent display issues
Recompiled and fixed warnings under XCode 7.2.1

### 1.0.11
Implemented the option of controlling and dynamically modifying the population of tutorial screens.
The example shows the initiated automatic population and the modification of an image (better suited).

```objective-c
	[walkthrough populate];
	
	NSString *key = @"walkthrough_1";
	NSMutableDictionary* item = [[walkthrough.items valueForKey:key] mutableCopy];
	
	if(item) {
		NSString* imageName = [[self.categories firstObject] imageName];
		if(imageName) {
			[item setValue:imageName forKey:@"image"];
			[walkthrough.items setObject:item forKey:key];
		}
	}


```

### 1.0.10
Implemented suggestion of Jay Lyerly to add the option of using fullscreen images

```objective-c
	walkthrough.roundImages = NO;
```

## Credits

VXWalkthroughViewController is based on Yari D'areglia [BWWalkthrough](https://github.com/ariok/BWWalkthrough) and Sam Vermettes [SVWebViewController](https://github.com/samvermette/SVWebViewController).
VXWalkthroughViewController is brought to you by [Swift Management AG](http://www.swift.ch) and [contributors to the project](https://github.com/swiftmanagementag/VXWalkthroughViewController/contributors). If you have feature suggestions or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/swiftmanagementag/VXWalkthroughViewController/issues/new). If you're using VXWalkthroughViewController in your project, attribution is always appreciated.
