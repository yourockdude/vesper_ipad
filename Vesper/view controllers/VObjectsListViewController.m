//
//  VObjectsListViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VObjectsListViewController.h"

#import <CoreMotion/CoreMotion.h>

#import "VUtils.h"
#import "iCarousel.h"

#import "VMenuViewController.h"

#import "VCarouselView.h"

#import "VRadialAnimation.h"

#import "VObjectInfoViewController.h"

#import "ICGNavigationController.h"

#import "VFilterView.h"

#import "VSettings.h"


@interface VObjectsListViewController () <iCarouselDelegate, iCarouselDataSource, VMenuViewControllerDelegate, VFilterViewDelegate, VSettingDelegate>

@property (strong, nonatomic) iCarousel *carouselView;

@property (strong, nonatomic) VMenuViewController *menuVC;

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) VFilterView *filterView;

@property (strong, nonatomic) CALayer *layer;

@property (strong, nonatomic) UIViewController *topVC;

@property (strong, nonatomic) NSMutableArray <VObject *> *objects;
@property (strong, nonatomic) NSMutableArray <VObject *> *removeds;

@property (strong, nonatomic) VSettings *settings;

@end


@implementation VObjectsListViewController

@synthesize delegate;

@synthesize contentView = _contentView;

- (instancetype)initWithObjects:(NSArray<VObject *> *)objects {
    self = [super init];
    if (self) {
        _objects = [NSMutableArray arrayWithArray:objects];
        _removeds = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _settings = [VSettings sharedSettings];
    [_settings setDelegate:self];
    [VUtils applyCornerRadii:@[@(_updatesCountLabel.frame.size.height / 2)]
                    forViews:@[_updatesCountLabel]];
    [_updatesCountLabel setAlpha:0.f];
    CGRect frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    [_contentView setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    _carouselView = [[iCarousel alloc] initWithFrame:frame];
    [_carouselView setBackgroundColor:[UIColor clearColor]];
    [_contentView addSubview:_carouselView];
    [_carouselView setDelegate:self];
    [_carouselView setDataSource:self];
    [_carouselView setDecelerationRate:.12f];
    [_carouselView setType:iCarouselTypeCustom];
    frame.origin.x = 18.f;
    frame.origin.y = SCREEN_HEIGHT / 2 - 366.f / 2;
    frame.size.width = SCREEN_WIDTH - 2 * 18.f;
    frame.size.height = 366.f;
    _filterView = [[VFilterView alloc] initWithFrame:frame];
    [_filterView setDelegate:self];
    [self.view addSubview:_filterView];
    [_filterView hideAnimated:NO];
    _layer = [CALayer layer];
    _layer.frame = self.view.bounds;
    _layer.backgroundColor = [UIColor blackColor].CGColor;
    [_layer setOpacity:.0f];
    [self.view.layer insertSublayer:_layer
                              below:_filterButton.layer];
    if ([[VSettings sharedSettings] availability]) {
        [self didSelectAvailability];
    } else {
        [self didSelectAll];
    }
    [self performSelector:@selector(checkUpdates)
               withObject:nil
               afterDelay:4.f];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _menuVC = [VMenuViewController sharedMenuViewController];
    [_menuVC setDelegate:self];
    [self.view insertSubview:_menuVC.view
                belowSubview:_menuButton];
    _motionManager = [[CMMotionManager alloc] init];
    [self startAccelerometer];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)checkUpdates {
    [_settings checkUpdates];
}

- (void)updateCarousel {
    [_objects removeAllObjects];
    [_removeds removeAllObjects];
    _objects = [NSMutableArray arrayWithArray:_settings.objects];
    [_pageControl setNumberOfPages:_objects.count];
    [_carouselView reloadData];
}

- (void)startAccelerometer {
    if ([_motionManager isAccelerometerAvailable]) {
        if (![_motionManager isAccelerometerActive]) {
            [_motionManager setAccelerometerUpdateInterval:.25f];
            [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                                                     if (delegate) {
                                                         [delegate didAccelerometerUpdateWithValue:accelerometerData.acceleration.x];
                                                     }
                                                 }];
        }
    }
}

- (void)showElements {
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_pageControl setAlpha:1.f];
                         [_filterButton setAlpha:1.f];
                     }
                     completion:nil];
}

- (void)hideElements {
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_pageControl setAlpha:0.f];
                         [_filterButton setAlpha:0.f];
                     }
                     completion:nil];
}

- (void)presentInfoViewControllerWithIdentifier:(NSUInteger)identifier
                                  andPoint:(CGPoint)point {
    VRadialAnimation *animation = [VRadialAnimation sharedAnimation];
    [animation setPoint:point];
    [animation setSubtype:VRadialSubtypeFromListToInfo];
    VObjectInfoViewController *objectInfoVC = [[VObjectInfoViewController alloc] initWithObject:_objects[identifier]];
    [self.navigationController pushViewController:objectInfoVC
                                         animated:YES];
}

- (void)checkBadge {
    if (_settings.badge == 0) {
        if (_updatesCountLabel.alpha == 1.f) {
            [self animateBadgeWithAlpha:0.f];
        }
    } else {
        if (_updatesCountLabel.alpha == 0.f) {
            [_updatesCountLabel setText:[NSString stringWithFormat:@"%@%ld%@", @"  ", (unsigned long)_settings.badge, @"  "]];
            [self animateBadgeWithAlpha:1.f];
        }
    }
}

- (void)animateBadgeWithAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [_updatesCountLabel setAlpha:alpha];
                     }
                     completion:^(BOOL finished) {
                         if (_settings.badge == 0) {
                             [_updatesCountLabel setText:[NSString stringWithFormat:@"%@%ld%@", @"  ", (unsigned long)_settings.badge, @"  "]];
                         }
                     }];
}

#pragma mark - VSettingsDelegate

- (void)didDownloadChangelog:(NSDictionary *)changelog {
    [self checkBadge];
    [_menuVC setChangelog:changelog];
}

#pragma mark - VAboutUsViewControllerDelegate

- (void)didSelectObjectWithIdentifier:(NSUInteger)identifier
                            withPoint:(CGPoint)point {
    [self presentInfoViewControllerWithIdentifier:identifier
                                         andPoint:point];
}

#pragma mark - iCarouselDelegate, iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return _objects.count;
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index
         reusingView:(UIView *)view {
    if (!view) {
        view = [[VCarouselView alloc] initWithFrame:_carouselView.frame];
    }
    if (!delegate) {
        [self setDelegate:((VCarouselView *)view)];
    }
    if (_objects.count > 0) {
        [((VCarouselView *)view) setImageURL:_objects[index].photos.firstObject];
        [((VCarouselView *)view) setProject:_objects[index].name];
        [((VCarouselView *)view) setAddress:_objects[index].address];
    }
    return view;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:1.0f];
    transform = CATransform3DTranslate(transform, spacing * offset * SCREEN_WIDTH, 0.f, -102.f * fabs(offset));
    if (offset < 0.f) {
        transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(offset * 32.f), 0.f, 1.f, 0.f);
    } else {
        transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(-offset * 32.f), 0.f, 1.f, 0.f);
    }
    transform.m34 = offset / 1024.f;
    return transform;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    if (option == iCarouselOptionSpacing) {
        return 1.06f * value;
    }
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

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    _menuButton.enabled = NO;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    _menuButton.enabled = YES;
    [self setDelegate:(VCarouselView *)_carouselView.currentItemView];
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index withPoint:(CGPoint)point {
    if (point.y <= 44.f) {
        return;
    }
    [self presentInfoViewControllerWithIdentifier:index
                                         andPoint:point];
}

#pragma mark - VMenuViewControllerDelegate

- (void)didSelectMenuViewControllerItemWithViewController:(UIViewController *)viewController {
    if (!viewController) {
        return;
    }
    _topVC = viewController;
    UIView *view = _topVC.view;
    [view setBackgroundColor:RGB(38.f, 40.f, 44.f)];
    if ([viewController class] == [self class]) {
        viewController = nil;
        view = _carouselView;
        [self showElements];
        [self startAccelerometer];
    }
    [view setFrame:_contentView.bounds];
    [_contentView addSubview:view];
    [view setAlpha:0.f];
    [UIView animateWithDuration:.6f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [view setAlpha:1.f];
                     }
                     completion:^(BOOL finished) {
                         if (_contentView.subviews.count > 1) {
                             [_contentView.subviews[_contentView.subviews.count - 2] removeFromSuperview];
                         }
                     }];
    [_menuButton setSelected:NO];
    [_menuVC hideAnimated:YES
           withCompletion:nil];
}

- (void)didCloseMenu {
    [_menuButton setSelected:NO];
    [_menuVC hideAnimated:YES withCompletion:nil];
    if ([_contentView.subviews.lastObject class] == [iCarousel class]) {
        [self showElements];
        [self startAccelerometer];
    }
}

#pragma mark - VFilterViewDelegate

- (void)didCloseFilterView {
    [_filterButton setSelected:NO];
    [_layer setOpacity:0.f];
    [_contentView setUserInteractionEnabled:YES];
    [_menuButton setEnabled:YES];
}

- (void)didSelectAll {
    for (VObject *removed in _removeds) {
        [_objects addObject:removed];
    }
    [_removeds removeAllObjects];
    [_carouselView reloadData];
    [_pageControl setNumberOfPages:_objects.count];
    NSLog(@"Objects: %ld, removed: %ld;", (unsigned long)_objects.count, (unsigned long)_removeds.count);
}

- (void)didSelectAvailability {
    for (VObject *object in _objects) {
        if (object.apartmentsCount == 0) {
            [_removeds addObject:object];
        }
    }
    [_objects removeObjectsInArray:_removeds];
    [_carouselView reloadData];
    [_pageControl setNumberOfPages:_objects.count];
    NSLog(@"Objects: %ld, removed: %ld;", (unsigned long)_objects.count, (unsigned long)_removeds.count);
}

#pragma mark - Actions

- (IBAction)menuButton_TUI:(UIButton *)sender {
    if (![_menuVC isShowed]) {
        [_menuVC showAnimated:YES
               withCompletion:nil];
        [self hideElements];
        [_motionManager stopAccelerometerUpdates];
    } else {
        [_menuVC hideAnimated:YES
               withCompletion:nil];
        if ([_contentView.subviews.lastObject class] == [iCarousel class]) {
            [self showElements];
            [self startAccelerometer];
        }
    }
    [_menuButton setSelected:!_menuButton.isSelected];
}

- (IBAction)filterButton_TUI:(UIButton *)sender {
    if (!sender.isSelected) {
        [_filterView showAnimated:YES];
        [_layer setOpacity:.6f];
        [_contentView setUserInteractionEnabled:NO];
        [_menuButton setEnabled:NO];
    } else {
        [_filterView hideAnimated:YES];
        [_layer setOpacity:0.f];
        [_contentView setUserInteractionEnabled:YES];
        [_menuButton setEnabled:YES];
    }
    [sender setSelected:!sender.isSelected];
}

@end
