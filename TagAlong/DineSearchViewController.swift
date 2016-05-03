//
//  DineSearchViewController.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import CoreLocation

class DineSearchViewController: UIViewController , CLLocationManagerDelegate,NSURLSessionDataDelegate{
    
    var buffer:NSMutableData!;
    var locationManager :CLLocationManager!
    var myLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 103.7352615, longitude: 103.7352615)
    var searchResults = SearchResults()
    
    @IBOutlet weak var location : UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.location?.coordinate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchRest(){
        
        let address = location.text
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarkes : [CLPlacemark]?, error : NSError?) -> Void in
            if(address != "" && error != nil) {
                let alert =  UIAlertController(title: "Location Not Found!", message: "Please enter another address", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default){ (action:UIAlertAction) in
                    
                }
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            } else if let placemark = placemarkes?[0]{
                self.searchResults.searchLocation = self.location.text!
                self.myLocation = placemark.location!.coordinate
                //self.annotateMap(placemark.location!.coordinate)
            }
            
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
        })
    }

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        print ("URLSession:dataTask:didReceiveData")
        buffer.appendData(data)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if (error == nil) {
            print ("Done with bytes " + String(buffer.length))
            self.processResponse(buffer);

            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("dineSearchNavController") as! UINavigationController
            
            
            let toViewController1:MasterViewController =
                vc.topViewController as! MasterViewController
            
            toViewController1.searchResults = self.searchResults;
            toViewController1.myLocation = myLocation
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else {
            print("Error %@",error!.userInfo);
            print("Error description %@", error!.localizedDescription);
            print("Error domain %@", error!.domain);
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let masterViewController = segue.destinationViewController as! MasterViewController
        masterViewController.searchResults = self.searchResults
        masterViewController.myLocation = myLocation
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
                    if(item["photos"]![0] != nil){
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations : [CLLocation]){
        print("LocationUpdate....")
        let lastLocation = locations.last
        myLocation = lastLocation!.coordinate
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error : NSError) {
        print("Could not locate the location : \(error)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
