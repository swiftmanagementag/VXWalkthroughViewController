//
//  VXPromotionAppDelegate.h
//  VXPromotionViewController
//
//  Created by Swift Management AG on 18.12.2014.
//  Copyright 2011 Swift Management AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end

