//
//  NearbyMasterController.swift
//  TagAlong
//
//  Created by William Selamat Djingga on 7/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation
import UIKit

class NearbyMasterController: UITableViewController {
    
    var nearbyDetailController: NearbyDetailController? = nil
    
    var companions: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companions = User.getExistingCompanion()
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        if let split = self.splitViewController{
            let controllers = split.viewControllers
            self.nearbyDetailController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? NearbyDetailController
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let companion = companions[indexPath.row] as! User
                
                let controller = segue.destinationViewController as! NearbyDetailController
                controller.companion = companion
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let companion = companions[indexPath.row] as! User
        cell.textLabel?.text = companion.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}
