//
//  VPhotoesViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 13.02.17.
//  Copyright © 2017 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "iCarousel.h"

#import "VObject.h"


@protocol VPhotoesViewControllerDelegate <NSObject>

- (void)didViewDisappearWithIndex:(NSUInteger)index;

@end


@interface VPhotoesViewController : UIViewController

@property (assign, nonatomic) id <VPhotoesViewControllerDelegate> delegate;

@property (strong, nonatomic) iCarousel *carouselView;

- (instancetype)initWithObject:(VObject *)object
                      andIndex:(NSUInteger)index;

@end
