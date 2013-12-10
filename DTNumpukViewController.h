//
//  DTNumpukViewController.h
//
//  Created by Didats on 5/24/13.
//  Copyright (c) 2013 Didats Triadi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _DTNumpukState {
    DTNumpukStateFirstFocused = 1,
    DTNumpukStateSecondFocused,
    DTNumpukStateThirdFocused,
} DTNumpukState;

@protocol DTNumpukViewControllerDelegate <NSObject>

@optional;
-(void) firstViewFocused;
-(void) secondViewFocused;
-(void) thirdViewFocused;

@end

@interface DTNumpukViewController : UIViewController <UIGestureRecognizerDelegate> {
    DTNumpukState currentState;
}

@property (strong, nonatomic) UIViewController *firstViewController;
@property (strong, nonatomic) UIViewController *secondViewController;
@property (strong, nonatomic) UIViewController *thirdViewController;
@property (assign, nonatomic) id<DTNumpukViewControllerDelegate> delegate;
@property DTNumpukState numpukState;

-(void) showSecondViewWithViewController:(UIViewController *) viewController;
-(void) showThirdViewWithViewController:(UIViewController *) viewController;

@end
