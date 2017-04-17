//
//  VCarouselView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 01.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VCarouselView.h"

#import "VUtils.h"

#import "UIImageView+WebCache.h"
#import "SDImageCache.h"


@interface VCarouselView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) UILabel *labelProject;
@property (strong, nonatomic) UILabel *labelAddress;

@end


@implementation VCarouselView

@synthesize contentView = _contentView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_contentView];
    _imageView = [[UIImageView alloc] initWithFrame:_contentView.bounds];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView.layer setContentsRect:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    [_imageView setClipsToBounds:YES];
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_imageView];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.f
                                                              constant:0.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.f
                                                              constant:0.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:0.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.f
                                                              constant:0.f]];
    _labelProject = [[UILabel alloc] init];
    [_labelProject setFont:[UIFont fontWithName:@"Acrom-Bold"
                                           size:42.f]];
    [_labelProject sizeToFit];
    [_labelProject setTextColor:[UIColor whiteColor]];
    [_labelProject setLineBreakMode:NSLineBreakByWordWrapping];
    [_labelProject setNumberOfLines:0];
    [_labelProject setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_labelProject];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelProject
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.f
                                                              constant:30.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelProject
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:-30.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelProject
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.f
                                                              constant:-88.f]];
    _arrowImageView = [[UIImageView alloc] init];
    [_arrowImageView setContentMode:UIViewContentModeRight];
    [_arrowImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_arrowImageView setClipsToBounds:YES];
    [_arrowImageView setImage:[UIImage imageNamed:@"big_right_arrow_button_default.png"]];
    [_contentView addSubview:_arrowImageView];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowImageView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:-22.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_arrowImageView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_labelProject
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.f
                                                              constant:8.f]];
    _labelAddress = [[UILabel alloc] init];
    [_labelAddress setFont:[UIFont fontWithName:@"Acrom-Medium"
                                           size:18.f]];
    [_labelAddress sizeToFit];
    [_labelAddress setTextColor:[UIColor whiteColor]];
    [_labelAddress setLineBreakMode:NSLineBreakByWordWrapping];
    [_labelAddress setNumberOfLines:0];
    [_labelAddress setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_labelAddress];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelAddress
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.f
                                                              constant:30.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelAddress
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_contentView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.f
                                                              constant:-74.f]];
    [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:_labelAddress
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:_labelProject
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.f
                                                              constant:0.f]];
    CALayer *layer = [CALayer layer];
    layer.frame = _imageView.bounds;
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [layer setOpacity:.348f];
    [_imageView.layer addSublayer:layer];
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

- (void)setImage:(UIImage *)image {
    _image = image;
    [_imageView setImage:_image];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;
    [self checkImage];
}

- (void)setProject:(NSString *)project {
    _project = project;
    [_labelProject setText:_project];
}

- (void)setAddress:(NSString *)address {
    _address = address;
    [_labelAddress setText:_address];
}

- (void)didAccelerometerUpdateWithValue:(CGFloat)value {
    if (!_imageView.image) {
        return;
    }
    CGRect resultRect;
    CGFloat scaleHeight = SCREEN_HEIGHT / _imageView.image.size.height;
    CGFloat offset = (1.f - (SCREEN_WIDTH / (_imageView.image.size.width * scaleHeight))) / 2;
    if (value < -.2f) {
        resultRect = CGRectMake(-offset, 0.f, 1.f, 1.f);
    } else if (value > .2f) {
        resultRect = CGRectMake(offset, 0.f, 1.f, 1.f);
    } else if (value >= -.2f && value <= 2.f) {
        resultRect = CGRectMake(0.f, 0.f, 1.f, 1.f);
    }
    [UIView animateWithDuration:1
                     animations:^{
                         [_imageView.layer setContentsRect:resultRect];
                     }
                     completion:nil];
}

@end
