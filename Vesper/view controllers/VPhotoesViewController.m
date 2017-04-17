//
//  VPhotoesViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 13.02.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import "VPhotoesViewController.h"

#import "VUtils.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

#import "VRadialAnimation.h"

#import "VZoomingView.h"

#import "VObjectInfoViewController.h"


@interface VPhotoesViewController () <iCarouselDelegate, iCarouselDataSource>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) VObject *object;

@property (assign, nonatomic) NSUInteger index;

@end


@implementation VPhotoesViewController

@synthesize delegate;

- (instancetype)initWithObject:(VObject *)object
                      andIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _object = object;
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageControl.numberOfPages = _object.photos.count;
    _pageControl.currentPage = _index;
    [self.view setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    _carouselView = [[iCarousel alloc] initWithFrame:self.view.bounds];
    [_carouselView setBackgroundColor:[UIColor clearColor]];
    [_carouselView setType:iCarouselTypeLinear];
    [_carouselView setDecelerationRate:.2f];
    [_carouselView setDelegate:self];
    [_carouselView setDataSource:self];
    [_carouselView scrollToItemAtIndex:_index
                              animated:NO];
    [self.view insertSubview:_carouselView
                belowSubview:_pageControl];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(hadlerTapGstureRecognizer)];
    [_carouselView setGestureRecognizers:@[tapGR]];
}

- (void)hadlerTapGstureRecognizer {
    NSLog(@"Tapped;");
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self registerOrientationChecking];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self unregisterOrientationChecking];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
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
        case UIDeviceOrientationPortrait: {
            NSLog(@"Is portrait;");
            [self dismissViewControllerAnimated:YES
                                     completion:nil];
        }
            break;
        default:
            break;
    };
}

#pragma mark - iCarouselDelegate, iCarouseDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _object.photos.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (!view) {
        view = [[VZoomingView alloc] initWithFrame:self.view.bounds];
//        view = [[UIView alloc] initWithFrame:self.view.bounds];
//        [view setBackgroundColor:[UIColor redColor]];
    }
    if (_object.photos > 0) {
        [self checkImageWithURL:_object.photos[index]
                   andImageView:((VZoomingView *)view).imageView];
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

- (void)carouselDidScroll:(iCarousel *)carousel {
    [_pageControl setCurrentPage:carousel.currentItemIndex];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    if (delegate) {
        [delegate didViewDisappearWithIndex:_carouselView.currentItemIndex];
    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionVisibleItems) {
        return 3;
    }
    if (option == iCarouselOptionWrap) {
        return 1;
    }
    if (option == iCarouselOptionSpacing) {
        return value += .02f;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index withPoint:(CGPoint)point {
    NSLog(@"Selected photo: %ld;", (unsigned long)index);
}

@end
