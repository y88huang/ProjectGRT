//
//  GRTAlarmCell.swift
//  GRT
//
//  Created by Ken Huang on 2014-09-11.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

import Foundation
import UIKit

class GRTAlarmCell : UITableViewCell {
    var leftView : UIView?;
    var centerView : UIView?;
    var routeNumberLabel : UILabel?;
    var routeDirectionLabel : UILabel?;
    var stopLabel : UILabel?;
    var busArriveLabel: UILabel?;
    var controller: FBKVOController?;
    var clock: GRTBaseClock = GRTBaseClock.sharedInstance();

    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.initView();
        self.controller = FBKVOController(observer: self);
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        self.leftView = UIView(frame: CGRectZero);
        self.centerView = UIView(frame: CGRectZero);
        self.stopLabel = UILabel(frame: CGRectZero);
        self.busArriveLabel = UILabel(frame: CGRectZero);
        
        self.routeNumberLabel = UILabel(frame: CGRectZero);
//        self.routeNumberLabel!.text = "8";
        self.routeNumberLabel!.textAlignment = NSTextAlignment.Center;
        self.routeNumberLabel!.textColor = UIColor.whiteColor();
        self.routeNumberLabel!.font = UIFont.boldSystemFontOfSize(50.0);
        
        self.routeDirectionLabel = UILabel(frame: CGRectZero);
//        self.routeDirectionLabel!.text = "University";
        self.routeDirectionLabel!.textAlignment = NSTextAlignment.Center;
        self.routeDirectionLabel!.textColor = UIColor.whiteColor();
        self.routeDirectionLabel!.font = UIFont .boldSystemFontOfSize(20.0);
        
        self.stopLabel!.textColor = UIColor.whiteColor();
        self.stopLabel!.text = "Stop:";
        self.stopLabel!.textAlignment = NSTextAlignment.Left;
        self.stopLabel!.textColor = UIColor.whiteColor();
        self.stopLabel!.font = UIFont.boldSystemFontOfSize(15.0);
        
        self.busArriveLabel!.textColor = UIColor.whiteColor();
        self.busArriveLabel!.text = "Next Bus:";
        self.busArriveLabel!.textAlignment = NSTextAlignment.Left;
        self.busArriveLabel!.textColor = UIColor.whiteColor();
        self.busArriveLabel!.font = UIFont.boldSystemFontOfSize(15.0);
        
        self.contentView.addSubview(self.leftView!);
        self.contentView.addSubview(self.centerView!);
        
        self.leftView!.addSubview(self.routeNumberLabel!);
        self.leftView!.addSubview(self.routeDirectionLabel!);
        
        self.centerView!.addSubview(self.stopLabel!);
        self.centerView!.addSubview(self.busArriveLabel!);
    }
    
    override func layoutSubviews() {
        var height : CGFloat = CGRectGetHeight(self.contentView.bounds);
        
        self.leftView?.frame = CGRectMake(0.0, 0.0, height, height);
        
        self.centerView?.frame = CGRectMake(height, 0.0, CGRectGetWidth(self.contentView.bounds) - height, height);
        self.centerView?.backgroundColor = UIColor.orangeColor();
        
        self.leftView?.backgroundColor = UIColor.blueColor();
        self.routeNumberLabel?.frame = CGRectMake(0.0, 0.0, CGRectGetHeight(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds) - 30.0);
//        self.routeNumberLabel?.backgroundColor = UIColor.orangeColor();
        
        self.routeDirectionLabel?.frame = CGRectMake(0.0, CGRectGetHeight(self.contentView.bounds) - 30.0, CGRectGetHeight(self.contentView.bounds), 30.0)
        
        self.stopLabel?.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.centerView!.frame), 15.0);
        self.busArriveLabel?.frame = CGRectMake(0.0, CGRectGetMaxY(self.stopLabel!.frame)+15.0, CGRectGetWidth(self.centerView!.frame), 15.0);
    }
}