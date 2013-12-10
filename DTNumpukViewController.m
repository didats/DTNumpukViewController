//
//  DTNumpukViewController.m
//
//  Created by Didats on 5/24/13.
//  Copyright (c) 2013 Didats Triadi. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "DTNumpukViewController.h"

@interface DTNumpukViewController () {
    NSInteger defaultTag;
    UIView *firstView, *secondView, *thirdView;
    CGSize screenDimension;
    NSArray *arrViews, *arrViewControllers;
    UIPanGestureRecognizer *panGesture1, *panGesture2;
    CGFloat firstPosition, firstTouchX, firstTouchY;
    UIView *selectedView;
    float movingAnimation;
}

@end

@implementation DTNumpukViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // screen dimension
    screenDimension = [UIScreen mainScreen].applicationFrame.size;
    
    // if ios7, +20 on the height
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        screenDimension = CGSizeMake(screenDimension.width, screenDimension.height + 20);
    }
    
    // set current state and status
    currentState = DTNumpukStateSecondFocused;
    self.numpukState = currentState;
    
    firstTouchX = 0.0;
    firstTouchY = 0.0;
    movingAnimation = 0.1;
    defaultTag = 1000;
    
    // create view with full screen size
    firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenDimension.width, screenDimension.height)];
    secondView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, screenDimension.width, screenDimension.height)];
    thirdView = [[UIView alloc] initWithFrame:CGRectMake(270, 0, screenDimension.width, screenDimension.height)];
    
    // add them to the array so it will be easier to manage them.
    // ordered decending
    arrViews = @[firstView, secondView, thirdView];
    arrViewControllers = @[self.firstViewController, self.secondViewController, self.thirdViewController];
    NSArray *bgColors = @[UIColorFromRGB(0x242424),UIColorFromRGB(0x242424), UIColorFromRGB(0x242424)];
    
    // make all of them black background with corner radius
    for (int i = 0; i < [arrViews count]; i++) {
        UIView *currentView = (UIView *)[arrViews objectAtIndex:i];
        
        [currentView setBackgroundColor:[bgColors objectAtIndex:i]];
        [[currentView layer] setShadowColor:[UIColor blackColor].CGColor];
        [[currentView layer] setShadowOpacity:1];
        [[currentView layer] setShadowOffset:CGSizeMake(1.0, 1.0)];
        
        CGRect shadowPath = CGRectMake(currentView.bounds.origin.x - 5, currentView.bounds.origin.y, currentView.bounds.size.width, currentView.bounds.size.height);
        
        [[currentView layer] setShadowPath:[UIBezierPath bezierPathWithRect:shadowPath].CGPath];
        
        // set tag
        [currentView setTag:i+1];
        
        // add them to the root view
        [self.view addSubview:[arrViews objectAtIndex:i]];
        
        // add each view to view controller
        UIViewController *objViewController = [arrViewControllers objectAtIndex:i];
        [self addChildViewController:objViewController];
        [objViewController.view setFrame:CGRectMake(0, 0, screenDimension.width, screenDimension.height)];
        [objViewController.view.layer setCornerRadius:6.0];
        [objViewController.view.layer setMasksToBounds:YES];
        [objViewController.view setBackgroundColor:[bgColors objectAtIndex:i]];
        [currentView addSubview:objViewController.view];
        
        // create button to enable the clicked area
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, screenDimension.width/3, screenDimension.height)];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setHidden:(i == 1) ? YES : NO];
        [button setTag:1000];
        [currentView addSubview:button];
    }
    
    // add gesture to second view and the third view
    [self addGestureToView:secondView];
    [self addGestureToView:thirdView];
}

#pragma mark - Public Methods
-(void) showSecondViewWithViewController:(UIViewController *)viewController {
    // if view controller nil, just go to the state
    if (viewController == nil) {
        [self animateViewToState:DTNumpukStateSecondFocused];
    }
    else {
        
        // need to remove and add new view controller
        UIViewController *previous = self.secondViewController;
        
        if (previous != viewController) {
            [previous willMoveToParentViewController:nil];
            [previous.view removeFromSuperview];
            [previous removeFromParentViewController];
            
            if (viewController) {
                [self addChildViewController:viewController];
                [secondView addSubview:viewController.view];
                
                // set the button on top of it
                [secondView bringSubviewToFront:[secondView viewWithTag:1000]];
                
                [self animateViewToState:DTNumpukStateSecondFocused];
            }
        }
        
    }
}
-(void) showThirdViewWithViewController:(UIViewController *) viewController {
    if (viewController == nil) {
        [self animateViewToState:DTNumpukStateThirdFocused];
    }
    else {
        // need to remove and add new view controller
        UIViewController *previous = self.thirdViewController;
        
        if (previous != viewController) {
            [previous willMoveToParentViewController:nil];
            [previous.view removeFromSuperview];
            [previous removeFromParentViewController];
            
            if (viewController) {
                [self addChildViewController:viewController];
                [thirdView addSubview:viewController.view];
                
                // set the button on top of it
                [thirdView bringSubviewToFront:[thirdView viewWithTag:1000]];
                
                [self animateViewToState:DTNumpukStateThirdFocused];
            }
        }
    }
}

#pragma mark - Private Methods

-(void) animateViewToState:(DTNumpukState)toState {
    
    // focus on the first view
    if(toState == DTNumpukStateFirstFocused) {
        [UIView animateWithDuration:movingAnimation animations:^{
            [secondView setFrame:CGRectMake(220, 0, screenDimension.width, screenDimension.height)];
            [thirdView setFrame:CGRectMake(270, 0, screenDimension.width, screenDimension.height)];
        } completion:^(BOOL finished) {
            // show the button
            [[firstView viewWithTag:1000] setHidden:YES];
            [[secondView viewWithTag:1000] setHidden:NO];
            [[thirdView viewWithTag:1000] setHidden:NO];
            
            // call delegate
            if ([self.delegate respondsToSelector:@selector(firstViewFocused)]) {
                [self.delegate firstViewFocused];
            }
        }];
    }
    // focus on the second view
    else if(toState == DTNumpukStateSecondFocused) {
        [UIView animateWithDuration:movingAnimation animations:^{
            [secondView setFrame:CGRectMake(50, 0, screenDimension.width, screenDimension.height)];
            [thirdView setFrame:CGRectMake(270, 0, screenDimension.width, screenDimension.height)];
        } completion:^(BOOL finished) {
            // show the button
            [[firstView viewWithTag:1000] setHidden:NO];
            [[secondView viewWithTag:1000] setHidden:YES];
            [[thirdView viewWithTag:1000] setHidden:NO];
            
            // call delegate
            if ([self.delegate respondsToSelector:@selector(secondViewFocused)]) {
                [self.delegate secondViewFocused];
            }
        }];
    }
    // focus on the third view
    else if(toState == DTNumpukStateThirdFocused) {
        [UIView animateWithDuration:movingAnimation animations:^{
            [secondView setFrame:CGRectMake(50, 0, screenDimension.width, screenDimension.height)];
            [thirdView setFrame:CGRectMake(0, 0, screenDimension.width, screenDimension.height)];
        } completion:^(BOOL finished) {
            // show the button
            [[firstView viewWithTag:1000] setHidden:NO];
            [[secondView viewWithTag:1000] setHidden:YES];
            [[thirdView viewWithTag:1000] setHidden:YES];
            
            // call delegate
            if ([self.delegate respondsToSelector:@selector(thirdViewFocused)]) {
                [self.delegate thirdViewFocused];
            }
        }];
    }
}

-(void) animateViewWithMovingFactor:(float) factor andView:(UIView *) view {
    
    if (view.tag == 2) {
        // user drag the second view
        
        if (view.frame.origin.x >= 150) {
            // focus on the first view
            [self animateViewToState:DTNumpukStateFirstFocused];
        }
        else {
            // go back to focus on the second view
            [self animateViewToState:DTNumpukStateSecondFocused];
        }
    }
    else if (view.tag == 3) {
        if (view.frame.origin.x >= 160) {
            [self animateViewToState:DTNumpukStateSecondFocused];
        }
        else {
            [self animateViewToState:DTNumpukStateThirdFocused];
        }
    }
}

-(void) addGestureToView: (UIView *) view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 100;
    panGesture.minimumNumberOfTouches = 1;
    [view addGestureRecognizer:panGesture];
}

-(void) handlePan:(UIGestureRecognizer *)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        
        CGPoint translatedPoint = [pan translationInView:self.view];
        
        // get the position on the first touch
        if (sender.state == UIGestureRecognizerStateBegan) {
            firstTouchY = pan.view.center.y;
            firstTouchX = pan.view.center.x;
        }
        
        // set center based on the dragging position
        translatedPoint = CGPointMake(firstTouchX + translatedPoint.x, firstTouchY);
        [pan.view setCenter:translatedPoint];
        
        if (sender.state == UIGestureRecognizerStateEnded) {
            float slideFactor = movingAnimation;
            slideFactor = slideFactor * pan.view.frame.origin.x;
            
            [self animateViewWithMovingFactor:slideFactor andView:pan.view];
        }
        else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
            float slideFactor = movingAnimation;
            slideFactor = slideFactor * pan.view.frame.origin.x;
            
            [self animateViewWithMovingFactor:slideFactor andView:pan.view];
        }
    }
}

-(void) buttonClicked:(id) sender {
    // tap on the first view
    if ([sender superview].tag == 1) {
        [self animateViewToState:DTNumpukStateFirstFocused];
    }
    // tap on the second view
    else if([sender superview].tag == 2) {
        [self animateViewToState:DTNumpukStateSecondFocused];
    }
    // tap on the third view
    else if([sender superview].tag == 3) {
        [self animateViewToState:DTNumpukStateThirdFocused];
    }
}

-(void) removeGestureFromView:(UIView *) view {
    if ([view.gestureRecognizers count] > 0) {
        for (UIGestureRecognizer *recognizer in view.gestureRecognizers) {
            [view removeGestureRecognizer:recognizer];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
