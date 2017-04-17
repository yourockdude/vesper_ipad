//
//  Timer.h
//  lazypeople
//
//  Created by Владимир Псюкалов on 26.11.16.
//  Copyright © 2016 Vladimir Psyukalov. All rights reserved.
//


#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class Timer;

@protocol TimerDelegate <NSObject>

@required

- (void)didTickWithCompleteValue:(CGFloat)value;
- (void)didTickWithTime:(NSString *)time;

- (void)didTimeEnd;

@end


@interface Timer : NSObject

@property (assign, nonatomic) id <TimerDelegate> delegate;

@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) CGFloat rate;

- (instancetype)initTimerWithTime:(CGFloat)time;

- (void)start;
- (void)pause;
- (void)stop;

@end
