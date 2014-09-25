//
//  AddTripViewController.swift
//  GRT
//
//  Created by Ken Huang on 2014-09-12.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

import Foundation
import UIKit

class AddTripViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tableView : UITableView?;
    var routes : NSArray?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.backgroundColor = UIColor.whiteColor();
        routes = GRTDatabaseManager.sharedInstance().routes;
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
        self.title = "ADD";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var trip : GRTBusTrip = self.routes?[indexPath.row] as GRTBusTrip;
        let cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell;
        cell.textLabel!.text = trip.tripName;
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes!.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var trip : GRTBusTrip = self.routes![indexPath.row] as GRTBusTrip;
        var DetailVC : TripDetailViewController = TripDetailViewController();
        var manager : GRTDatabaseManager = GRTDatabaseManager.sharedInstance() as GRTDatabaseManager;
        manager.getTripIDsFor(trip);
        DetailVC.busTrip = trip;
        self.navigationController!.pushViewController(DetailVC, animated: true);
    }
}
