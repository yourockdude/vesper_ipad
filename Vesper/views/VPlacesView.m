//
//  VPlacesView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VPlacesView.h"

#import "VUtils.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


@interface VPlacesView ()

@property (strong, nonatomic) UIImageView *imageView;

@end


@implementation VPlacesView

@synthesize delegate;

@synthesize index;

@synthesize imageView = _imageView;

@synthesize label = _label;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(touchUpInside)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self setGestureRecognizers:@[tap]];
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setClipsToBounds:YES];
    [self addSubview:_imageView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:0.f]];
    _label = [[UILabel alloc] init];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_label setTextAlignment:NSTextAlignmentLeft];
    [_label setNumberOfLines:2];
    [_label setLineBreakMode:NSLineBreakByWordWrapping];
    [_label setFont:[UIFont fontWithName:@"Acrom-Medium"
                                    size:16.f]];
    [_label setTextColor:[UIColor whiteColor]] ;
    [self addSubview:_label];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.f
                                                      constant:20.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.f
                                                      constant:20.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    CALayer *layer = [CALayer layer];
    layer.frame = _imageView.bounds;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [layer setOpacity:.348f];
    [_imageView.layer addSublayer:layer];
}

- (void)touchUpInside {
    if (delegate) {
        [delegate didSelectWithIndex:index
                            andPoint:self.center];
    }
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self checkImage];
}

- (void)checkImage {
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:_imageURL
                                                     done:^(UIImage *image, SDImageCacheType cacheType) {
                                                         if (!image) {
                                                             NSLog(@"Download, cache and set image: %@;", _imageURL);
                                                             [self loadImage];
                                                         } else {
                                                             NSLog(@"Set image: %@;", _imageURL);
                                                             [_imageView setImage:image];
                                                         }
                                                     }];
}

- (void)loadImage {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             [_imageView setImage:image];
                             [[SDImageCache sharedImageCache] storeImage:image
                                                                  forKey:_imageURL];
                         }];
}

@end
