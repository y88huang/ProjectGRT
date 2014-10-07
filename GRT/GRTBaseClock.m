//
//  GRTBaseClock.m
//  GRT
//
//  Created by Ken Huang on 2014-10-01.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTBaseClock.h"
#import "GRTDate.h"

@interface GRTBaseClock ()

@property (strong, nonatomic) GRTDate *date;

@end

@implementation GRTBaseClock
{
    dispatch_source_t _timer;
    NSDateFormatter *_formatter;
}

+ (instancetype)sharedInstance
{
    static GRTBaseClock *clock = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clock = [[GRTBaseClock alloc] init];
    });
    return clock;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self update];
        _formatter = [[NSDateFormatter alloc] init];
        _date = [[GRTDate alloc] init];
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
        __weak GRTBaseClock *weakSelf = self;
        dispatch_source_set_event_handler(timer, ^{
            [weakSelf update];
        });
        _timer = timer;
        dispatch_resume(timer);
    }
    return self;
}

- (void)update
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    date = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    [self.date consumeTimeInterval:time];
    NSLog(@"Updating");
}

- (void)dealloc
{
    if (_timer != NULL)
    {
        dispatch_source_cancel(_timer);
    }
}

@end
