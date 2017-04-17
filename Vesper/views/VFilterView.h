//
//  VFilterView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 08.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VFilterViewDelegate <NSObject>

@optional

- (void)didCloseFilterView;

- (void)didSelectAll;
- (void)didSelectAvailability;

@end


@interface VFilterView : UIView

@property (assign, nonatomic) id <VFilterViewDelegate> delegate;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
