//
//  GRTBusTrip.h
//  GRT
//
//  Created by Ken Huang on 2014-09-12.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTBusTrip : NSObject

@property (nonatomic, copy) NSString *tripName;
@property (nonatomic, strong) NSNumber *routeID;
@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong) NSMutableArray *stopIDs;
@property (nonatomic, strong) NSMutableArray *times;

@end
