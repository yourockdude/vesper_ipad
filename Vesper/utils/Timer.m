//
//  Timer.m
//  lazypeople
//
//  Created by Владимир Псюкалов on 26.11.16.
//  Copyright © 2016 Vladimir Psyukalov. All rights reserved.
//


#import "Timer.h"


@interface Timer ()

@property (assign, nonatomic) CGFloat count;

@property (strong, nonatomic) NSTimer *timer;

@end


@implementation Timer

@synthesize delegate;

@synthesize time = _time;
@synthesize rate = _rate;

- (instancetype)initTimerWithTime:(CGFloat)time {
    self = [super init];
    if (self) {
        _rate = 1.f;
        _time = time;
    }
    return self;
}

- (void)start {
    NSTimer *currentTimer = [NSTimer scheduledTimerWithTimeInterval:_rate
                                                             target:self
                                                           selector:@selector(tick)
                                                           userInfo:nil
                                                            repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:currentTimer
                              forMode:NSRunLoopCommonModes];
    _timer = currentTimer;
}

- (void)pause {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)stop {
    [self pause];
    _count = 0.f;
}

- (void)tick {
    if (_count < _time) {
        _count += _rate;
        if (delegate) {
            [delegate didTickWithCompleteValue:_count / _time];
            [delegate didTickWithTime:[self stringFromTime:_count]];
        }
    } else {
        _count = 0.f;
        if (delegate) {
            [delegate didTimeEnd];
        }
        [self stop];
    }
}

- (NSString *)stringFromTime:(NSUInteger)time {
    NSInteger seconds = time % 60;
    NSInteger minutes = (time / 60) % 60;
    NSInteger hours = (time / 3600);
    NSString *result;
    if (hours == 0) {
        result = [NSString stringWithFormat:@"%02ld:%02ld", (unsigned long)minutes, (unsigned long)seconds];
    } else {
        result = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
    }
    return result;
}

@end
