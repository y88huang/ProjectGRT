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
#import "GRTDate.h"

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
+ (instancetype)sharedInstance
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
                GRTDate *time = [[GRTDate alloc] initWithString:arrivalTime];
                [times addObject:time];
            }
            [result close];
        }];
    }
    [times sortUsingComparator:^NSComparisonResult(GRTDate *obj1, GRTDate *obj2) {
        if(obj1.hour != obj2.hour)
        {
            if(obj1.hour > obj2.hour)
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedAscending;
        }
        if(obj1.minute != obj2.minute)
        {
            if(obj1.minute > obj2.minute)
                return (NSComparisonResult)NSOrderedDescending;
            else
                return (NSComparisonResult)NSOrderedAscending;
        }
        if(obj1.timeIntervalSinceMidnight > obj2.timeIntervalSinceMidnight)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedAscending;
    }];
    
    for(GRTDate *date in times)
    {
        NSLog(@"%ld:%ld:00",date.hour, date.minute);
    }
    return times;
}

- (NSMutableArray *)getStopsForTrip:(GRTBusTrip *)trip
{
    NSString *query = @"SELECT stops.stop_id, stop_name, stop_sequence FROM (stops JOIN (SELECT * FROM stop_times WHERE trip_id = ?) AS tmp_stops ON tmp_stops.stop_id = stops.stop_id) ORDER BY stop_sequence";
    
    __block NSMutableArray *stops = [NSMutableArray array];
    NSString *busName = [self getTripNumberFromTripName:trip.tripName];
    NSString *direction = [self getTripDirectionFromTripName:trip.tripName];
    [[self dbQueue] inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:query withArgumentsInArray:@[trip.tripIDs[0]]];
        while ([result next])
        {
            NSString *stop_id = [result stringForColumnIndex:0];
            NSString *stop_name = [result stringForColumnIndex:1];
            GRTBusStop *stop = [[GRTBusStop alloc] init];
            stop.stopName = stop_name;
            stop.tripDirection = direction;
            stop.busName = busName;
            stop.stopID = [_numberFormatter numberFromString:stop_id];
            [stops addObject:stop];
        }
    }];
    return stops;
}

- (NSString *)getTripDirectionFromTripName:(NSString *)name
{
    //Assume no empty string.
    NSArray *tokens = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *tmpTokens = [NSMutableArray arrayWithArray:tokens];
    [tmpTokens removeObjectAtIndex:0];
    if ([tmpTokens count] > 1)
    {
        return [tmpTokens componentsJoinedByString:@" "];
    }
    return nil;
}

- (NSString *)getTripNumberFromTripName:(NSString *)name
{
    NSArray *tokens = [name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *tmpTokens = [NSMutableArray arrayWithArray:tokens];
    NSString *tripNumber = tmpTokens[0];
    if ([tripNumber rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound)
    {
        return tripNumber;
    }else{
        return [tripNumber substringToIndex:[tripNumber length] -2];
    }
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
