//
//  ICGViewController.h
//  ICGTransitionAnimation
//
//  Created by HuongDo on 5/12/14.
//  Copyright (c) 2014 ichigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICGBaseAnimation.h"

@interface ICGViewController : UIViewController <UIViewControllerTransitioningDelegate>

/**
 Animation for the transition
 */
@property (strong, nonatomic) ICGBaseAnimation *animationController;

/**
 Whether interaction should be enabled for transitioning
 */
@property (assign, nonatomic) BOOL interactionEnabled;

/** Inits with nib and transitioning animations
 @param animation Animation for the transition
 @return An instance of ICGFancyViewController
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withAnimation:(ICGBaseAnimation *) animation;

@end
