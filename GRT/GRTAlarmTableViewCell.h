//
//  GRTAlarmTableViewCell.h
//  GRT
//
//  Created by Ken Huang on 2014-10-07.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTAlarmTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *routeNumberLabel;
@property (nonatomic, strong) UILabel *routeDirectionLabel;
@property (nonatomic, strong) UILabel *stopLabel;
@property (nonatomic, strong) UILabel *busArriveLabel;

@end
