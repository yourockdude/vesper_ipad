//
//  VTeamView.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 12.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VTeamView.h"

#import "VUtils.h"


//#define kCustomHeight (2 * (44.f + 28.f) + 8.f)


@interface VTeamView ()

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIButton *site_1_Button;
@property (strong, nonatomic) UIButton *site_2_Button;

@end


@implementation VTeamView

@synthesize delegate;

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
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label sizeToFit];
    [_label setNumberOfLines:0];
    [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:_label];
    
    
//    UIFont *font_1 = [UIFont fontWithName:@"Acrom-Medium"
//                                     size:16.f];
//    UIFont *font_2 = [UIFont fontWithName:@"Acrom-Light"
//                                     size:18.f];

//    _site_1_Button = [[UIButton alloc] init];
//    [_site_1_Button.titleLabel setFont:font_1];
//    [_site_1_Button setTitleColor:[UIColor whiteColor]
//                         forState:UIControlStateNormal];
//    [_site_1_Button setBackgroundColor:[UIColor clearColor]];
//    [_site_1_Button setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_site_1_Button addTarget:self
//                       action:@selector(site_1_TUI:)
//             forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_site_1_Button];
//    
//    _site_2_Button = [[UIButton alloc] init];
//    [_site_2_Button.titleLabel setFont:font_2];
//    [_site_2_Button setTitleColor:RGB(164.f, 80.f, 42.f)
//                         forState:UIControlStateNormal];
//    [_site_2_Button setBackgroundColor:[UIColor clearColor]];
//    [_site_2_Button setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [_site_2_Button addTarget:self
//                       action:@selector(site_2_TUI:)
//             forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_site_2_Button];
    
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
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.f
                                                      constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.f
                                                      constant:0.f]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_1_Button
//                                                     attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:_label
//                                                     attribute:NSLayoutAttributeBottom
//                                                    multiplier:1.f
//                                                      constant:28.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_1_Button
//                                                     attribute:NSLayoutAttributeLeft
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeLeft
//                                                    multiplier:1.f
//                                                      constant:0.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_1_Button
//                                                     attribute:NSLayoutAttributeRight
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeRight
//                                                    multiplier:1.f
//                                                      constant:0.f]];
//    [_site_1_Button addConstraint:[NSLayoutConstraint constraintWithItem:_site_1_Button
//                                                               attribute:NSLayoutAttributeHeight
//                                                               relatedBy:NSLayoutRelationEqual
//                                                                  toItem:nil
//                                                               attribute:NSLayoutAttributeNotAnAttribute
//                                                              multiplier:1.f
//                                                                constant:44.f]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_2_Button
//                                                     attribute:NSLayoutAttributeTop
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:_site_1_Button
//                                                     attribute:NSLayoutAttributeBottom
//                                                    multiplier:1.f
//                                                      constant:8.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_2_Button
//                                                     attribute:NSLayoutAttributeLeft
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeLeft
//                                                    multiplier:1.f
//                                                      constant:8.f]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:_site_2_Button
//                                                     attribute:NSLayoutAttributeRight
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self
//                                                     attribute:NSLayoutAttributeRight
//                                                    multiplier:1.f
//                                                      constant:-8.f]];
//    [_site_2_Button addConstraint:[NSLayoutConstraint constraintWithItem:_site_2_Button
//                                                               attribute:NSLayoutAttributeHeight
//                                                               relatedBy:NSLayoutRelationEqual
//                                                                  toItem:nil
//                                                               attribute:NSLayoutAttributeNotAnAttribute
//                                                              multiplier:1.f
//                                                                constant:44.f]];
    
    [self buttonsSetup];
}

- (void)buttonsSetup {
    [_site_1_Button setImage:[UIImage imageNamed:@"big_right_arrow_button_default.png"]
                    forState:UIControlStateNormal];
    [_site_1_Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_site_1_Button setImageEdgeInsets:UIEdgeInsetsMake(0.f, SCREEN_WIDTH - 35 - 28.f, 0.f, 0.f)];
    [_site_1_Button setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -35.f + 28.f, 0.f, 0.f)];
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
    [paragraph setMinimumLineHeight:0.f];
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
    [self setFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, size.height)];
}

- (void)setSite_1:(NSString *)site_1 {
    _site_1 = site_1;
    [_site_1_Button setTitle:_site_1
                    forState:UIControlStateNormal];
}

- (void)setSite_2:(NSString *)site_2 {
    _site_2 = site_2;
    [_site_2_Button setTitle:_site_2
                    forState:UIControlStateNormal];
}

- (void)site_1_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didTUISite_1];
    }
}

- (void)site_2_TUI:(UIButton *)sender {
    if (delegate) {
        [delegate didTUISite_2];
    }
}

@end
