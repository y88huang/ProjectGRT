//
//  GRTDate.h
//  GRT
//
//  Created by Mike Di on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTDate : NSObject
@property (nonatomic,readonly) NSInteger hour;  /* 0 - 24 H */
@property (nonatomic,readonly) NSInteger minute;    /*0 - 60 Min */
@property (nonatomic,readonly) NSTimeInterval timeIntervalSinceMidnight; /* For easy computation, use sec from 00:00:00 til now as measure */

- (id) initWithString:(NSString*) time;
- (void)consumeTimeInterval:(NSTimeInterval)interval;
@end
