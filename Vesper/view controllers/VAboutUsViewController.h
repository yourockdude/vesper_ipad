//
//  VAboutUsViewController.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VAboutUsViewControllerDelegate <NSObject>

- (void)didSelectObjectWithIdentifier:(NSUInteger)identifier
                            withPoint:(CGPoint)point;

@end


@interface VAboutUsViewController : UIViewController

@property (strong, nonatomic) id <VAboutUsViewControllerDelegate> delegate;

@end
