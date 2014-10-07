//
//  GRTBusAlertManager.m
//  GRT
//
//  Created by Ken Huang on 2014-09-25.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTBusAlertManager.h"
#import "GRTBusAlert.h"
#import "FBKVOController.h"
#import "GRTDate.h"
#import "GRTBaseClock.h"

@interface GRTBusAlertManager ()

@property (nonatomic, strong) NSMutableArray *allAlerts;

@end

@implementation GRTBusAlertManager
{
    FBKVOController *kvoController;
    GRTBaseClock *clock;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.allAlerts = [NSMutableArray array];
        clock = [GRTBaseClock sharedInstance];
        kvoController = [FBKVOController controllerWithObserver:self];
        [kvoController observe:clock.date keyPath:@"timeIntervalSinceMidnight" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(GRTBusAlertManager *manager, GRTDate *tmp, NSDictionary *change) {
            }];
    }
    return self;
}

+ (instancetype)sharedInstance
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

- (NSArray *)getCurrentAlerts
{
    return self.allAlerts;
}

@end
