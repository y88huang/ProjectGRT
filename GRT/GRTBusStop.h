//
//  GRTBusStop.h
//  GRT
//
//  Created by Ken Huang on 2014-09-12.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTBusStop : NSObject

@property (nonatomic, strong) NSString *tripDirection;
@property (nonatomic, strong) NSString *busName;

@property (nonatomic, copy) NSString *stopName;
@property (nonatomic, strong) NSNumber *stopID;
@property (nonatomic, strong) NSMutableArray *arrivingTimes;

@end
