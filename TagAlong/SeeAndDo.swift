//
//  SeeAndDo.swift
//  PT_4SwiftProject
//
//  Created by William Selamat Djingga on 23/4/16.
//  Copyright © 2016 sg.edu.nus.iss.wlad. All rights reserved.
//

import Foundation
import UIKit

class SeeAndDo: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nearbySwitch: UISwitch!
    
    //variable to hold table view list
    var placePreference = [String]()
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = true
        
        //init the array
        placePreference.append("NATURE")
        placePreference.append("CULTURAL")
        placePreference.append("SHOPPING")
        placePreference.append("SPORTS")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return placePreference.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SeeAndDoTableViewCell
        cell.cellText.text = placePreference[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return tableView.frame.height / CGFloat(placePreference.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print(indexPath.row)
        selectedIndex = indexPath.row
    }
    
    @IBAction func searchButtonTapped(sender: AnyObject) {
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(selectedIndex == nil){
            let alertController = UIAlertController(title: "Error", message: "Select a category", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let seeAndDoTableViewController = segue.destinationViewController as! SeeAndDoTableViewController
        seeAndDoTableViewController.selectedType = selectedIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}