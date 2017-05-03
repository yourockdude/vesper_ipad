//
//  VMenuViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VMenuViewController.h"

#import "VUtils.h"

#import "VSettings.h"

#import "VMenuTableViewCell.h"

#import "VAboutUsViewController.h"
#import "VContactsViewController.h"
#import "VObjectsListViewController.h"
#import "VUpdateViewController.h"


#define kMargin (128.f)
#define kRowHeight (102.f)


@interface VMenuViewController () <UITableViewDelegate, UITableViewDataSource, VUpdateViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *rightContentView;

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *siteButton;

@property (strong, nonatomic) NSMutableArray *items;

@property (strong, nonatomic) VUpdateViewController *updateVC;

@end


@implementation VMenuViewController

@synthesize delegate;

@synthesize isShowed;

@synthesize changelog = _changelog;

#pragma mark - Life cycle

+ (id)sharedMenuViewController {
    static VMenuViewController *menuVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuVC = [[self alloc] init];
    });
    return menuVC;
}

- (id)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)setChangelog:(NSDictionary *)changelog {
    _changelog = changelog;
    [self createItems];
}

#pragma mark - Custom methods

- (void)setup {
    _items = [[NSMutableArray alloc] init];
    [self.view setFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self hideAnimated:NO
        withCompletion:nil];
    [_menuTableView setRowHeight:kRowHeight];
    [_menuTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [VUtils registerStringNameTableViewCellClass:NSStringFromClass([VMenuTableViewCell class])
                                    forTableView:_menuTableView
                             withReuseIdentifier:kReuseIdentifierMenu];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [_versionLabel setText:[NSString stringWithFormat:@"%@ %@ | %@ | %@", LOCALIZE(@"version"), version, LOCALIZE(@"design"), LOCALIZE(@"development")]];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    [swipe addTarget:self
              action:@selector(gestureRecognizerHandler)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipe setNumberOfTouchesRequired:1];
    [self.view setGestureRecognizers:@[swipe]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self
            action:@selector(gestureRecognizerHandler)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_rightContentView setGestureRecognizers:@[tap]];
}

- (void)createItems {
    NSArray *array = @[LOCALIZE(@"about_us"),
                       LOCALIZE(@"projects"),
                       LOCALIZE(@"contacts"),
                       LOCALIZE(@"news"),
                       LOCALIZE(@"call")];
    [_items removeAllObjects];
    _items = [NSMutableArray arrayWithArray:array];
    NSUInteger badge = [[VSettings sharedSettings] badge];
    if (badge > 0) {
        [_items addObject:[NSString stringWithFormat:@"%@ (%ld)", LOCALIZE(@"updates"), (unsigned long)badge]];
    }
    CGFloat value = (SCREEN_HEIGHT -  _items.count * kRowHeight) / 2;
    [_menuTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, value)]];
    [_menuTableView reloadData];
}

- (void)openBrowserWithURLString:(NSString *)URLString {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 //
                             }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifierMenu
                                                               forIndexPath:indexPath];
    if (_items.count > 0) {
        [cell setTitle:_items[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    if (delegate) {
        [delegate didSelectMenuViewControllerItemWithViewController:[self selectViewControllerWithMenuViewItem:indexPath.row + 1]];
    }
}

- (UIViewController *)selectViewControllerWithMenuViewItem:(VMenuViewItem)menuViewItem {
    UIViewController *viewController;
    switch (menuViewItem) {
        case VMenuViewItemNone:
            return nil;
            break;
        case VMenuViewItemAboutUs: {
            viewController = [[VAboutUsViewController alloc] init];
            VObjectsListViewController *delegateVC = (VObjectsListViewController *)delegate;
            [((VAboutUsViewController *)viewController) setDelegate:delegateVC];
        }
            break;
        case VMenuViewItemObjects:
            viewController = [[VObjectsListViewController alloc] init];
            break;
        case VMenuViewItemContacts:
            viewController = [[VContactsViewController alloc] init];
            break;
        case VMenuViewItemNews: {
            NSString *URL = @"http://m.vespermoscow.com/events/";
            if (SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO(@"10.0")) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]
                                                   options:@{}
                                         completionHandler:^(BOOL success) {
                                             //
                                         }];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
            }
            return nil;
        }
            break;
        case VMenuViewItemCall: {
            NSString *format = [NSString stringWithFormat:@"tel:%@", @"+74952877799"];
            if (SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO(@"10.0")) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:format]
                                               options:@{}
                                     completionHandler:^(BOOL success) {
                                         //
                                     }];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:format]];
            }
        }
            break;
        case VMenuViewItemUpdates: {
            _updateVC = [[VUpdateViewController alloc] initWithChangelog:_changelog];
            [_updateVC.view setFrame:self.view.bounds];
            [_updateVC setDelegate:self];
            [_updateVC setRootViewController:(UIViewController *)delegate];
            [_updateVC show];
        }
            break;
        default:
            return nil;
            break;
    }
    return viewController;
}

- (void)showAnimated:(BOOL)animated
      withCompletion:(void (^)())completion {
    isShowed = YES;
    [self createItems];
    ((VObjectsListViewController *)delegate).contentView.layer.zPosition = -1024.f;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.f / 1024.f;
//    transform = CATransform3DRotate(transform, DEGREES_TO_RADIANS(32.f), 0.f, 1.f, 0.f);
    transform = CATransform3DTranslate(transform, 512.f, 0.f, 512.f);
    if (!animated) {
        [self.view setTransform:CGAffineTransformIdentity];
        [((VObjectsListViewController *)delegate).contentView.layer setTransform:transform];
    } else {
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.view setTransform:CGAffineTransformIdentity];
                             [((VObjectsListViewController *)delegate).contentView.subviews.lastObject setBackgroundColor:RGB(38.f, 40.f, 44.f)];
                             [((VObjectsListViewController *)delegate).contentView.layer setTransform:transform];
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
}

- (void)hideAnimated:(BOOL)animated
      withCompletion:(void (^)())completion {
    isShowed = NO;
    if (!animated) {
        [((VObjectsListViewController *)delegate).contentView.layer setTransform:CATransform3DIdentity];
        [self.view setTransform:CGAffineTransformMakeTranslation(-1.2f * SCREEN_WIDTH, 0.f)];
    } else {
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [((VObjectsListViewController *)delegate).contentView.subviews.lastObject setBackgroundColor:RGB(28.f, 30.f, 34.f)];
                             [((VObjectsListViewController *)delegate).contentView.layer setTransform:CATransform3DIdentity];
                             [self.view setTransform:CGAffineTransformMakeTranslation(-1.2f * SCREEN_WIDTH, 0.f)];
                         }
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    }
}

#pragma mark - VUpdateViewDelegate

- (void)didUpdateComplete {
    [self createItems];
    [((VObjectsListViewController *)delegate) checkBadge];
    [((VObjectsListViewController *)delegate) updateCarousel];
}

#pragma mark - Actions

- (void)gestureRecognizerHandler {
    if (delegate) {
        [delegate didCloseMenu];
    }
}

- (IBAction)facebookButton_TUI:(UIButton *)sender {
    NSString *string = @"fb://profile/VesperMoscowApartments";
    NSURL *URL = [NSURL URLWithString:string];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        NSLog(@"Open browser;");
        string = @"https://www.facebook.com/VesperMoscowApartments/";
        URL = [NSURL URLWithString:string];
    }
    [[UIApplication sharedApplication] openURL:URL
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 //
                             }];
}

- (IBAction)instagramButton_TUI:(UIButton *)sender {
    NSString *string = @"instagram://user?username=vesper_moscow";
    NSURL *URL = [NSURL URLWithString:string];
    if (![[UIApplication sharedApplication] canOpenURL:URL]) {
        NSLog(@"Open browser;");
        string = @"https://www.instagram.com/vesper_moscow/";
        URL = [NSURL URLWithString:string];
    }
    [[UIApplication sharedApplication] openURL:URL
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 //
                             }];
}

- (IBAction)siteButton_TUI:(UIButton *)sender {
    [self openBrowserWithURLString:@"http://m.vespermoscow.com"];
}

@end
