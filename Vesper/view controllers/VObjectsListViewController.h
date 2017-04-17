//
//  VObjectsListViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 30.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "ICGViewController.h"

//#import "VImageView.h"

#import "VAboutUsViewController.h"

#import "VObject.h"


@protocol VObjectsListViewControllerDelegate <NSObject>

- (void)didAccelerometerUpdateWithValue:(CGFloat)value;

@end


@interface VObjectsListViewController : UIViewController <VAboutUsViewControllerDelegate>

@property (strong, nonatomic) id <VObjectsListViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *logotypeImageView;

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *updatesCountLabel;

- (instancetype)initWithObjects:(NSArray <VObject *> *)objects;

- (void)checkBadge;

- (void)updateCarousel;

@end
