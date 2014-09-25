//
//  GRTBusAlert.h
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRTBusAlert : NSObject

@property (nonatomic, copy) NSString *busHeadSign;
@property (nonatomic, copy) NSString *stopName;
@property (nonatomic, strong) NSNumber *stopID;
@property (nonatomic, strong) NSArray *timeTable;

@end
