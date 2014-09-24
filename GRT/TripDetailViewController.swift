//
//  TripDetailViewController.swift
//  GRT
//
//  Created by Ken Huang on 2014-09-13.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

import Foundation
import UIKit

class TripDetailViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var busTrip : GRTBusTrip?;
    var tableView : UITableView?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.whiteColor();
        initView();
    }
    
    func initView()
    {
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain);
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell");
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(self.tableView!);
        self.title = "DETAIL";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var stop : GRTBusStop! = self.busTrip?.stops[indexPath.row] as GRTBusStop;
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell;
        cell.textLabel!.text = stop.stopName;
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busTrip!.stops.count;
    }
}
