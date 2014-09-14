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
    }
    return self;
}

+ (id)sharedInstance
{
    static GRTDatabaseManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GRTDatabaseManager alloc] init];
    });
    return sharedInstance;
}

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

- (FMDatabaseQueue *)dbQueue
{
    return [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
}

+ (NSString *)dbFile
{
    return @"grtdatabase.sqlite";
}

- (NSString *)dbPath
{
     return [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"grtdatabase.sqlite"];
}

- (void)dbUpdate
{
    /*do something */
}

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
//            NSString *trip_id = [result stringForColumnIndex:1];
//            NSString *route_id = [result stringForColumnIndex:2];
            GRTBusTrip *trip = [[GRTBusTrip alloc] init];
            
            trip.tripName = trip_headSign;
//            trip.tripID = [_numberFormatter numberFromString:trip_id];
//            trip.routeID = [_numberFormatter numberFromString:route_id];
            
            [self.routes addObject:trip];
//            NSLog(@"%@",trip_headSign);
        }
        [result close];
    }];
    for (GRTBusTrip *trip in self.routes)
    {
        [self getTripIDsFor:trip];
    }
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
            NSLog(@"%@ IS %@",trip.tripName, tripID);
        }
        [result close];
    }];
    trip.times = [self getTimesFor:ids];
    trip.stopIDs = ids;
    trip.stops = [self getStopsForTrip:trip];
}

- (NSMutableArray *)getTimesFor:(NSMutableArray *)array
{
    NSMutableArray *times = [NSMutableArray array];
    NSString *timeQuery = @"SELECT arrival_time FROM stop_times WHERE trip_id = ?";
    for (NSNumber *tripID in array)
    {
        [[self dbQueue] inDatabase:^(FMDatabase *db) {
            FMResultSet *result = [db executeQuery:timeQuery withArgumentsInArray:@[tripID]];
            while ([result next])
            {
                NSString *arrivalTime = [result stringForColumnIndex:0];
                [times addObject:arrivalTime];
            }
            [result close];
        }];
    }
    return times;
}

- (NSMutableArray *)getStopsForTrip:(GRTBusTrip *)trip
{
    NSString *query = @"SELECT arrival_time, stop_name, stop_sequence FROM (stops JOIN (SELECT * FROM stop_times WHERE trip_id = ?) AS tmp_stops ON tmp_stops.stop_id = stops.stop_id) ORDER BY stop_sequence";
    
    __block NSMutableArray *stops = [NSMutableArray array];
    
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:query withArgumentsInArray:@[trip.stopIDs[0]]];
        while ([result next])
        {
            NSString *arrival_time = [result stringForColumnIndex:0];
            NSString *stop_name = [result stringForColumnIndex:1];
//            NSString *stop_id = [result stringForColumnIndex:2];
            GRTBusStop *stop = [[GRTBusStop alloc] init];
            stop.stopName = stop_name;
//            stop.stopID = [_numberFormatter numberFromString:stop_id];
            [stops addObject:stop];
        }
    }];
    return stops;
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
