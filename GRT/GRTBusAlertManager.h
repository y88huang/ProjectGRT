//
//  GRTBusAlertManager.h
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRTBusAlert;

@interface GRTBusAlertManager : NSObject

+ (id)sharedInstance;

- (void)addAlert:(GRTBusAlert *)trip;
- (NSArray *)getCurrentAlerts;

@end
