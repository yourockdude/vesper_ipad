//
//  VAccordionControl.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 27.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VAccordionControl.h"


@interface VAccordionControl ()

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) VAccordionControlElementsPosition *elementsPosition;

@property (strong, nonatomic) UIImage *openedImage;
@property (strong, nonatomic) UIImage *closedImage;

@property (strong, nonatomic) UIColor *openedColor;
@property (strong, nonatomic) UIColor *closedColor;

@property (strong, nonatomic) UIColor *lineColor;

@end


@implementation VAccordionControl

@synthesize functionsDelegate = _functionsDelegate;

@synthesize title = _title;

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _showed = NO;
        [self addTarget:self
                 action:@selector(changeStatus)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Custom properties

- (void)setVisualDelegate:(id<VAccordionControlVisualDelegate>)visualDelegate {
    if (visualDelegate) {
        _visualDelegate = visualDelegate;
        _elementsPosition = [_visualDelegate elementsPositionForAccordionCntrol:self];
        _openedImage = [_visualDelegate imageForOpenedAccordionControl:self];
        _closedImage = [_visualDelegate imageForClosedAccordionControl:self];
        _openedColor = [_visualDelegate colorForOpenedAccordionControl:self];
        _closedColor = [_visualDelegate colorForClosedAccordionControl:self];
        _lineColor = [_visualDelegate colorForLineViewAccordionControl:self];
        [self createLabel];
        [self createImageView];
        [self createLineView];
    }
}

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        [_label setText:_title];
    }
}

#pragma mark - Create UI

- (void)createLabel {
    _label = [[UILabel alloc] init];
    [_label setFont:[UIFont fontWithName:@"Acrom-Bold"
                                    size:16.f]];
    [_label setTextColor:_closedColor];
    [_label setText:_title];
    [_label sizeToFit];
    [self addSubview:_label];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.f
                                                        constant:_label.frame.size.height]];
    [_label addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.f
                                                        constant:_label.frame.size.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:_elementsPosition.labelLeftMargin]];
}

- (void)createImageView {
    _imageView = [[UIImageView alloc] init];
    [_imageView setContentMode:UIViewContentModeCenter];
    [_imageView setImage:_closedImage];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_imageView];
    [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f
                                                            constant:_elementsPosition.imageViewSize.height]];
    [_imageView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f
                                                            constant:_elementsPosition.imageViewSize.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:-_elementsPosition.imageViewRightMargin]];
}

- (void)createLineView {
    _lineView = [[UIView alloc] init];
    [_lineView setBackgroundColor:_lineColor];
    [_lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_lineView];
    [_lineView addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f
                                                            constant:_elementsPosition.lineBorderWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_label
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:_elementsPosition.lineLeftMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_lineView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_imageView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:-_elementsPosition.lineRightMargin]];
}

#pragma mark - Actions

- (void)changeStatus {
    if (_showed) {
        if (_functionsDelegate) {
            [_functionsDelegate didCloseAccordionControl:self];
        }
        [_label setTextColor:_closedColor];
        [_imageView setImage:_closedImage];
    } else {
        if (_functionsDelegate) {
            [_functionsDelegate didCloseAccordionControl:self];
        }
        [_label setTextColor:_openedColor];
        [_imageView setImage:_openedImage];
    }
    _showed = !_showed;
}

@end
