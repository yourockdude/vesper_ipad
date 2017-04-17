//
//  VRadialAnimation.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 01.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import "ICGBaseAnimation.h"

typedef NS_ENUM(NSInteger, VRadialSubtype) {
    VRadialSubtypeFromLogotypeToList = 0,
    VRadialSubtypeFromListToInfo = 1,
    VRadialSubtypeFromInfoToList = 2,
    VRadialSubtypeFromInfoToPhotoes = 3,
    VRadialSubtypeFromPhotoesToInfo = 4
};

@interface VRadialAnimation : ICGBaseAnimation

+ (id)sharedAnimation;

- (instancetype)init;

@property (strong, nonatomic) UIView *contentView;

@property (assign, nonatomic) CGPoint point;

@property (assign, nonatomic) VRadialSubtype subtype;

@end
