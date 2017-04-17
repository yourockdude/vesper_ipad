//
//  VAccordionControlElementsPosition.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


@interface VAccordionControlElementsPosition : NSObject

@property (assign, nonatomic) CGFloat labelLeftMargin;

@property (assign, nonatomic) CGFloat lineLeftMargin;
@property (assign, nonatomic) CGFloat lineRightMargin;

@property (assign, nonatomic) CGFloat lineBorderWidth;

@property (assign, nonatomic) CGFloat imageViewRightMargin;

@property (assign, nonatomic) CGSize imageViewSize;

- (id)init __attribute__((deprecated("Use standartProperties instead.")));

+ (id)standartProperties;

@end
