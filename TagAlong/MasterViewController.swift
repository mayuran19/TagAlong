//
//  MasterViewController.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var searchResults = SearchResults()
    var myLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 103.7352615, longitude: 103.7352615)


    override func viewDidLoad() {
        print("111111111111111")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

    }

    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = searchResults.nameArray[indexPath.row] as! NSString
                
                let naviController = segue.destinationViewController as! UINavigationController
                let detailController = naviController.topViewController as! DetailViewController
                print(detailController)
                detailController.myHomeLocation = myLocation
                detailController.restLocation = CLLocationCoordinate2D(latitude: searchResults.latArray[indexPath.row] as! Double, longitude: searchResults.lngArray[indexPath.row] as! Double)
                detailController.object = object as String
                detailController.searchLocation = searchResults.searchLocation
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Name.count::", searchResults.nameArray.count)
        return searchResults.nameArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Cell..",indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SimpleTableCell
        
        cell.name.text = searchResults.nameArray[indexPath.row] as? String
        cell.address.text = searchResults.vicinityArray[indexPath.row] as? String
        //print(searchResults.photoArray[indexPath.row])
        if(searchResults.photoArray[indexPath.row] as! String != ""){
            var imageURL = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyAFs50MVWIeNs2PA8nYILqqn-eO7fys8G4&photoreference="
            imageURL += searchResults.photoArray[indexPath.row] as! String;
            imageURL += "&maxwidth=75"
            let url = NSURL(string : imageURL)
            let data = NSData(contentsOfURL: url!)
            cell.thumpImage.image = UIImage(data : data!)
        } else {
            cell.thumpImage.image = UIImage(named: "dine")!
        }
        cell.distance.text = searchResults.distanceArray[indexPath.row] as? String
        if(searchResults.isOpenArray[indexPath.row] as! NSObject == 1){
            cell.status.text = "Open now"
        }
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)

        //let object = names[indexPath.row] as! NSString
        //cell.textLabel!.text = searchResults.nameArray[indexPath.row] as! String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
        
}

