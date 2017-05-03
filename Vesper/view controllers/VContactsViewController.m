//
//  VContactsViewController.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VContactsViewController.h"

#import "VUtils.h"

#import "VRadialAnimation.h"

#import <MapKit/MapKit.h>

#import "VSettings.h"


@interface VContactsViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *logotypeImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_1_Label;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_2_Label;
@property (weak, nonatomic) IBOutlet UILabel *subtitle_3_Label;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *telephone_1_Button;
@property (weak, nonatomic) IBOutlet UIButton *telephone_2_Button;
@property (weak, nonatomic) IBOutlet UIButton *telephone_3_Button;
@property (weak, nonatomic) IBOutlet UIButton *email_1_Button;
@property (weak, nonatomic) IBOutlet UIButton *email_2_Button;
@property (weak, nonatomic) IBOutlet UIButton *email_3_Button;

@end


@implementation VContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mapView setScrollEnabled:NO];
    [_mapView setZoomEnabled:NO];
    [_mapView setRotateEnabled:NO];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:55.735586f
                                                      longitude:37.642334f];
    MKCoordinateSpan span = MKCoordinateSpanMake(.0072f, .0072f);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region
               animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [_mapView setDelegate:self];
    [annotation setCoordinate:location.coordinate];
    [_mapView addAnnotation:annotation];
    [self localize];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)localize {
    [_titleLabel setText:LOCALIZE(@"_contacts")];
    [_subtitle_1_Label setText:LOCALIZE(@"office")];
    [_subtitle_2_Label setText:LOCALIZE(@"reseller")];
    [_subtitle_3_Label setText:LOCALIZE(@"press")];
    [_addressLabel setText:LOCALIZE(@"address")];
    [_nameLabel setText:LOCALIZE(@"name")];
    [_telephone_1_Button setTitle:LOCALIZE(@"telephone_1")
                         forState:UIControlStateNormal];
    [_telephone_2_Button setTitle:LOCALIZE(@"telephone_2")
                         forState:UIControlStateNormal];
    [_telephone_3_Button setTitle:LOCALIZE(@"telephone_3")
                         forState:UIControlStateNormal];
    [_email_1_Button setTitle:LOCALIZE(@"email_1")
                     forState:UIControlStateNormal];
    [_email_2_Button setTitle:LOCALIZE(@"email_2")
                     forState:UIControlStateNormal];
    [_email_3_Button setTitle:LOCALIZE(@"email_3")
                     forState:UIControlStateNormal];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:nil];
    annotationView.image = [UIImage imageNamed:@"pin.png"];
    return annotationView;
}

- (void)openURL:(NSString *)URL {
    if (SYSTEM_VERSION_GRATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]
                                           options:@{}
                                 completionHandler:^(BOOL success) {
                                     //
                                 }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
    }
}

- (void)makeCallWithTelephoneNumber:(NSString *)number {
    NSString *format = [NSString stringWithFormat:@"tel:%@", number];
    [self openURL:format];
}

- (void)sendMailToEmail:(NSString *)email {
    NSString *URL = [NSString stringWithFormat:@"mailto:%@?subject=Vesper&body=%@", email, @""];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]
//                                       options:@{}
//                             completionHandler:^(BOOL success) {
//                                 //
//                             }];
    [self openURL:URL];

}

- (IBAction)instagramButton_TUI:(UIButton *)sender {
    NSString *string = @"instagram://user?username=vesper_moscow";
//    NSURL *URL = [NSURL URLWithString:string];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]]) {
        NSLog(@"Open browser;");
        string = @"https://www.instagram.com/vesper_moscow/";
//        URL = [NSURL URLWithString:string];
    }
//    [[UIApplication sharedApplication] openURL:URL
//                                       options:@{}
//                             completionHandler:^(BOOL success) {
//                                 //
//                             }];
    [self openURL:string];
}

- (IBAction)facebookButton_TUI:(UIButton *)sender {
    NSString *string = @"fb://profile/VesperMoscowApartments";
//    NSURL *URL = [NSURL URLWithString:string];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:string]]) {
        NSLog(@"Open browser;");
        string = @"https://www.facebook.com/VesperMoscowApartments/";
//        URL = [NSURL URLWithString:string];
    }
//    [[UIApplication sharedApplication] openURL:URL
//                                       options:@{}
//                             completionHandler:^(BOOL success) {
//                                 //
//                             }];
    [self openURL:string];
}

- (IBAction)telephone_1_Button_TUI:(UIButton *)sender {
    [self makeCallWithTelephoneNumber:@"+74959810900"];
}

- (IBAction)telephone_2_Button_TUI:(UIButton *)sender {
    [self makeCallWithTelephoneNumber:@"+74952877799"];
}

- (IBAction)telephone_3_Button_TUI:(UIButton *)sender {
    [self makeCallWithTelephoneNumber:@"+79175520713"];
}

- (IBAction)email_1_Button_TUI:(UIButton *)sender {
    [self sendMailToEmail:@"info@vespermoscow.com"];
}

- (IBAction)email_2_Button_TUI:(UIButton *)sender {
    [self sendMailToEmail:@"sale@vespermoscow.com"];
}

- (IBAction)email_3_Button_TUI:(UIButton *)sender {
    [self sendMailToEmail:@"pr@vespermoscow.com"];
}

- (IBAction)buttonMenu_TUI:(UIButton *)sender {
    [[VRadialAnimation sharedAnimation] setPoint:sender.center];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)emailButton_TUI:(UIButton *)sender {
    [self sendMailToEmail:@"info@vespermoscow.com"];
}

@end
