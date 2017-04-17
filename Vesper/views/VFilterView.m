//
//  VFilterView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 08.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VFilterView.h"

#import "VUtils.h"

#import "VSettings.h"


@interface VFilterView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *allProjectsButton;
@property (weak, nonatomic) IBOutlet UIButton *readyApartmentsButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@implementation VFilterView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    VFilterView *view = [[NSBundle mainBundle] loadNibNamed:@"VFilterView"
                                                     owner:self
                                                   options:nil].firstObject;
    
    [view setFrame:self.bounds];
    [view layoutIfNeeded];
    [self addSubview:view];
    [self layoutIfNeeded];
    [self localize];
    [self buttonsSetup];
    if ([[VSettings sharedSettings] availability]) {
        NSLog(@"Only availability;");
        [_allProjectsButton setSelected:NO];
        [_readyApartmentsButton setSelected:YES];
    } else {
        NSLog(@"All;");
        [_allProjectsButton setSelected:YES];
        [_readyApartmentsButton setSelected:NO];
    }
}

- (void)localize {
    [_titleLabel setText:LOCALIZE(@"filter")];
    [_allProjectsButton setTitle:LOCALIZE(@"all_projects")
                        forState:UIControlStateNormal];
    [_readyApartmentsButton setTitle:LOCALIZE(@"ready_apartments")
                            forState:UIControlStateNormal];
    [_acceptButton setTitle:LOCALIZE(@"accept")
                   forState:UIControlStateNormal];
}

- (void)buttonsSetup {
    [_allProjectsButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _allProjectsButton.frame.size.width - 24.f, 0.f, 0.f)];
    [_allProjectsButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -24.f, 0.f, 0.f)];
    [_readyApartmentsButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _readyApartmentsButton.frame.size.width - 24.f, 0.f, 0.f)];
    [_readyApartmentsButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -24.f, 0.f, 0.f)];
}

- (void)showAnimated:(BOOL)animated {
    if (!animated) {
        [self setAlpha:1.f];
    } else {
        [self setTransform:CGAffineTransformMakeScale(.8f, .8f)];
        [UIView animateWithDuration:.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setAlpha:1.f];
                             [self setTransform:CGAffineTransformIdentity];
                         }
                         completion:^(BOOL finished) {
                             //
                         }];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (!animated) {
        [self setAlpha:0.f];
    } else {
        [self setTransform:CGAffineTransformIdentity];
        [UIView animateWithDuration:.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setAlpha:0.f];
                             [self setTransform:CGAffineTransformMakeScale(.8f, .8f)];
                         }
                         completion:^(BOOL finished) {
                             //
                         }];
    }
}

- (void)close {
    [self hideAnimated:YES];
    if (delegate) {
        [delegate didCloseFilterView];
    }
}

- (IBAction)allProgectsButton_TUI:(UIButton *)sender {
    [sender setSelected:YES];
    [_readyApartmentsButton setSelected:NO];
    if (delegate) {
        [delegate didSelectAll];
    }
}

- (IBAction)readyApartmentsButton_TUI:(UIButton *)sender {
    [sender setSelected:YES];
    [_allProjectsButton setSelected:NO];
    if (delegate) {
        [delegate didSelectAvailability];
    }
}

- (IBAction)resetAllButton_TUI:(UIButton *)sender {
    //
}

- (IBAction)acceptButton_TUI:(UIButton *)sender {
    [[VSettings sharedSettings] setAvailability:_readyApartmentsButton.isSelected];
    [self close];
}

- (IBAction)closeButton_TUI:(UIButton *)sender {
    [self close];
}

@end
