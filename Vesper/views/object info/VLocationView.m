//
//  VLocationView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 09.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VLocationView.h"

#import "VUtils.h"

#import <MapKit/MapKit.h>

#define kHeightMapView (356.f)


@interface VLocationView () <MKMapViewDelegate>

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) MKMapView *mapView;

@end


@implementation VLocationView

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    _label = [[UILabel alloc] init];
    [_label sizeToFit];
    [_label setNumberOfLines:0];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_label];
    [_label setBackgroundColor:RGB(28.f, 30.f, 34.f)];
    _mapView = [[MKMapView alloc] init];
    [_mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_mapView setScrollEnabled:NO];
    [_mapView setZoomEnabled:NO];
    [_mapView setRotateEnabled:NO];
    [_mapView setDelegate:self];
    [self addSubview:_mapView];
    [_mapView setBackgroundColor:[UIColor redColor]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:28.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:-28.f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_label
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:28.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:0.f]];
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:_mapView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.f
                                                          constant:kHeightMapView]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:nil];
    annotationView.image = [UIImage imageNamed:@"pin.png"];
    return annotationView;
}

- (void)setText:(NSString *)text {
    if (!text) {
        return;
    }
    _text = text;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_text];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSTextAlignmentLeft];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setLineSpacing:8.f];
    [paragraph setHeadIndent:0.f];
    [paragraph setTailIndent:0.f];
    [paragraph setMinimumLineHeight:16.f];
    [paragraph setMaximumLineHeight:18.f];
    [paragraph setBaseWritingDirection:NSWritingDirectionNatural];
    [paragraph setParagraphSpacing:16.f];
    [string addAttribute:NSParagraphStyleAttributeName
                   value:paragraph
                   range:NSMakeRange(0, [string length])];
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Acrom-Light"
                                         size:16.f]
                   range:NSMakeRange(0, [string length])];
    [string addAttribute:NSForegroundColorAttributeName
                   value:RGB(208.f, 208.f, 208.f)
                   range:NSMakeRange(0, [string length])];
    [_label setAttributedText:string];
    CGSize size = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * 28.f, FLT_MAX)
                                       options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics)
                                       context:nil].size;
    [self setFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, size.height + 28.f + kHeightMapView)];
}

- (void)setCoordinates:(CGPoint)coordinates {
    _coordinates = coordinates;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_coordinates.x
                                                      longitude:_coordinates.y];
    MKCoordinateSpan span = MKCoordinateSpanMake(.008f, .008f);
    MKCoordinateRegion region = MKCoordinateRegionMake(location.coordinate, span);
    [_mapView setRegion:region
               animated:NO];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location.coordinate];
    [_mapView addAnnotation:annotation];
}

@end
