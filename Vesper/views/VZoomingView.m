//
//  VZoomingView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 14.02.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import "VZoomingView.h"

#import "VUtils.h"


@interface VZoomingView () <UIScrollViewDelegate>

@end


@implementation VZoomingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setDelegate:self];
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView setMinimumZoomScale:1.f];
    [_scrollView setMaximumZoomScale:1.2f];
    [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_scrollView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:0.f]];
    _imageView = [[UIImageView alloc] init];
    [_imageView setClipsToBounds:YES];
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_scrollView addSubview:_imageView];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                            attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeLeft
                                                           multiplier:1.f
                                                             constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.f
                                                            constant:0.f]];
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:_scrollView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.f
                                                            constant:0.f]];
    [self setUserInteractionEnabled:YES];
    [_scrollView setUserInteractionEnabled:YES];
    [_imageView setUserInteractionEnabled:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

@end
