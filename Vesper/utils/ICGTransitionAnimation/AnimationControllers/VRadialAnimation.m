//
//  VRadialAnimation.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 01.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VRadialAnimation.h"

#import "VUtils.h"

#import "VObjectsListViewController.h"
#import "VObjectInfoViewController.h"
#import "VPhotoesViewController.h"

#define kZoom (2.2f * [UIScreen mainScreen].bounds.size.height)

@implementation VRadialAnimation

@synthesize contentView;

@synthesize point;

+ (id)sharedAnimation {
    static VRadialAnimation *radialAnimation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        radialAnimation = [[self alloc] init];
    });
    return radialAnimation;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        point.x = SCREEN_WIDTH / 2;
        point.y = SCREEN_HEIGHT / 2;
        _subtype = VRadialSubtypeFromLogotypeToList;
    }
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
                 fromView:(UIView *)fromView
                   toView:(UIView *)toView {
    UIView *circleView = [[UIView alloc] init];
    [circleView setFrame:CGRectMake(point.x - 1.f, point.y - 1.f, 2.f, 2.f)];
    [VUtils applyCornerRadii:@[@(circleView.frame.size.height / 2)]
                    forViews:@[circleView]];
    [circleView setTransform:CGAffineTransformMakeScale(0.f, 0.f)];
    UIView *containerView = [transitionContext containerView];
    CGRect initialFrame;
    if (self.modalTransition) {
        initialFrame = containerView.frame;
    } else {
        initialFrame = [transitionContext initialFrameForViewController:self.fromViewController];
    }
    fromView.frame = initialFrame;
    toView.frame = initialFrame;
    [containerView addSubview:circleView];
    [containerView addSubview:toView];
    switch (_subtype) {
        case VRadialSubtypeFromLogotypeToList: {
            CGFloat duration = 1.8f;
            VObjectsListViewController *toViewController = (VObjectsListViewController *)self.toViewController;
            [circleView setBackgroundColor:RGB(58.f, 62.f, 66.f)];
            [toView setBackgroundColor:[UIColor clearColor]];
            [toViewController.contentView setAlpha:0.f];
            [toViewController.contentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
            [toViewController.pageControl setAlpha:0.f];
            [UIView animateWithDuration:duration
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [circleView setTransform:CGAffineTransformMakeScale(kZoom, kZoom)];
                             }
                             completion:nil];
            CGFloat delay = .38f * duration;
            [UIView animateWithDuration:duration - delay
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.contentView setAlpha:1.f];
                                 [toViewController.contentView setTransform:CGAffineTransformIdentity];
                                 [toViewController.pageControl setAlpha:1.f];
                             }
                             completion:^(BOOL finished) {
                                 [toView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [transitionContext completeTransition:YES];
                             }];
        }
            break;
        case VRadialSubtypeFromListToInfo: {
            CGFloat duration = 1.08f;
            VObjectsListViewController *fromViewController = (VObjectsListViewController *)self.fromViewController;
            VObjectInfoViewController *toViewController = (VObjectInfoViewController *)self.toViewController;
            [toViewController.backButton setTransform:CGAffineTransformMakeTranslation(-44.f, 0.f)];
            [toViewController.shareButton setTransform:CGAffineTransformMakeTranslation(44.f, 0.f)];
            [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
            [UIView animateWithDuration:duration
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [circleView setTransform:CGAffineTransformMakeScale(kZoom, kZoom)];
                             }
                             completion:nil];
            [UIView animateWithDuration:duration / 2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [fromViewController.logotypeImageView setTransform:CGAffineTransformMakeTranslation(0.f, -64.f)];
                                 [fromViewController.menuButton setTransform:CGAffineTransformMakeTranslation(-44.f, 0.f)];
                                 [fromViewController.filterButton setTransform:CGAffineTransformMakeTranslation(44.f, 0.f)];
                                 [fromViewController.pageControl setTransform:CGAffineTransformMakeTranslation(0.f, 37.f)];
                                 [fromViewController.updatesCountLabel setAlpha:0.f];
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:duration / 2
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      [toViewController.backButton setTransform:CGAffineTransformIdentity];
                                                      [toViewController.shareButton setTransform:CGAffineTransformIdentity];
                                                  }
                                                  completion:nil];
                             }];
            [toView setAlpha:1.f];
            [toView setTransform:CGAffineTransformIdentity];
            CGFloat delay = .2f * duration;
            [toViewController.carouselContentView setAlpha:0.f];
            [toViewController.carouselContentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
            [UIView animateWithDuration:duration - delay
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.carouselContentView setAlpha:1.f];
                                 [toViewController.carouselContentView setTransform:CGAffineTransformIdentity];
                             }
                             completion:^(BOOL finished) {
                                 _subtype = VRadialSubtypeFromInfoToList;
                                 [transitionContext completeTransition:YES];
                             }];
            [toViewController.titleLabel setAlpha:0.f];
            [toViewController.titleLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .3f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.titleLabel setAlpha:1.f];
                                 [toViewController.titleLabel setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.addressLabel setAlpha:0.f];
            [toViewController.addressLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .4f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.addressLabel setAlpha:1.f];
                                 [toViewController.addressLabel setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.descriptionLabel setAlpha:0.f];
            [toViewController.descriptionLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            [toViewController.orangeLineView setAlpha:0.f];
            [toViewController.orangeLineView setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .5f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.descriptionLabel setAlpha:1.f];
                                 [toViewController.descriptionLabel setTransform:CGAffineTransformIdentity];
                                 [toViewController.orangeLineView setAlpha:1.f];
                                 [toViewController.orangeLineView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.optionsContentView setAlpha:0.f];
            [toViewController.optionsContentView setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .6f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.optionsContentView setAlpha:1.f];
                                 [toViewController.optionsContentView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.moreInfoContentView setAlpha:0.f];
            delay = .7f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.moreInfoContentView setAlpha:1.f];
                             }
                             completion:nil];
        }
            break;
        case VRadialSubtypeFromInfoToList: {
            CGFloat duration = 1.08f;
            VObjectInfoViewController *fromViewController = (VObjectInfoViewController *)self.fromViewController;
            VObjectsListViewController *toViewController = (VObjectsListViewController *)self.toViewController;
            [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
            [toView setBackgroundColor:[UIColor clearColor]];
            [toViewController.contentView setAlpha:0.f];
            [toViewController.contentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
            [UIView animateWithDuration:duration
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [circleView setTransform:CGAffineTransformMakeScale(kZoom, kZoom)];
                             }
                             completion:nil];
            CGFloat delay = .38f * duration;
            [UIView animateWithDuration:duration - delay
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.contentView setAlpha:1.f];
                                 [toViewController.contentView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [UIView animateWithDuration:duration / 2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [fromViewController.backButton setTransform:CGAffineTransformMakeTranslation(-44.f, 0.f)];
                                 [fromViewController.shareButton setTransform:CGAffineTransformMakeTranslation(44.f, 0.f)];
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:duration / 2
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      [toViewController.logotypeImageView setTransform:CGAffineTransformIdentity];
                                                      [toViewController.menuButton setTransform:CGAffineTransformIdentity];
                                                      [toViewController.filterButton setTransform:CGAffineTransformIdentity];
                                                      [toViewController.pageControl setTransform:CGAffineTransformIdentity];
                                                      NSUInteger badge = [toViewController.updatesCountLabel.text integerValue];
                                                      if (badge > 0) {
                                                          [toViewController.updatesCountLabel setAlpha:1.f];
                                                      }
                                                  }
                                                  completion:^(BOOL finished) {
                                                      _subtype = VRadialSubtypeFromListToInfo;
                                                      [toView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                                      [transitionContext completeTransition:YES];
                                                  }];
                             }];
            
        }
            break;
        case VRadialSubtypeFromInfoToPhotoes: {
            CGFloat duration = 1.08f;
            VObjectInfoViewController *fromViewController = (VObjectInfoViewController *)self.fromViewController;
            VPhotoesViewController *toViewController = (VPhotoesViewController *)self.toViewController;
            [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
            [toView setBackgroundColor:[UIColor clearColor]];
            [toViewController.carouselView setAlpha:0.f];
            [toViewController.carouselView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
//            [toViewController.imageViewFilter setAlpha:0.f];
//            [toViewController.titleLabel setAlpha:0.f];
//            [toViewController.titleLabel setTransform:CGAffineTransformMakeTranslation(0.f, -64.f)];
            [UIView animateWithDuration:duration
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [circleView setTransform:CGAffineTransformMakeScale(kZoom, kZoom)];
                             }
                             completion:nil];
            CGFloat delay = .38f * duration;
            [UIView animateWithDuration:duration - delay
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.carouselView setAlpha:1.f];
                                 [toViewController.carouselView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [UIView animateWithDuration:duration / 2
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [fromViewController.backButton setTransform:CGAffineTransformMakeTranslation(-44.f, 0.f)];
                                 [fromViewController.shareButton setTransform:CGAffineTransformMakeTranslation(44.f, 0.f)];
                             }
                             completion:^(BOOL finished) {
                                 [UIView animateWithDuration:duration / 2
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      [toViewController.carouselView setAlpha:1.f];
                                                      [toViewController.carouselView setTransform:CGAffineTransformIdentity];
//                                                      [toViewController.imageViewFilter setAlpha:1.f];
//                                                      [toViewController.titleLabel setAlpha:1.f];
//                                                      [toViewController.titleLabel setTransform:CGAffineTransformIdentity];
                                                  }
                                                  completion:^(BOOL finished) {
                                                      _subtype = VRadialSubtypeFromPhotoesToInfo;
                                                      [toView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                                      [transitionContext completeTransition:YES];
                                                  }];
                             }];
            
        }
            break;
        case VRadialSubtypeFromPhotoesToInfo: {
            CGFloat duration = 1.08f;
            VObjectInfoViewController *toViewController = (VObjectInfoViewController *)self.toViewController;
            [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
            [toView setBackgroundColor:[UIColor clearColor]];
            [toViewController.view setAlpha:0.f];
            [toViewController.view setTransform:CGAffineTransformMakeScale(.6f, .6f)];
            [UIView animateWithDuration:duration
                                  delay:0.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [circleView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                                 [circleView setTransform:CGAffineTransformMakeScale(kZoom, kZoom)];
                             }
                             completion:nil];
            [UIView animateWithDuration:duration / 2
                                  delay:duration / 2
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.backButton setTransform:CGAffineTransformIdentity];
                                 [toViewController.shareButton setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toView setAlpha:1.f];
            [toView setTransform:CGAffineTransformIdentity];
            CGFloat delay = .2f * duration;
            [toViewController.carouselContentView setAlpha:0.f];
            [toViewController.carouselContentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
            [UIView animateWithDuration:duration - delay
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.carouselContentView setAlpha:1.f];
                                 [toViewController.carouselContentView setTransform:CGAffineTransformIdentity];
                             }
                             completion:^(BOOL finished) {
                                 _subtype = VRadialSubtypeFromInfoToList;
                                 [transitionContext completeTransition:YES];
                             }];
            [toViewController.titleLabel setAlpha:0.f];
            [toViewController.titleLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .3f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.titleLabel setAlpha:1.f];
                                 [toViewController.titleLabel setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.addressLabel setAlpha:0.f];
            [toViewController.addressLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .4f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.addressLabel setAlpha:1.f];
                                 [toViewController.addressLabel setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.descriptionLabel setAlpha:0.f];
            [toViewController.descriptionLabel setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            [toViewController.orangeLineView setAlpha:0.f];
            [toViewController.orangeLineView setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .5f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.descriptionLabel setAlpha:1.f];
                                 [toViewController.descriptionLabel setTransform:CGAffineTransformIdentity];
                                 [toViewController.orangeLineView setAlpha:1.f];
                                 [toViewController.orangeLineView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.optionsContentView setAlpha:0.f];
            [toViewController.optionsContentView setTransform:CGAffineTransformMakeTranslation(0.f, 44.f)];
            delay = .6f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.optionsContentView setAlpha:1.f];
                                 [toViewController.optionsContentView setTransform:CGAffineTransformIdentity];
                             }
                             completion:nil];
            [toViewController.moreInfoContentView setAlpha:0.f];
            delay = .7f * duration;
            [UIView animateWithDuration:duration * .5f
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [toViewController.moreInfoContentView setAlpha:1.f];
                             }
                             completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
