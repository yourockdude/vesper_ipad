//
//  VAccordionControl.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 27.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "VAccordionControlElementsPosition.h"


@class VAccordionControl;


@protocol VAccordionControlFunctionsDelegate <NSObject>

@optional

- (void)didOpenAccordionControl:(nonnull VAccordionControl *)accordionControl;
- (void)didCloseAccordionControl:(nonnull VAccordionControl *)accordionControl;

@end

@protocol VAccordionControlVisualDelegate <NSObject>

@required

- (nonnull VAccordionControlElementsPosition *)elementsPositionForAccordionCntrol:(nonnull VAccordionControl *)accordionControl;

- (nonnull UIColor *)colorForOpenedAccordionControl:(nonnull VAccordionControl *)accordionControl;
- (nonnull UIColor *)colorForClosedAccordionControl:(nonnull VAccordionControl *)accordionControl;

- (nonnull UIImage *)imageForOpenedAccordionControl:(nonnull VAccordionControl *)accordionControl;
- (nonnull UIImage *)imageForClosedAccordionControl:(nonnull VAccordionControl *)accordionControl;

- (nonnull UIColor *)colorForLineViewAccordionControl:(nonnull VAccordionControl *)accordionControl;

@end


@interface VAccordionControl : UIControl

@property (assign, nonatomic, nonnull) id <VAccordionControlFunctionsDelegate> functionsDelegate;
@property (assign, nonatomic, nonnull) id <VAccordionControlVisualDelegate> visualDelegate;

@property (strong, nonatomic, nonnull) NSString *title;

@property (assign, nonatomic) BOOL showed;

- (nonnull instancetype)initWithFrame:(CGRect)frame
                            withTitle:(nonnull NSString *)title;

@end
