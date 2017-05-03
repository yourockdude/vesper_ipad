//
//  VMessageViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 18.01.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import "VMessageViewController.h"


@interface VMessageViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end


@implementation VMessageViewController

@synthesize delegate = _delegate;

@synthesize rootViewController = _rootViewController;

@synthesize messageTitle = _messageTitle;
@synthesize message = _message;
@synthesize buttonTitle = _buttonTitle;

- (instancetype)initWithTitle:(NSString *)title
                  withMessage:(NSString *)message
                    andButton:(NSString *)button {
    self = [super init];
    if (self) {
        _messageTitle = title;
        _message = message;
        _buttonTitle = button;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setFrame:[UIScreen mainScreen].bounds];
    [_titleLabel setText:_messageTitle];
    [_messageLabel setText:_message];
    [_button setTitle:_buttonTitle
             forState:UIControlStateNormal];
    [self.view setAlpha:0.f];
    [_contentView setAlpha:0.f];
    [_contentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)setMessageTitle:(NSString *)messageTitle {
    _messageTitle = messageTitle;
    [_titleLabel setText:_messageTitle];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    [_messageLabel setText:_message];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [_button setTitle:_buttonTitle
             forState:UIControlStateNormal];
}

- (void)show {
    if (!_rootViewController) {
        return;
    }
    [_rootViewController.view addSubview:self.view];
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:1.f];
                         [_contentView setAlpha:1.f];
                         [_contentView setTransform:CGAffineTransformIdentity];
                     }
                     completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.view setAlpha:0.f];
                         [_contentView setAlpha:0.f];
                         [_contentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (IBAction)button_TUI:(UIButton *)sender {
    if (_delegate) {
        [_delegate didButton_TUI];
    }
    [self hide];
}

@end
