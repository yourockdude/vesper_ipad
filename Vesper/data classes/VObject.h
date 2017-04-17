//
//  VObject.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 28.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


@interface VObject : NSObject

@property (assign, nonatomic) NSUInteger identifier;
@property (assign, nonatomic) NSUInteger apartmentsCount;
@property (assign, nonatomic) NSUInteger type;

@property (strong, nonatomic) NSMutableArray <NSString *> *photos;

@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *littleDescription;
@property (strong, nonatomic) NSString *ready;
@property (strong, nonatomic) NSString *square;
@property (strong, nonatomic) NSString *largeDescription;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *team;
@property (strong, nonatomic) NSString *customURL;
@property (strong, nonatomic) NSString *objectURL;
@property (strong, nonatomic) NSString *documentURL;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *telephone;


@end
