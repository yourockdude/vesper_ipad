//
//  VAccordionControlElementsPosition.m
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "VAccordionControlElementsPosition.h"


@implementation VAccordionControlElementsPosition

@synthesize labelLeftMargin = _labelLeftMargin;

@synthesize lineLeftMargin = _lineLeftMargin;
@synthesize lineRightMargin = _lineRightMargin;

@synthesize lineBorderWidth = _lineBorderWidth;

@synthesize imageViewRightMargin = _imageViewRightMargin;

@synthesize imageViewSize = _imageViewSize;

- (id)init {
    return [super init];
}

+ (id)standartProperties {
    VAccordionControlElementsPosition *elementsPosition;
    elementsPosition = [[VAccordionControlElementsPosition alloc] initWithDefaultProperties];
    return elementsPosition;
}

- (instancetype)initWithDefaultProperties {
    self = [super init];
    if (self) {
        _labelLeftMargin = 28.f;
        _lineLeftMargin = 10.f;
        _lineRightMargin = 10.f;
        _lineBorderWidth = 1.f;
        _imageViewRightMargin = 28.f;
        _imageViewSize = CGSizeMake(20.f, 20.f);
    }
    return self;
}

@end
