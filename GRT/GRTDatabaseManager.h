//
//  GRTDatabaseManager.h
//  GRT
//
//  Created by Ken Huang on 2014-09-09.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GRTBusTrip;
@class GRTBusStop;

@interface GRTDatabaseManager : NSObject

@property (nonatomic, strong) NSMutableArray *routes;

+ (id)sharedInstance;
- (void)getAllRoutes;

/*
    Get stop_time of a given set of trip_ids.
 */
- (void)getTripIDsFor:(GRTBusTrip *)trip;

//
/*
    Fetch the time table for the GRTBusStop from the tripids specified in GRTBusTrip
 */
- (void)fetchTimeTableForStop:(GRTBusStop *)stop OfTrip:(GRTBusTrip *)trip;

@end
