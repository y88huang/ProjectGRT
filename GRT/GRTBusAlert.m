//
//  GRTBusAlert.m
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTBusAlert.h"
#import "GRTBusStop.h"

@interface GRTBusAlert ()

@property (nonatomic, strong) GRTBusStop *busStop;

@end

@implementation GRTBusAlert

- (id)initWithBusStop:(GRTBusStop *)stop
{
    self = [self init];
    if (self)
    {
        self.busStop = stop;
        self.busDirection = stop.tripDirection;
        self.busHeadSign = stop.busName;
    }
    return self;
}

@end
