//
//  GRTBusAlert.h
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRTBusStop;

@interface GRTBusAlert : NSObject

@property (nonatomic, copy) NSString *busHeadSign;
@property (nonatomic, copy) NSString *busDirection;
@property (nonatomic, strong, readonly) GRTBusStop *busStop;

- (id)initWithBusStop:(GRTBusStop *)stop;

@end
