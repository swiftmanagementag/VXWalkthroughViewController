//
//  VXPromotionAppDelegate.m
//  VXPromotionViewController
//
//  Created by Swift Management AG on 18.12.2014.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"


@implementation AppDelegate
@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark -
#pragma mark Memory management



@end

