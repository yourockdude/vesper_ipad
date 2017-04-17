//
//  VLocationView.h
//  Vesper
//
//  Created by Vladimir Psyukalov on 09.12.16.
//  Copyright © 2016 Yourockdude. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface VLocationView : UIView

@property (strong, nonatomic) NSString *text;

@property (assign, nonatomic) CGPoint coordinates;

@end
