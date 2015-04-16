//
//  VXWalkthroughPageViewController.m
//  auto123
//
//  Created by Graham Lancashire on 24.12.14.
//  Copyright (c) 2014 Swift Management AG. All rights reserved.
//

#import "VXWalkthroughPageViewController.h"
#if !defined(VX_NO_SLASH)
#import "Slash.h"
#endif

@interface VXWalkthroughPageViewController ()
	@property NSMutableArray *subsWeights;

@end

@implementation VXWalkthroughPageViewController 
- (instancetype)init {
	if(self =  [super init]) {
		// Edit these values using the Attribute inspector or modify directly the "User defined runtime attributes" in IB
		self.speed = CGPointMake(0.0f, 0.0f);            // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
		self.speedVariance= CGPointMake(0.0f, 0.0f);     // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
		self.animationType = Linear;
		self.animateAlpha = true;
		self.roundImages = true;
	}
	return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		// Edit these values using the Attribute inspector or modify directly the "User defined runtime attributes" in IB
		self.speed = CGPointMake(0.0f, 0.0f);            // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
		self.speedVariance= CGPointMake(0.0f, 0.0f);     // Note if you set this value via Attribute inspector it can only be an Integer (change it manually via User defined runtime attribute if you need a Float)
		self.animationType = Zoom;
		self.animateAlpha = false;
		self.roundImages = true;
	};
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	self.view.layer.masksToBounds = true;
	self.imageView.hidden = YES;
	self.titleView.hidden = YES;

	self.subsWeights = [NSMutableArray array];
	
	for(UIView __unused *v in self.view.subviews){
		CGPoint speed = self.speed;
		
		speed.x += self.speedVariance.x;
		speed.y += self.speedVariance.y;
		
		self.speed = speed;
		[self.subsWeights addObject: [NSValue valueWithCGPoint:self.speed]];
	}
}
-(void)setTitleText:(NSString *)titleText {
	self.titleView.hidden = NO;
	_titleText = titleText;
	
	double fontSize = 24.0;

#if defined(VX_NO_SLASH)
	NSDictionary *textAttributes = @{NSFontAttributeName  : [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor whiteColor]};
	NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleText attributes:textAttributes] ;

#else
	if(!self.styles) {
		self.styles = @{
							@"$default" : @{NSFontAttributeName  : [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor whiteColor]},
							@"b"		: @{NSFontAttributeName  : [UIFont boldSystemFontOfSize:fontSize]},
							@"em"		: @{NSFontAttributeName  : [UIFont boldSystemFontOfSize:fontSize], NSForegroundColorAttributeName: [UIColor whiteColor]}
							};
	}
	NSAttributedString *attributedString = [SLSMarkupParser attributedStringWithMarkup:_titleText style:self.styles error:NULL] ;
#endif
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	
	NSMutableAttributedString *alignedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];

	[alignedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [alignedString length])];
	
	self.titleView.attributedText = alignedString;
}
-(void)setImageName:(NSString *)imageName {
	self.imageView.hidden = NO;
	self.imageView.image = [UIImage imageNamed:imageName];
}
-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	if(self.roundImages){
		[self roundImageView:self.imageView];
	}
}

-(void)roundImageView:(UIImageView*)pImageView  {
	pImageView.layer.borderWidth = 3.0;
	pImageView.layer.borderColor = [UIColor whiteColor].CGColor;
	pImageView.layer.shadowColor = [UIColor grayColor].CGColor;
	pImageView.layer.shadowRadius = 6.0;
	pImageView.layer.shadowOpacity = 0.5;
	
	pImageView.layer.cornerRadius = pImageView.frame.size.width / 2;
	pImageView.clipsToBounds = true;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)walkthroughDidScroll:(CGFloat)position withOffset:(CGFloat)offset {
	for(NSInteger i = 0; i < self.subsWeights.count ;i++){
		// Perform Transition/Scale/Rotate animations
		switch(self.animationType) {
			case Linear:
				[self animationLinearWithIndex:i withOffset:offset];
				break;
			case Zoom:
				[self animationZoomWithIndex:i withOffset:offset];
				break;
			case Curve:
				[self animationCurveWithIndex:i withOffset:offset];
				break;
			case InOut:
				[self animationInOutWithIndex:i withOffset:offset];
				break;
		}
	 
		// Animate alpha
		if(self.animateAlpha){
			[self animationAlphaWithIndex:i withOffset:offset];
		}
	}
}

-(void)animationAlphaWithIndex:(NSInteger)index withOffset:(CGFloat)offset {
	UIView *cView = (UIView*)self.view.subviews[index];
 
	if(offset > 1.0){
		offset = 1.0 + (1.0 - offset);
	}
	cView.alpha = offset;
}

-(void)animationCurveWithIndex:(NSInteger)index withOffset:(CGFloat)offset {
	CATransform3D transform =  CATransform3DIdentity;
	CGFloat x = (1.0 - offset) * 10;
	transform = CATransform3DTranslate(transform, (pow(x,3) - (x * 25)) * [self.subsWeights[index] CGPointValue].x, (pow(x,3) - (x * 20)) * [self.subsWeights[index] CGPointValue].y, 0 );
	UIView *cView = (UIView*)self.view.subviews[index];
	cView.layer.transform = transform;
}

-(void)animationZoomWithIndex:(NSInteger)index withOffset:(CGFloat)offset {
	CATransform3D transform =  CATransform3DIdentity;
 
	CGFloat tmpOffset = offset;
	if(tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	CGFloat scale = (1.0 - tmpOffset);
	transform = CATransform3DScale(transform, 1 - scale , 1 - scale, 1.0);
	UIView *cView = (UIView*)self.view.subviews[index];
	cView.layer.transform = transform;
}

-(void)animationLinearWithIndex:(NSInteger)index withOffset:(CGFloat)offset {
	CATransform3D transform =  CATransform3DIdentity;
	CGFloat mx = (1.0 - offset) * 100;
	transform = CATransform3DTranslate(transform, mx * [self.subsWeights[index] CGPointValue].x, mx * [self.subsWeights[index] CGPointValue].y, 0 );
	UIView *cView = (UIView*)self.view.subviews[index];
	cView.layer.transform = transform;
}

-(void)animationInOutWithIndex:(NSInteger)index withOffset:(CGFloat)offset {
	CATransform3D transform =  CATransform3DIdentity;
	// CGFloat x = (1.0 - offset) * 20;
	CGFloat tmpOffset = offset;
	if(tmpOffset > 1.0){
		tmpOffset = 1.0 + (1.0 - tmpOffset);
	}
	transform = CATransform3DTranslate(transform, (1.0 - tmpOffset) * [self.subsWeights[index] CGPointValue].x * 100, (1.0 - tmpOffset) * [self.subsWeights[index] CGPointValue].y * 100, 0);
	UIView *cView = (UIView*)self.view.subviews[index];
	cView.layer.transform = transform;
}

@end