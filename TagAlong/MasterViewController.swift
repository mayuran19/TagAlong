//
//  MasterViewController.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController,NSURLSessionDataDelegate {
    
    var buffer:NSMutableData!;
    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var searchResults = SearchResults()
    var myLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 103.7352615, longitude: 103.7352615)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buffer = NSMutableData();
        var urlString : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
        urlString += String(self.myLocation.latitude)
        urlString += ","
        urlString += String(self.myLocation.longitude)
        urlString += "&radius=1000&types=restaurant&key=AIzaSyAFs50MVWIeNs2PA8nYILqqn-eO7fys8G4"
        let url:NSURL = NSURL(string: urlString)!
        print(url)
        
        let defaultConfigObject:NSURLSessionConfiguration =
            NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: NSOperationQueue.mainQueue());
        
        session.dataTaskWithURL(url).resume()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        print ("URLSession:dataTask:didReceiveData")
        buffer.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error == nil) {
            print ("Done with bytes " + String(buffer.length))
            self.processResponse(buffer);
            self.tableView.reloadData()
            
            /*let sb = UIStoryboard(name: "Main", bundle: nil)
             let vc = sb.instantiateViewControllerWithIdentifier("dineSearchNavController") as! UINavigationController
             
             
             let toViewController1:MasterViewController =
             vc.topViewController as! MasterViewController
             
             toViewController1.searchResults = self.searchResults;
             toViewController1.myLocation = myLocation
             self.presentViewController(vc, animated: true, completion: nil)*/
        }
        else {
            print("Error %@",error!.userInfo);
            print("Error description %@", error!.localizedDescription);
            print("Error domain %@", error!.domain);
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("dineSearch") as! DineSearchViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let object = searchResults.nameArray[indexPath.row] as! NSString
            
            let detailController = segue.destinationViewController as! DetailViewController
            print(detailController)
            detailController.myHomeLocation = myLocation
            detailController.restLocation = CLLocationCoordinate2D(latitude: searchResults.latArray[indexPath.row] as! Double, longitude: searchResults.lngArray[indexPath.row] as! Double)
            detailController.object = object as String
            detailController.searchLocation = searchResults.searchLocation
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
        print("Cell..",indexPath.row)
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
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "cell2.jpg")!)
        
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
    func processResponse(data:NSData) {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
            //print(json)
            let items = json["results"] as? [[String: AnyObject]]
            
            for item in items!
            {
                if let name = item["name"] as? String
                {
                    searchResults.nameArray.addObject(name)
                    print("Name:: ", name)
                }
                
                if let vicinity = item["vicinity"] as? String
                {
                    searchResults.vicinityArray.addObject(vicinity)
                    print("Vicinity:: ",vicinity)
                } else {
                    searchResults.vicinityArray.addObject("")
                }
                var photo_ref = ""
                if(item["photos"] != nil){
                    let photosArray = item["photos"] as! NSArray
                    if(photosArray.firstObject != nil){
                        if(item["photos"]![0]!["photo_reference"] != nil){
                            photo_ref = item["photos"]![0]!["photo_reference"] as! String
                        }
                    }
                }
                searchResults.photoArray.addObject(photo_ref)
                let storeCoodinate = item["geometry"]!["location"] as! [String: AnyObject]
                let lat = storeCoodinate["lat"]
                let lng = storeCoodinate["lng"]
                searchResults.latArray.addObject(lat!)
                searchResults.lngArray.addObject(lng!)
                
                let userLocation : CLLocation = CLLocation(latitude: myLocation.latitude , longitude: myLocation.longitude)
                let priceLocation:CLLocation = CLLocation(latitude: (lat?.doubleValue)!, longitude: (lng?.doubleValue)!)
                let meters : CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
                
                print("Distancein meters:: ",meters)
                let meterStr = String(roundToTen(meters)) + " m"
                searchResults.distanceArray.addObject(meterStr)
                
                let open_now = 0
                let opening_hours = item["opening_hours"]
                if (opening_hours != nil){
                    var open_now = opening_hours!["open_now"]
                }
                print("open_now:: ",item["open_now"])
                searchResults.isOpenArray.addObject((open_now))
            }
            NSNotificationCenter.defaultCenter().postNotificationName("switchResultNotification", object: nil)
        }
        catch let error as NSError
        {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
    }
    
    func roundToTen(x : Double) -> Int{
        return 10 * Int(round(x/10.0))
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
}

