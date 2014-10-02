//
//  GRTDate.m
//  GRT
//
//  Created by Mike Di on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTDate.h"

@implementation GRTDate

- (id) initWithString:(NSString *)time
{
    self = [super init];
    if(self)
    {
        NSArray *t = [time componentsSeparatedByString:@":"];
        _hour = [t[0] integerValue];
        _minute = [t[1] integerValue];
        _timeIntervalSinceMidnight = _hour * 3600 + _minute * 60;
    }
    return self;
}

- (void)consumeTimeInterval:(NSTimeInterval)interval
{
    _hour = floor(interval / 3600);
    _minute = floor((interval - _hour * 3600) / 60);
    _timeIntervalSinceMidnight = interval;
}

@end
