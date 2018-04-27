//
//  VXWalkthroughPageViewLoginController.m
//  Pods
//
//  Created by Graham Lancashire on 27.04.18.
//

#import <Foundation/Foundation.h>
#import "VXWalkthroughPagePermissionViewController.h"

@interface VXWalkthroughPagePermissionViewController ()
@end

@implementation VXWalkthroughPagePermissionViewController


- (instancetype)init {
	if(self =  [super init]) {
	}
	return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
	};
	
	return self;
}
	
- (void)viewDidLoad {
	[super viewDidLoad];
}
	
- (IBAction)actionClicked:(id)sender {
	
}
	+ (NSString *)storyboardID {
		return @"WalkthroughPagePermission";
	}

@end
