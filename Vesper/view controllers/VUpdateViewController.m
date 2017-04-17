//
//  VUpdateViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 11.01.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import "VUpdateViewController.h"

#import "VUtils.h"
#import "VSettings.h"

#import "YLProgressBar.h"

#import "VMessageViewController.h"


@interface VUpdateViewController () <VSettingDelegate, VMessageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@property (weak, nonatomic) IBOutlet UITextView *changelogTextView;

@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *laterButton;

@property (strong, nonatomic) VSettings *settings;

@property (strong, nonatomic) NSDictionary *changelog;

@property (strong, nonatomic) VMessageViewController *messageVC;

@end


@implementation VUpdateViewController

@synthesize rootViewController = _rootViewController;

@synthesize delegate;

- (instancetype)initWithChangelog:(NSDictionary *)changelog {
    self = [super init];
    if (self) {
        _changelog = changelog;
        NSLog(@"Changelog: %@", _changelog);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self design];
    [self localize];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (delegate) {
        [delegate didUpdateComplete];
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setup {
    _progressBar.type = YLProgressBarTypeFlat;
    _progressBar.indicatorTextDisplayMode = YLProgressBarIndicatorTextDisplayModeNone;
    _progressBar.behavior = YLProgressBarBehaviorDefault;
    _progressBar.stripesOrientation = YLProgressBarStripesOrientationVertical;
    _progressBar.progressStretch = NO;
    _progressBar.uniformTintColor = YES;
    _progressBar.hideStripes = YES;
    _progressBar.hideGloss = YES;
    _progressBar.progressTintColor = RGB(74.f, 78.f, 84.f);
    _progressBar.trackTintColor = RGB(222.f, 222.f, 222.f);
    _progressBar.progress = .0f;
    _settings = [VSettings sharedSettings];
    [_settings setDelegate:self];
    [self.view setAlpha:0.f];
    [_contentView setAlpha:0.f];
    [_contentView setTransform:CGAffineTransformMakeScale(.6f, .6f)];
    [self createChangelog];
}

- (void)design {
    [_progressBar setAlpha:0.f];
    [_downloadLabel setAlpha:0.f];
}

- (void)localize {
    [_titleLabel setText:LOCALIZE(@"updates")];
    [_downloadLabel setText:LOCALIZE(@"download")];
    [_laterButton setTitle:LOCALIZE(@"later")
                  forState:UIControlStateNormal];
    [_updateButton setTitle:LOCALIZE(@"update")
                   forState:UIControlStateNormal];
}

- (void)update {
    [_settings updateDataFromServer];
}

- (void)createChangelog {
    NSMutableString *string = [NSMutableString string];
    for (NSDictionary *tmp in _changelog) {
        [string appendString:[NSString stringWithFormat:@"\n\n%@: %@\n", LOCALIZE(@"version"), tmp[@"version"]]];
        [string appendString:[NSString stringWithFormat:@"%@: %@", LOCALIZE(@"changelog"), tmp[@"changelog"]]];
    }
    NSString *item = LOCALIZE(@"item");
    if (_changelog.count > 1) {
        item = LOCALIZE(@"items");
    }
    NSString *description = [NSString stringWithFormat:LOCALIZE(@"changelog_description"), (unsigned long)_changelog.count, item];
    NSString *result = [NSString stringWithFormat:@"%@%@", description, string];
    [_changelogTextView setText:result];
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

#pragma mark - VMessageViewControllerDelegate

- (void)didButton_TUI {
    [UIView animateWithDuration:.4f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_progressBar setAlpha:0.f];
                         [_downloadLabel setAlpha:0.f];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.4f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              [_laterButton setTransform:CGAffineTransformIdentity];
                                          }
                                          completion:nil];
                         [UIView animateWithDuration:.2f
                                               delay:.2f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [_updateButton setAlpha:1.f];
                                          }
                                          completion:nil];
                     }];
}

#pragma mark - VSettingsDelegate

- (void)didFailureWithError:(NSString *)error {
    _messageVC = [[VMessageViewController alloc] initWithTitle:LOCALIZE(@"message_title")
                                                   withMessage:error
                                                     andButton:LOCALIZE(@"cancel")];
    [_messageVC setRootViewController:self];
    [_messageVC setDelegate:self];
    [_messageVC show];
}

- (void)didCompleateDownloadWithProgress:(CGFloat)progress {
    [_progressBar setProgress:progress
                     animated:YES];
}

- (void)didStartInitialLocalizedData {
    //
}

- (void)didFinishInitialLocalizedData {
    //
}

- (void)didStartLoadData {
    //
}

- (void)didFinishLoadData {
    //
}

- (void)didStartCachingPhotos {
    //
}

- (void)didFinishCachingPhotos {
    //
}

- (void)didFinishCahingDocuments {
    [_settings setBadge:0];
    [_settings updateVersionOfDeviceToken];
    [self hide];
}

#pragma mark - Actions

- (IBAction)laterButton_TUI:(UIButton *)sender {
    [self hide];
}

- (IBAction)updateButton_TUI:(UIButton *)sender {
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [_updateButton setAlpha:0.f];
                     }
                     completion:nil];
    [UIView animateWithDuration:.4f
                          delay:.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_laterButton setTransform:CGAffineTransformMakeTranslation(0.f, 64.f)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.4f
                                               delay:0.f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              [_progressBar setAlpha:1.f];
                                              [_downloadLabel setAlpha:1.f];
                                          }
                                          completion:^(BOOL finished) {
                                              [self update];
                                          }];
                     }];
}

@end
