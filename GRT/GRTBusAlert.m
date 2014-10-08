//
//  GRTBusAlert.m
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTBusAlert.h"
#import "GRTBusStop.h"
#import "GRTBaseClock.h"
#import "GRTDate.h"
#import "FBKVOController.h"

@interface GRTBusAlert ()

@property (nonatomic, strong) GRTBusStop *busStop;
//@property (nonatomic, strong) GRTDate *nextBusDate;
@property (nonatomic, strong) GRTDate *commingBusDate;

@end

@implementation GRTBusAlert
{
    FBKVOController *_controller;
}

- (id)initWithBusStop:(GRTBusStop *)stop
{
    self = [self init];
    if (self)
    {
        self.busStop = stop;
        self.busDirection = stop.tripDirection;
        self.busHeadSign = stop.busName;
        self.nextBusDate = [[GRTDate alloc] init];
        _controller = [FBKVOController controllerWithObserver:self];
        GRTBaseClock *clock = [GRTBaseClock sharedInstance];
        __weak GRTBusAlert *weakself = self;
        [_controller observe:clock.date keyPath:@"second" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(GRTBusAlert *observer, GRTDate *object, NSDictionary *change) {
            [observer.nextBusDate consumeTimeInterval:[weakself findNextBusTimeInterval]];
        }];
    }
    return self;
}

- (NSTimeInterval)findNextBusTimeInterval
{
    __block NSTimeInterval nextBusTime;
    [self.busStop.arrivingTimes enumerateObjectsUsingBlock:^(GRTDate *obj, NSUInteger idx, BOOL *stop) {
        NSTimeInterval tmpTime = nextBusTime = obj.timeIntervalSinceMidnight - [GRTBaseClock sharedInstance].date.timeIntervalSinceMidnight;
        if (tmpTime > 0)
        {
            nextBusTime = tmpTime;
            *stop = YES;
        }
    }];
    return nextBusTime;
}

@end
