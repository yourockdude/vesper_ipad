//
//  VObjectInfoViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 05.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "VObject.h"


@interface VObjectInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *carouselContentView;
@property (weak, nonatomic) IBOutlet UIView *optionsContentView;
@property (weak, nonatomic) IBOutlet UIView *moreInfoContentView;
@property (weak, nonatomic) IBOutlet UIView *orangeLineView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (instancetype)initWithObject:(VObject *)object;

@end
