//
//  GRTDate.m
//  GRT
//
//  Created by Mike Di on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTDate.h"

@implementation GRTDate

//- (NSInteger) hour{
//    NSInteger ho = 0;
//    return ho;
//}
//
//- (NSInteger) minute{
//    NSInteger min = 0;
//    return min;
//}
//
//- (NSTimeInterval) second{
//    NSTimeInterval sec = 0;
//    return sec;
//}

- (id) initWithString:(NSString *)time
{
    self = [super init];
    if(self)
    {
        NSArray *t = [time componentsSeparatedByString:@":"];
        _hour = [t[0] integerValue];
        _minute = [t[1] integerValue];
        _second = (NSTimeInterval)[t[2] integerValue];
        

    }
    return self;
}

@end
