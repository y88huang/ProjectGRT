//
//  GRTAlarmTableViewCell.m
//  GRT
//
//  Created by Ken Huang on 2014-10-07.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import "GRTAlarmTableViewCell.h"
#import "FBKVOController.h"
#import "GRTBaseClock.h"
#import "GRTDate.h"
#import "GRTBusAlert.h"

#define SECOND(sec) [NSString stringWithFormat: sec < 10? @"0%d sec" : @"%d sec",(int)sec];
#define MINUTE(min) [NSString stringWithFormat: min < 10? @"0%d min" : @"%d min",(int)min];

@interface GRTAlarmTableViewCell()

@property (nonatomic, strong) FBKVOController *controller;
@property (nonatomic, strong) UILabel *sec;
@property (nonatomic, strong) UILabel *HLabel;

@end

@implementation GRTAlarmTableViewCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initView];
        self.controller = [FBKVOController controllerWithObserver:self];
        /* observe the clock */
    }
    return self;
}

-(void)setupViewWithAlert:(GRTBusAlert *)alert
{
    self.alert = alert;
    [self.controller observe:self.alert.nextBusDate keyPath:@"second" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(GRTAlarmTableViewCell *cell, GRTDate *date, NSDictionary *change) {
//        cell.HLabel.text = MINUTE(alert.nextBusDate.minute);
//        cell.busArriveLabel.text = SECOND(alert.nextBusDate.second);
        NSString *minString = MINUTE(alert.nextBusDate.minute);
        NSString *secString = SECOND(alert.nextBusDate.second);
        cell.busArriveLabel.text = [NSString stringWithFormat:@"Next Bus: %@ %@",minString,secString];
    }];
//    [self.controller observe:self.alert.nextBusDate keyPath:@"hour" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(GRTAlarmTableViewCell *cell, GRTDate *date, NSDictionary *change) {
//        
//    }];
}

//View init.
-(void)initView
{
    self.leftView = [[UIView alloc] initWithFrame:CGRectZero];
    self.centerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.stopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.busArriveLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.routeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //        self.routeNumberLabel!.text = "8";
    self.routeNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.routeNumberLabel.textColor = [UIColor whiteColor];
    self.routeNumberLabel.font = [UIFont boldSystemFontOfSize:50.0f];
    
    self.routeDirectionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    //        self.routeDirectionLabel!.text = "University";
    self.routeDirectionLabel.textAlignment = NSTextAlignmentCenter;
    self.routeDirectionLabel.textColor = [UIColor whiteColor];
    self.routeDirectionLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    
    self.stopLabel.textColor = [UIColor whiteColor];
    self.stopLabel.text = @"Stop:";
    self.stopLabel.textAlignment = NSTextAlignmentLeft;
    self.stopLabel.textColor = [UIColor whiteColor];
    self.stopLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    self.busArriveLabel.textColor = [UIColor whiteColor];
    self.busArriveLabel.text = @"Next Bus: ";
    self.busArriveLabel.textAlignment = NSTextAlignmentLeft;
    self.busArriveLabel.textColor = [UIColor whiteColor];
    self.busArriveLabel.font = [UIFont systemFontOfSize:15.0f];
    self.busArriveLabel.backgroundColor = [UIColor blackColor];
    
    [self.contentView addSubview:self.leftView];
    [self.contentView addSubview:self.centerView];
    
    [self.leftView addSubview:self.routeNumberLabel];
    [self.leftView addSubview:self.routeDirectionLabel];
    
    [self.centerView addSubview:self.stopLabel];
    [self.centerView addSubview:self.busArriveLabel];
    self.HLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.centerView addSubview:self.HLabel];
    self.HLabel.backgroundColor = [UIColor redColor];
    self.HLabel.textAlignment = NSTextAlignmentLeft;
    self.HLabel.textColor = [UIColor whiteColor];
    self.HLabel.font = [UIFont systemFontOfSize:15.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    self.leftView.frame = CGRectMake(0.0f, 0.0f, height, height);
    self.centerView.frame = CGRectMake(height, 0.0f, CGRectGetWidth(self.contentView.bounds) - height, height);
    self.centerView.backgroundColor = [UIColor orangeColor];
    self.leftView.backgroundColor = [UIColor blueColor];
    self.routeDirectionLabel.frame = CGRectMake(0.0f,
                                                0.0f,
                                                CGRectGetHeight(self.contentView.bounds),
                                                CGRectGetHeight(self.contentView.frame) - 30.0f);
    self.stopLabel.frame = CGRectMake(0.0f,
                                      0.0f,
                                      CGRectGetWidth(self.centerView.frame),
                                      15.0f);
    
    self.busArriveLabel.frame = CGRectMake(0.0f,
                                           CGRectGetMaxY(self.stopLabel.frame) + 15.0f,
                                           CGRectGetWidth(self.centerView.frame),
                                           15.0f);
//    self.HLabel.frame = CGRectMake(CGRectGetMaxX(self.busArriveLabel.frame), CGRectGetMaxY(self.stopLabel.frame) + 15.0f, CGRectGetWidth(self.centerView.frame) / 3.0f, 15.0f);
}

@end
