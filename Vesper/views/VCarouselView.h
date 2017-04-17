//
//  VCarouselView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 01.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "VObjectsListViewController.h"


@interface VCarouselView : UIView <VObjectsListViewControllerDelegate>

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *project;
@property (strong, nonatomic) NSString *address;

- (id)initWithFrame:(CGRect)frame;

@end
