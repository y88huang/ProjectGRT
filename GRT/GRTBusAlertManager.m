//
//  GRTBusAlertManager.m
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTBusAlertManager.h"
#import "GRTBusAlert.h"

@interface GRTBusAlertManager ()

@property (nonatomic, strong) NSMutableArray *allAlerts;

@end

@implementation GRTBusAlertManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.allAlerts = [NSMutableArray array];
    }
    return self;
}

+ (id)sharedInstance
{
    static GRTBusAlertManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GRTBusAlertManager alloc] init];
    });
    return sharedInstance;
}

- (void)addAlert:(GRTBusAlert *)trip
{
    [self.allAlerts addObject:trip];
}

@end
