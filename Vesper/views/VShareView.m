//
//  VShareView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 08.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VShareView.h"

#import "VUtils.h"


@interface VShareView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UIButton *whatsappButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end


@implementation VShareView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    VShareView *view = [[NSBundle mainBundle] loadNibNamed:@"VShareView"
                                                     owner:self
                                                   options:nil].firstObject;
    [view setFrame:self.bounds];
    [view layoutIfNeeded];
    [self addSubview:view];
    [self layoutIfNeeded];
    [self localize];
    [self buttonsSetup];
}

- (void)localize {
    [_titleLabel setText:LOCALIZE(@"share")];
    [_sendEmailButton setTitle:LOCALIZE(@"send_email")
                      forState:UIControlStateNormal];
    [_downloadButton setTitle:LOCALIZE(@"download_pdf")
                     forState:UIControlStateNormal];
    [_sendSMSButton setTitle:LOCALIZE(@"send_sms")
                    forState:UIControlStateNormal];
    [_whatsappButton setTitle:LOCALIZE(@"whatsapp")
                     forState:UIControlStateNormal];
}

- (void)buttonsSetup {
    [_sendEmailButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _sendEmailButton.frame.size.width - 35.f, 0.f, 0.f)];
    [_sendEmailButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f, 0.f, 0.f)];
    [_downloadButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _downloadButton.frame.size.width - 35.f, 0.f, 0.f)];
    [_downloadButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f, 0.f, 0.f)];
    [_sendSMSButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _sendSMSButton.frame.size.width - 35.f, 0.f, 0.f)];
    [_sendSMSButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f, 0.f, 0.f)];
    [_whatsappButton setImageEdgeInsets:UIEdgeInsetsMake(0.f, _whatsappButton.frame.size.width - 35.f, 0.f, 0.f)];
    [_whatsappButton setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f, 0.f, 0.f)];
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

- (IBAction)sendEmailButton_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didSendEmail];
    }
}

- (IBAction)downloadButton_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didDownloadPdf];
    }
}

- (IBAction)sendSMSButton_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didSendSms];
    }
}

- (IBAction)whatsappButton_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didWhatsapp];
    }
}

- (IBAction)closeButton_TUI:(UIButton *)sender {
    [self hideAnimated:YES];
    if (delegate) {
        [delegate didCloseShareView];
    }
}

@end
