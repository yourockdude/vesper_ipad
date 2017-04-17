//
//  VPlacesView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.11.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@protocol VPlacesViewDelegate <NSObject>

- (void)didSelectWithIndex:(NSUInteger)index
                  andPoint:(CGPoint)point;

@end


@interface VPlacesView : UIView

@property (strong, nonatomic) id <VPlacesViewDelegate> delegate;

@property (assign, nonatomic) NSUInteger index;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSString *imageURL;

@end
