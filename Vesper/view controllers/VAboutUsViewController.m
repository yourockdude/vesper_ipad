//
//  VAboutUsViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VAboutUsViewController.h"

#import "VUtils.h"

#import "VObjectInfoViewController.h"

#import "VRadialAnimation.h"

#import "VPlacesView.h"

#import "VSettings.h"


@interface VAboutUsViewController () <VPlacesViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *placesView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *logotypeImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_1_Label;
@property (weak, nonatomic) IBOutlet UILabel *text_2_Label;
@property (weak, nonatomic) IBOutlet UILabel *popularPlacesLabel;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) NSMutableArray <VPlacesView *> *places;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end


@implementation VAboutUsViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setup {
    NSArray <VObject *> *objects = [[VSettings sharedSettings] objects];
    _places = [[NSMutableArray alloc] init];
    [_contentView setBackgroundColor:[UIColor clearColor]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [_titleLabel setText:LOCALIZE(@"_about_us")];
    [_text_1_Label setText:LOCALIZE(@"about_us_1_text")];
    [_text_2_Label setText:LOCALIZE(@"about_us_2_text")];
    [_popularPlacesLabel setText:LOCALIZE(@"popular_places")];
    [_constraint setConstant:95.f * objects.count];
    for (NSUInteger i = 0; i <= objects.count - 1; i++) {
        if (objects.count > 0) {
            VPlacesView *place = [[VPlacesView alloc] initWithFrame:CGRectMake(0.f, 95.f * i, SCREEN_WIDTH, 95.f)];
            [place setDelegate:self];
            place.index = i;
            [place setImageURL:objects[i].photos.firstObject];
            [place.label setText:objects[i].name];
            [_places addObject:place];
            [_placesView addSubview:_places[i]];
        }
    }
}

- (IBAction)menuButton_TUI:(UIButton *)sender {
    [[VRadialAnimation sharedAnimation] setPoint:sender.center];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectWithIndex:(NSUInteger)index
                  andPoint:(CGPoint)point {
    if (delegate) {
        point.y += (_placesView.frame.origin.y - _scrollView.contentOffset.y + _imageView.bounds.size.height);
        [delegate didSelectObjectWithIdentifier:index
                                      withPoint:point];
    }
}

@end
