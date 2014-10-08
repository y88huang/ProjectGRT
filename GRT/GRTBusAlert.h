//
//  GRTBusAlert.h
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRTBusStop;
@class GRTDate;

@interface GRTBusAlert : NSObject

@property (nonatomic, copy) NSString *busHeadSign;
@property (nonatomic, copy) NSString *busDirection;
@property (nonatomic, strong, readonly) GRTBusStop *busStop;

@property (nonatomic, strong) GRTDate *nextBusDate;
@property (nonatomic, strong, readonly) GRTDate *commingBusDate;

- (id)initWithBusStop:(GRTBusStop *)stop;

@end
