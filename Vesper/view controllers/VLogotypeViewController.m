//
//  VLogotypeViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VLogotypeViewController.h"

#import "VUtils.h"

#import "YLProgressBar.h"

#import "VObjectsListViewController.h"
#import "VMessageViewController.h"

#import "ICGFlipAnimation.h"
#import "VRadialAnimation.h"

#import "VSettings.h"

#import <UserNotifications/UserNotifications.h>

//#import "VImageView.h"

#import "AppDelegate.h"


#define kImagesCount (40)

#define kAnimationTime (1.16f)
//#define kLaunchTime (.2f)


@interface VLogotypeViewController () <VSettingDelegate, VMessageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSMutableArray <UIImage *> *images;

@property (strong, nonatomic) VSettings *settings;

@property (strong, nonatomic) VMessageViewController *messageVC;

//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet YLProgressBar *progressBar;

@end


@implementation VLogotypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [_progressBar setAlpha:0.f];
    _settings = [VSettings sharedSettings];
    [_settings setDelegate:self];
    _images = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <= kImagesCount; i++) {
        [_images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"animation_%02ld.png", (unsigned long)i]]];
    }
    [_imageView setAnimationImages:_images];
    [_imageView setAnimationRepeatCount:1];
    [_imageView setAnimationDuration:kAnimationTime];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(stop)
               withObject:nil
               afterDelay:kAnimationTime];
    [_imageView startAnimating];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)stop {
    [_imageView stopAnimating];
    [_imageView setImage:[_images lastObject]];
    [self load];
}

- (void)delay {
//    [self performSelector:@selector(launch)
//               withObject:nil
//               afterDelay:kLaunchTime];
    [self launch];
}

- (void)launch {
    NSLog(@"Launch: VObjectsListViewController;");
    VObjectsListViewController *objectsListVC = [[VObjectsListViewController alloc] initWithObjects:_settings.objects];
    VRadialAnimation *animation = [VRadialAnimation sharedAnimation];
    [animation setSubtype:VRadialSubtypeFromLogotypeToList];
    [self.navigationController pushViewController:objectsListVC
                                         animated:YES];
}

- (void)load {
    if (_settings.isNotFirstLaunch) {
        NSLog(@"Is not first launch;");
        if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
            NSLog(@"Notifications is not register;");
            [self registerForNotifications];
        }
        [_settings loadLocalizedDataFromCache];
    } else {
        NSLog(@"First launch;");
        [self registerForNotifications];
        [_settings updateDataFromServer];
    }
}

- (void)registerForNotifications {
    NSLog(@"Try to register for remote notifications;");
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!error && granted) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      NSLog(@"Finish register for remote notifications;");
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  });
                              }
                          }];
}

- (void)showProgressBar {
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [_progressBar setAlpha:1.f];
                     }
                     completion:nil];
}

- (void)hideProgressBar {
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [_progressBar setAlpha:0.f];
                     }
                     completion:nil];
}

#pragma mark - VMessageViewControllerDelegate

- (void)didButton_TUI {
    [_settings updateDataFromServer];
}

#pragma mark - VSettingsDelegate

- (void)didCompleateDownloadWithProgress:(CGFloat)progress {
    NSLog(@"Progress: %1.2f;", progress);
    [_progressBar setProgress:progress
                     animated:YES];
}

- (void)didFailureWithError:(NSString *)error {
    _messageVC = [[VMessageViewController alloc] initWithTitle:LOCALIZE(@"message_title")
                                                   withMessage:error
                                                     andButton:LOCALIZE(@"repeat")];
    [_messageVC setRootViewController:self];
    [_messageVC setDelegate:self];
    [_messageVC show];
}

- (void)didStartInitialLocalizedData {
    [self showProgressBar];
//    [_activityIndicator startAnimating];
}

- (void)didFinishInitialLocalizedData {
    [_settings setIsNotFirstLaunch:YES];
}

- (void)didStartLoadData {
    [self showProgressBar];
}

- (void)didFinishLoadData {
    //
}

- (void)didStartCachingPhotos {
    //
}

- (void)didFinishCachingPhotos {
//    [self hideProgressBar];
//    [_activityIndicator stopAnimating];
//    [self delay];
}

- (void)didFinishCahingDocuments {
    [self hideProgressBar];
//    [_activityIndicator stopAnimating];
    [self delay];
}

@end
