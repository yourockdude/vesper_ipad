//
//  VUtils.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.10.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define APPLICATION ([UIApplication sharedApplication])

#define RGBA(R, G, B, A) ([UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:A / 255.f])
#define RGB(R, G, B) ([UIColor colorWithRed:R / 255.f green:G / 255.f blue:B / 255.f alpha:1.f])

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define LOCALIZE(S) (NSLocalizedString(S, nil))

#define DEGREES_TO_RADIANS(D) ((M_PI * D) / 180.f)


@interface VUtils : NSObject

+ (void)applyCornerRadii:(NSArray *)cornerRadii
                forViews:(NSArray<UIView *> *)views;

+ (void)registerStringNameTableViewCellClass:(NSString *)stringName
                                forTableView:(UITableView *)tableView
                         withReuseIdentifier:(NSString *)reuseIdentifier;

+ (NSString *)stringWithDeviceToken:(NSData *)deviceToken;

@end
