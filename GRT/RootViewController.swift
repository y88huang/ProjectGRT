//
//  ViewController.swift
//  GRT
//
//  Created by Ken Huang on 2014-09-09.
//  Copyright (c) 2014 Ken Huang. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?;
    let manager = GRTDatabaseManager.sharedInstance() as GRTDatabaseManager;
    
    var dataSource = [3];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blackColor();
        manager.getAllRoutes();
        initView();
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView?.reloadData();
    }
    
    func initView(){
        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain);
        self.tableView!.dataSource = self;
        self.tableView!.delegate = self;
        self.tableView!.registerClass(GRTAlarmCell.self, forCellReuseIdentifier:"cell");
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.view.addSubview(self.tableView!);
        self.title = "GRT";
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 0.0, green: 47.0/255.0, blue: 167.0/255.0, alpha: 1.0);
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        var button = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: "add");
        self.navigationItem.rightBarButtonItem = button;
    }
    
    func add(){ /* add view vc */
        var addVC : AddTripViewController = AddTripViewController();
        self.navigationController!.pushViewController(addVC, animated: true);
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as GRTAlarmCell;
      
        cell.backgroundColor = UIColor.lightGrayColor();
        return cell;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 100.0;
    }
}

