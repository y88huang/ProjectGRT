//
//  GRTDatabaseManager.m
//  GRT
//
//  Created by Ken Huang on 2014-09-09.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTDatabaseManager.h"
#import "FMDB.h"
#import "GRTBusTrip.h"
#import "GRTBusStop.h"

#import <UIKit/UIKit.h>

static const NSString *kDBFile = @"grtdatabase.sqlite";

@interface GRTDatabaseManager ()
{
    FMDatabaseQueue *_dbQueue;
    NSNumberFormatter *_numberFormatter;
    NSDateFormatter *_dateFormmater;
}

@end

@implementation GRTDatabaseManager

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initializeDatabase];
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        _dateFormmater = [[NSDateFormatter alloc] init];
        [_dateFormmater setDateFormat:@"HH:mm:ss"];
    }
    return self;
}

/*
 return a GRTManager singleton
 */
+ (id)sharedInstance
{
    static GRTDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GRTDatabaseManager alloc] init];
    });
    return sharedInstance;
}

/* 
 Initilize function. Copy the sqlite database from the bundle in to local directory
 */
- (void)initializeDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    success = [fileManager fileExistsAtPath:[self dbPath]];
    
    if (success)
    {
        [self dbUpdate];
        return;
    }
    
    success = [fileManager copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"grtdatabase.sqlite"] toPath:[self dbPath] error:&error];
    
    if (success)
    {
        /*do something */
    }
}

/* 
 return a dbQueue
 */
- (FMDatabaseQueue *)dbQueue
{
    return [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
}

/*
 return the name of dbFile
 */
+ (NSString *)dbFile
{
    return @"grtdatabase.sqlite";
}

/*
 Return the complete path of dbfile
 */
- (NSString *)dbPath
{
     return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"grtdatabase.sqlite"];
}

/*
 Potential update function
 */
- (void)dbUpdate
{
    /*do something */
}

/*
 Fetch All the routes info into routes
 */
- (void)getAllRoutes
{
    /*do something */
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        NSString *query =
        @"SELECT DISTINCT trip_headsign FROM trips";
        FMResultSet *result = [db executeQuery:query];
        while ([result next])
        {
            NSString *trip_headSign = [result stringForColumnIndex:0];
            
            GRTBusTrip *trip = [[GRTBusTrip alloc] init];
            trip.tripName = trip_headSign;
            [self.routes addObject:trip];
        }
        [result close];
    }];
}

- (void)getTripIDsFor:(GRTBusTrip *)trip
{
    NSString *query = @"SELECT trip_id FROM trips WHERE trip_headsign = ?";
    
    NSMutableArray *ids = [NSMutableArray array];
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:query withArgumentsInArray:@[trip.tripName]];
        while ([result next])
        {
            NSString *trip_id = [result stringForColumnIndex:0];
            NSNumber *tripID = [_numberFormatter numberFromString:trip_id];
            [ids addObject:tripID];
        }
        [result close];
    }];
    trip.tripIDs = ids;
    trip.stops = [self getStopsForTrip:trip];
}

/* 
 Fetch the time table with given trips for a specific stop
*/
- (NSMutableArray *)getTimesFor:(NSMutableArray *)array StopId:(NSNumber *)stopID
{
    NSMutableArray *times = [NSMutableArray array];
    NSString *timeQuery = @"SELECT arrival_time FROM stop_times WHERE trip_id = ? AND stop_id = ?";
    for (NSNumber *tripID in array)
    {
        [[self dbQueue] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:timeQuery withArgumentsInArray:@[tripID,stopID]];
            while ([result next])
            {
                NSString *arrivalTime = [result stringForColumnIndex:0];
                NSDate *date = [_dateFormmater dateFromString:arrivalTime];
                if (!date) {
                    NSLog(@"bad time %@, tripid is ",arrivalTime, tripID);
                }
                NSLog(@"Original string is %@, Formmated date is %@, trip id is %@",arrivalTime, date,tripID);
//                [times addObject:date];
            }
            [result close];
        }];
    }
//    times sortedArrayUsingComparator:^NSComparisonResult(NSDate *obj1, NSDate *obj2) {
//        return [obj1 com]
//    }
    return times;
}
//
//- (NSDate *)parseDateForString:(NSString *)time
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    NSTIME
//}

- (NSMutableArray *)getStopsForTrip:(GRTBusTrip *)trip
{
    NSString *query = @"SELECT stops.stop_id, stop_name, stop_sequence FROM (stops JOIN (SELECT * FROM stop_times WHERE trip_id = ?) AS tmp_stops ON tmp_stops.stop_id = stops.stop_id) ORDER BY stop_sequence";
    
    __block NSMutableArray *stops = [NSMutableArray array];
    
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:query withArgumentsInArray:@[trip.tripIDs[0]]];
        while ([result next])
        {
            NSString *stop_id = [result stringForColumnIndex:0];
            NSString *stop_name = [result stringForColumnIndex:1];
            GRTBusStop *stop = [[GRTBusStop alloc] init];
            stop.stopName = stop_name;
            stop.stopID = [_numberFormatter numberFromString:stop_id];
            [stops addObject:stop];
        }
    }];
   
    return stops;
}

- (void)fetchTimeTableForStop:(GRTBusStop *)stop OfTrip:(GRTBusTrip *)trip
{
    stop.arrivingTimes = [self getTimesFor:trip.tripIDs StopId:stop.stopID];
}

- (NSMutableArray *)routes
{
    if (!_routes)
    {
        _routes = [NSMutableArray array];
    }
    return _routes;
}

@end
