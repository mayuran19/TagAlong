//
//  SeeAndDoTableViewController.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 4/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SeeAndDoTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate,NSURLSessionDataDelegate{
    //variable to hold the data from previous scene
    var selectedType:Int!
    
    //Variable to hold the data returned by restapi call
    var buffer:NSMutableData!
    
    //Variable to store the data from JSON
    var searchResult = SeeAndDoSearchResult()
    
    //variable to hold the current location
    var currentLocation : CLLocationCoordinate2D!
    
    //location manager
    var locationManager :CLLocationManager!
    
    //Table view to hold the restapi resutls
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //location manager initialization
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.location?.coordinate
        
        //Tableview & Datasource
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchPlaces(){
        self.buffer = NSMutableData();
        var urlString : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
        urlString += String(currentLocation.latitude)
        urlString += ","
        urlString += String(currentLocation.longitude)
        var type  = ""
        if(selectedType == 0){
            type = "natural_feature"
        }else if(selectedType == 1){
            type = "church|hindu_temple|mosque"
        }else if(selectedType == 2){
            type = "clothing_store|electronics_store|grocery_or_supermarket|hardware_store|home_goods_store|jewelry_store|shopping_mall"
        }else if(selectedType == 3){
            type = "stadium"
        }else{
            type = ""
        }
        if(type == ""){
            urlString += "&radius=50000&key=AIzaSyAFs50MVWIeNs2PA8nYILqqn-eO7fys8G4"
        }else{
            urlString += "&radius=50000&types=\(type)&key=AIzaSyAFs50MVWIeNs2PA8nYILqqn-eO7fys8G4"
        }
        
        let urlStr = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let url:NSURL = NSURL(string: urlStr!)!
        print(url)
        
        let defaultConfigObject:NSURLSessionConfiguration =
            NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: self, delegateQueue: NSOperationQueue.mainQueue());
        
        //The download task with completion handler
        let downloadTask = session.dataTaskWithURL(url){
            (data, response, error) in
            if(error == nil){
                print ("data received")
                self.buffer.appendData(data!)
                self.processResponse(self.buffer)
                self.tableView.reloadData()
            }
        }
        
        //fire the request
        downloadTask.resume()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResult.nameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //print("Cell..",indexPath.row)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlacesTableViewCell
        
        cell.placeName.text = searchResult.nameArray[indexPath.row] as? String
        //print(searchResults.photoArray[indexPath.row])
        if(searchResult.photoArray[indexPath.row] as! String != ""){
            var imageURL = "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyAFs50MVWIeNs2PA8nYILqqn-eO7fys8G4&photoreference="
            imageURL += searchResult.photoArray[indexPath.row] as! String;
            imageURL += "&maxwidth=75"
            let url = NSURL(string : imageURL)
            let data = NSData(contentsOfURL: url!)
            cell.placeImage.image = UIImage(data : data!)
        } else {
            cell.placeImage.image = UIImage(named: "dine")!
        }
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        
        //let object = names[indexPath.row] as! NSString
        //cell.textLabel!.text = searchResults.nameArray[indexPath.row] as! String
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations : [CLLocation]){
        print("LocationUpdate....")
        let lastLocation = locations.last
        currentLocation = lastLocation!.coordinate
        locationManager.stopUpdatingLocation()
        
        
        //search for places
        searchPlaces()
    }
    
    func processResponse(data:NSData) {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
            //print(json)
            let items = json["results"] as? [[String: AnyObject]]
            
            for item in items!
            {
                print("=============================")
                if let name = item["name"] as? String
                {
                    searchResult.nameArray.addObject(name)
                    print("Name:: ", name)
                }
                
                if let vicinity = item["vicinity"] as? String
                {
                    searchResult.vicinityArray.addObject(vicinity)
                    print("Vicinity:: ",vicinity)
                } else {
                    searchResult.vicinityArray.addObject("")
                }
                var photo_ref = ""
                if(item["photos"] != nil){
                    if(item["photos"]![0] != nil){
                        if(item["photos"]![0]!["photo_reference"] != nil){
                            photo_ref = item["photos"]![0]!["photo_reference"] as! String
                        }
                    }
                }
                searchResult.photoArray.addObject(photo_ref)
                let storeCoodinate = item["geometry"]!["location"] as! [String: AnyObject]
                let lat = storeCoodinate["lat"]
                let lng = storeCoodinate["lng"]
                searchResult.latArray.addObject(lat!)
                searchResult.lngArray.addObject(lng!)
                
                let userLocation : CLLocation = CLLocation(latitude: currentLocation.latitude , longitude: currentLocation.longitude)
                let priceLocation:CLLocation = CLLocation(latitude: (lat?.doubleValue)!, longitude: (lng?.doubleValue)!)
                let meters : CLLocationDistance = userLocation.distanceFromLocation(priceLocation)
                
                print("Distancein meters:: ",meters)
                let meterStr = String(roundToTen(meters)) + " m"
                searchResult.distanceArray.addObject(meterStr)
                
                let open_now = 0
                let opening_hours = item["opening_hours"]
                if (opening_hours != nil){
                    var open_now = opening_hours!["open_now"]
                }
                print("open_now:: ",item["open_now"])
                searchResult.isOpenArray.addObject((open_now))
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let detailController = segue.destinationViewController as! PlaceMapViewController
            detailController.myHomeLocation = currentLocation
            detailController.restLocation = CLLocationCoordinate2D(latitude: searchResult.latArray[indexPath.row] as! Double, longitude: searchResult.lngArray[indexPath.row] as! Double)
            detailController.searchLocation = searchResult.searchLocation
        }
    }
}
