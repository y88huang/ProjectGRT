//
//  GRTBaseClock.h
//  GRT
//
//  Created by Ken Huang on 2014-10-01.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRTDate;

@interface GRTBaseClock : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic,readonly) GRTDate *date;

@end
