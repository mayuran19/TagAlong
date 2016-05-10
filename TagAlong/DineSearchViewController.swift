//
//  DineSearchViewController.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import CoreLocation

class DineSearchViewController: UIViewController , CLLocationManagerDelegate{
    
    
    var locationManager :CLLocationManager!
    var myLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 103.7352615, longitude: 103.7352615)
    var searchResults = SearchResults()
    
    @IBOutlet weak var location : UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
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
            
            
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let masterViewController = segue.destinationViewController as! MasterViewController
        masterViewController.myLocation = myLocation
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
