//
//  VObjectInfoViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 05.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VObjectInfoViewController.h"

#import "VUtils.h"
#import "VSettings.h"

#import "ICGNavigationController.h"
#import "VRadialAnimation.h"

#import "VShareView.h"

#import "iCarousel.h"
#import "AccordionView.h"
#import "VAccordionControl.h"

#import "VDescriptionView.h"
#import "VLocationView.h"
#import "VTeamView.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "VMessageViewController.h"
#import <MessageUI/MessageUI.h>
//#import <WebKit/WebKit.h>

#import "VPhotoesViewController.h"
#import "VDocumentViewController.h"

#import "Timer.h"


@interface VObjectInfoViewController () <iCarouselDelegate, iCarouselDataSource, VAccordionControlFunctionsDelegate, VAccordionControlVisualDelegate, AccordionViewDelegate, VShareViewDelegate, VTeamViewDelegate, MFMessageComposeViewControllerDelegate, VPhotoesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *infoContentView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) iCarousel *carouselView;

@property (strong, nonatomic) AccordionView *accordionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accordionLC;

@property (strong, nonatomic) VShareView *shareView;

@property (strong, nonatomic) CALayer *layer;

@property (strong, nonatomic) VDescriptionView *descriptionView;
@property (strong, nonatomic) VLocationView *locationView;
@property (strong, nonatomic) VTeamView *teamView;

@property (assign, nonatomic) CGFloat descriptionHeight;
@property (assign, nonatomic) CGFloat locationHeight;
@property (assign, nonatomic) CGFloat teamHeight;

@property (strong, nonatomic) VObject *object;

@property (weak, nonatomic) IBOutlet UILabel *readyLabel;
@property (weak, nonatomic) IBOutlet UILabel *readyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *squareLabel;
@property (weak, nonatomic) IBOutlet UILabel *squareValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartmentsCount;
@property (weak, nonatomic) IBOutlet UILabel *apartmentCountValueLabel;

@property (weak, nonatomic) IBOutlet UIButton *site_1_Button;
@property (weak, nonatomic) IBOutlet UIButton *site_2_Button;

@property (strong, nonatomic) VMessageViewController *messageVC;

@end


@implementation VObjectInfoViewController

- (instancetype)initWithObject:(VObject *)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buttonsSetup];
    [self fillObject];
    CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, _carouselContentView.frame.size.height);
    _carouselView = [[iCarousel alloc] initWithFrame:frame];
    [_carouselView setType:iCarouselTypeLinear];
    [_carouselView setDecelerationRate:.2f];
    [_carouselView setDelegate:self];
    [_carouselView setDataSource:self];
    [_carouselContentView insertSubview:_carouselView
                           belowSubview:_pageControl];
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [layer setOpacity:.348f];
    [_carouselView.layer addSublayer:layer];
    [_accordionLC setConstant:3 * 84.f];
    _accordionView = [[AccordionView alloc] initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, FLT_MAX)];
    VAccordionControl *accordionControl1 = [[VAccordionControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 84.f)
                                                                          withTitle:LOCALIZE(@"description")];
    VAccordionControl *accordionControl2 = [[VAccordionControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 84.f)
                                                                          withTitle:LOCALIZE(@"location")];
    VAccordionControl *accordionControl3 = [[VAccordionControl alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 84.f)
                                                                          withTitle:LOCALIZE(@"team")];
    [accordionControl1 setVisualDelegate:self];
    [accordionControl2 setVisualDelegate:self];
    [accordionControl3 setVisualDelegate:self];
    [_accordionView setDelegate:self];
    _descriptionView = [[VDescriptionView alloc] init];
    [_descriptionView setText:_object.largeDescription];
    _locationView = [[VLocationView alloc] init];
    [_locationView setText:_object.location];
    [_locationView setCoordinates:CGPointMake(_object.latitude, _object.longitude)];
    NSLog(@"Latitude: %f, longitude: %f;", _object.latitude, _object.longitude);
    _teamView = [[VTeamView alloc] init];
    [_teamView setDelegate:self];
    [_teamView setText:_object.team];
//    [_teamView setSite_1:_object.customURL];
//    [_teamView setSite_2:_object.objectURL];
    [_site_1_Button setTitle:_object.customURL
                    forState:UIControlStateNormal];
    [_site_2_Button setTitle:_object.objectURL
                    forState:UIControlStateNormal];
    [_accordionView addHeader:accordionControl1
                     withView:_descriptionView];
    [_accordionView addHeader:accordionControl2
                     withView:_locationView];
    [_accordionView addHeader:accordionControl3
                     withView:_teamView];
    [_accordionView setAllowsMultipleSelection:YES];
    [_accordionView setAllowsEmptySelection:YES];
    [_accordionView setStartsClosed:YES];
    [_moreInfoContentView addSubview:_accordionView];
    _descriptionHeight = _descriptionView.frame.size.height;
    _locationHeight = _locationView.frame.size.height;
    _teamHeight = _teamView.frame.size.height;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerOrientationChecking];
    if (_shareView && _layer) {
        return;
    }
    NSLog(@"Create share view and layer;");
    CGRect frame;
    frame.origin.x = 18.f;
    frame.origin.y = SCREEN_HEIGHT / 2 - 450.f / 2;
    frame.size.width = SCREEN_WIDTH - 2 * 18.f;
    frame.size.height = 450.f;
    _shareView = [[VShareView alloc] initWithFrame:frame];
    [_shareView setDelegate:self];
    [_shareView hideAnimated:NO];
    [self.view addSubview:_shareView];
    _layer = [CALayer layer];
    _layer.frame = self.view.bounds;
    _layer.backgroundColor = [UIColor blackColor].CGColor;
    _layer.opacity = .0f;
    [self.view.layer insertSublayer:_layer
                              below:_shareButton.layer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterOrientationChecking];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)registerOrientationChecking {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)unregisterOrientationChecking {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) orientationChanged:(NSNotification *)note {
    UIDevice *device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft: {
            NSLog(@"Is landscape left;");
            [self showPhotoesViewController];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            NSLog(@"Is landscape right;");
            [self showPhotoesViewController];
        }
            break;
        default:
            break;
    };
}

- (void)buttonsSetup {
//    [_site_1_Button setImage:[UIImage imageNamed:@"big_right_arrow_button_default.png"]
//                    forState:UIControlStateNormal];
    [_site_1_Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_site_1_Button setImageEdgeInsets:UIEdgeInsetsMake(0.f, SCREEN_WIDTH - 35 - 28.f, 0.f, 0.f)];
    [_site_1_Button setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f + 28.f, 0.f, 0.f)];
}

- (void)showPhotoesViewController {
    VPhotoesViewController *photoesVC = [[VPhotoesViewController alloc] initWithObject:_object
                                                                              andIndex:_carouselView.currentItemIndex];
    [photoesVC setDelegate:self];
    [photoesVC setModalPresentationStyle:UIModalPresentationFullScreen];
    [photoesVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:photoesVC
                       animated:YES
                     completion:nil];
}

- (void)fillObject {
    [_pageControl setNumberOfPages:_object.photos.count];
    [_pageControl setCurrentPage:0];
    [_titleLabel setText:_object.name];
    [_addressLabel setText:_object.address];
    [_descriptionLabel setText:_object.littleDescription];
    [_readyLabel setText:LOCALIZE(@"ready")];
    [_squareLabel setText:LOCALIZE(@"square")];
    NSString *objectTypeString;
    switch (_object.type) {
        case 0:
            objectTypeString = LOCALIZE(@"flats_count"); // Flats
            break;
        case 1:
            objectTypeString = LOCALIZE(@"apartments_count"); // Apartments
            break;
        default:
            break;
    }
    [_apartmentsCount setText:objectTypeString];
    [_readyValueLabel setText:_object.ready];
    [_squareValueLabel setText:_object.square];
    [_apartmentCountValueLabel setText:[NSString stringWithFormat:@"%ld", (unsigned long)_object.apartmentsCount]];
}

- (void)showLayer {
    [_layer setOpacity:.6f];
}

- (void)hideLayer {
    [_layer setOpacity:0.f];
}

#pragma mark - VPhotoesViewControllerDelegate

- (void)didViewDisappearWithIndex:(NSUInteger)index {
    [_pageControl setCurrentPage:index];
    [_carouselView scrollToItemAtIndex:index
                              animated:NO];
}

//#pragma mark - VTeamViewDelegate
//
//- (void)didTUISite_1 {
//    [self openURL:[NSString stringWithFormat:@"http://%@", _object.customURL]];
//}
//
//- (void)didTUISite_2 {
//    [self openURL:[NSString stringWithFormat:@"http://%@", _object.objectURL]];
//}

- (void)openURL:(NSString *)URL {
    NSLog(@"Open URL: %@;", URL);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 //
                             }];
}

#pragma mark - iCarouselDelegate, iCarouseDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _object.photos.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:carousel.bounds];
        [((UIImageView *)view) setClipsToBounds:YES];
        [((UIImageView *)view) setContentMode:UIViewContentModeScaleAspectFill];
    }
    if (_object.photos > 0) {
        [self checkImageWithURL:_object.photos[index]
                   andImageView:((UIImageView *)view)];
    }
    return view;
}

- (void)checkImageWithURL:(NSString *)URL andImageView:(UIImageView *)imageView {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:URL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (!image) {
                                                             NSLog(@"Download, cache and set image: %@;", URL);
                                                             [self loadImageWithURL:URL
                                                                       andImageView:imageView];
                                                         } else {
                                                             NSLog(@"Set image: %@;", URL);
                                                             [imageView setImage:image];
                                                         }
                                                     }];
}

- (void)loadImageWithURL:(NSString *)URL andImageView:(UIImageView *)imageView {
    [imageView sd_setImageWithURL:[NSURL URLWithString:URL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            [imageView setImage:image];
                            [[SDImageCache sharedImageCache] storeImage:image
                                                                 forKey:URL];
                        }];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionVisibleItems) {
        return 3;
    }
    if (option == iCarouselOptionWrap) {
        return 1;
    }
    return value;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    [_pageControl setCurrentPage:carousel.currentItemIndex];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index withPoint:(CGPoint)point {
    if (point.y <= 44.f) {
        return;
    }
    NSLog(@"Selected photo: %ld;", (unsigned long)index);
    [self showPhotoesViewController];
}

#pragma mark - AccordionView 

- (void)accordion:(AccordionView *)accordion didChangeSelection:(NSIndexSet *)selection {
    __block CGFloat result;
    [selection enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                result += _descriptionHeight;
                break;
            case 1:
                result += _locationHeight;
                break;
            case 2:
                result += _teamHeight;
                break;
            default:
                break;
        }
    }];
    [_accordionLC setConstant:3 * 84.f + result];
}

#pragma mark - VAccordionControlVisualDelegate

- (VAccordionControlElementsPosition *)elementsPositionForAccordionCntrol:(VAccordionControl *)accordionControl {
    return [VAccordionControlElementsPosition standartProperties];
}

- (UIColor *)colorForOpenedAccordionControl:(VAccordionControl *)accordionControl {
    return RGB(164.f, 80.f, 42.f);
}

- (UIColor *)colorForClosedAccordionControl:(VAccordionControl *)accordionControl {
    return [UIColor whiteColor];
}

- (UIImage *)imageForOpenedAccordionControl:(VAccordionControl *)accordionControl {
    return [UIImage imageNamed:@"icon_minus.png"];
}

- (UIImage *)imageForClosedAccordionControl:(VAccordionControl *)accordionControl {
    return [UIImage imageNamed:@"icon_plus.png"];
}

- (UIColor *)colorForLineViewAccordionControl:(VAccordionControl *)accordionControl {
    return [UIColor lightGrayColor];
}

#pragma mark - VShareViewDelegate

- (void)didCloseShareView {
    [_shareButton setSelected:NO];
    [self hideLayer];
    [_carouselView setUserInteractionEnabled:YES];
    [_scrollView setUserInteractionEnabled:YES];
    [_backButton setEnabled:YES];
}

- (void)didSendSms {
    NSString *result = _object.objectURL;
    if ([result isEqualToString:@""]) {
        NSLog(@"Sms, object site not exists;");
        result = _object.customURL;
        if ([result isEqualToString:@""]) {
            NSLog(@"Sms, custom site not exists;");
            result = @"http://www.vespermoscow.com";
        }
    }
    MFMessageComposeViewController *smsVC = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        [smsVC setBody:result];
        [smsVC setRecipients:@[@"текст"]];
        [smsVC setMessageComposeDelegate:self];
        [self presentViewController:smsVC
                           animated:YES
                         completion:nil];
    }
}

- (NSString *)URLChecking {
    NSString *result = _object.documentURL;
    if ([result isEqualToString:@""]) {
        NSLog(@"Email, pdf is not exists;");
        result = _object.objectURL;
        if ([result isEqualToString:@""]) {
            NSLog(@"Email, object site is not exists;");
            result = _object.customURL;
            if ([result isEqualToString:@""]) {
                NSLog(@"Email, custom site is not exists;");
                result = @"http://www.vespermoscow.com";
            }
        }
    }
    return result;
}

- (void)didSendEmail {
    [self openURL:[NSString stringWithFormat:@"mailto:%@?subject=Vesper&body=%@", @"", [self URLChecking]]];
}

- (void)didDownloadPdf {
    NSLog(@"PDF file: %@;", _object.documentURL);
    if ([_object.documentURL isEqualToString:@""]) {
        if (!_messageVC) {
            NSLog(@"Message view controller alloc;");
            _messageVC = [[VMessageViewController alloc] initWithTitle:LOCALIZE(@"no_pdf_title")
                                                           withMessage:LOCALIZE(@"no_pdf_description")
                                                             andButton:LOCALIZE(@"cancel")];
        } else {
            NSLog(@"Message reuse;");
            [_messageVC setMessageTitle:LOCALIZE(@"no_pdf_title")];
            [_messageVC setMessage:LOCALIZE(@"no_pdf_description")];
            [_messageVC setButtonTitle:LOCALIZE(@"cancel")];
        }
        [_messageVC setRootViewController:self];
        [_messageVC show];
    } else {
        VSettings *settings = [VSettings sharedSettings];
        [settings documentByURL:_object.documentURL
                     completion:^(NSData *data) {
                         VDocumentViewController *documentVC = [[VDocumentViewController alloc] initWithData:data
                                                                                                   andTitle:_object.name];
                         [self presentViewController:documentVC
                                            animated:YES
                                          completion:nil];
                     }];
    }
}

- (void)didWhatsapp {
    NSLog(@"WhatsApp;");
    NSString *string = [NSString stringWithFormat:@"whatsapp://send?text=%@", [self URLChecking]];
    NSURL *URL = [NSURL URLWithString:string];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     //
                                 }];
    } else {
        if (!_messageVC) {
            NSLog(@"Message view controller alloc;");
            _messageVC = [[VMessageViewController alloc] initWithTitle:LOCALIZE(@"no_whatsapp_title")
                                                           withMessage:LOCALIZE(@"no_whatsapp_description")
                                                             andButton:LOCALIZE(@"cancel")];
        } else {
            NSLog(@"Message reuse;");
            [_messageVC setMessageTitle:LOCALIZE(@"no_whatsapp_title")];
            [_messageVC setMessage:LOCALIZE(@"no_whatsapp_description")];
            [_messageVC setButtonTitle:LOCALIZE(@"cancel")];
        }
        [_messageVC setRootViewController:self];
        [_messageVC show];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - Actions

- (IBAction)backButton_TUI:(UIButton *)sender {
    [[VRadialAnimation sharedAnimation] setPoint:sender.center];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButton_TUI:(UIButton *)sender {
    if (!sender.isSelected) {
        [_shareView showAnimated:YES];
        [self showLayer];
        [_carouselView setUserInteractionEnabled:NO];
        [_scrollView setUserInteractionEnabled:NO];
        [_backButton setEnabled:NO];
    } else {
        [_shareView hideAnimated:YES];
        [self hideLayer];
        [_carouselView setUserInteractionEnabled:YES];
        [_scrollView setUserInteractionEnabled:YES];
        [_backButton setEnabled:YES];
    }
    [sender setSelected:!sender.isSelected];
}

- (IBAction)site_1_ButtonTUI:(UIButton *)sender {
    [self openURL:[NSString stringWithFormat:@"http://%@", _object.customURL]];
}

- (IBAction)site_2_ButtonTUI:(UIButton *)sender {
    [self openURL:[NSString stringWithFormat:@"http://%@", _object.objectURL]];
}

@end
