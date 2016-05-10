//
//  HotelListTableViewController.swift
//  HotelsDisplayCA
//
//  Created by Jain, Ankur on 5/2/16.
//  Copyright © 2016 sg.edu.nus.iss.wlad. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
class HotelListTableViewController : UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    //variables from previous scene
    var buffer:NSMutableData!
    var locationManager :CLLocationManager!
    var location :CLLocation!
    var checkinDate :String!
    var checkoutDate :String!
    var guests :String!
    var rooms :String!
    
    @IBOutlet weak var tableView: UITableView!
    var myLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 103.7352615, longitude: 103.7352615)
    var searchResults = HotelSearchResult()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return searchResults.hotelNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomTableCell
        
        cell.hotelName.text = searchResults.hotelNames[indexPath.row] as? String
        let imageURL = searchResults.imageURLS[indexPath.row]
        let url=NSURL(string:imageURL as! String)
        let data=NSData(contentsOfURL: url!)
        if(data != nil){
            cell.hotelImage.image=UIImage(data: data!)
        }
        cell.hoteldistance.text="10"
        cell.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        return cell
    }
    
    func search() {
        buffer=NSMutableData();
        let url:NSURL = NSURL(string: "http://partners.api.skyscanner.net/apiservices/hotels/autosuggest/v2/SG/SGD/en-US/pari?apikey=prtl6749387986743898559646983194")!
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        let defaultConfigObject:NSURLSessionConfiguration =
            NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithRequest(request){
            (data, response, error) in
            if(error == nil){
                self.buffer.appendData(data!)
                self.processResponse(self.buffer);
            }else{
                print(error)
            }
        }
        task.resume();
        
    }
    
    func processResponse(data:NSData) {
        
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
            let results = json["results"] as? [[String:AnyObject]]
            for result in results!
            {
                if let entityId = result["individual_id"] as? String{
                    searchResults.resultsForEntityId.addObject(entityId);
                }
                
            }
            let url:NSURL = NSURL(string: "http://partners.api.skyscanner.net/apiservices/hotels/liveprices/v2/SG/SGD/en-US/27539733/\(checkinDate)/\(checkoutDate)/\(guests)/\(rooms)?apiKey=prtl6749387986743898559646983194")!
            let request = NSMutableURLRequest(URL:url)
            request.HTTPMethod="GET"
            request.setValue("application/json", forHTTPHeaderField: "accept")
            let defaultConfigObject:NSURLSessionConfiguration =
                NSURLSessionConfiguration.defaultSessionConfiguration();
            let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
            let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
                print ("URLSession:dataTask:didReceiveData")
                print("Executing Create Session Details")
                self.buffer.appendData(data!)
                print ("Done with bytes " + String(self.buffer.length))
                self.pollingSessionDetails(response!.URL!);
            });
            task.resume();
        }
        catch let error as NSError
        {
            print ("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func pollingSessionDetails(url:NSURL){
        let request = NSMutableURLRequest(URL:url)
        request.HTTPMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        let defaultConfigObject:NSURLSessionConfiguration =
            NSURLSessionConfiguration.defaultSessionConfiguration();
        let session:NSURLSession = NSURLSession(configuration: defaultConfigObject, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            print ("URLSession:dataTask:didReceiveData")
            self.buffer.appendData(data!)
            print("After polling session details Response Header For next method is : \(response?.URL)")
            print("The data received is: \(data)")
            self.createDetails(data!)
        });
        task.resume();
    }
    
    func createDetails(data:NSData){
        print("calling createDetails")
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
            
            print("JSON is: \(json)")
            let hotels = json["hotels"] as! [[String: AnyObject!]]
            for hotel in hotels {
                if let hotel_name = hotel["name"] as? String{
                    searchResults.hotelNames.addObject(hotel_name)
                }
            }
            let agents = json["agents"] as! [[String:AnyObject!]]
            for agent in agents {
                if let image_url=agent["image_url"] as? String{
                    searchResults.imageURLS.addObject(image_url)
                }
            }
            
            tableView.reloadData()
        }
        catch let error as NSError
        {
            print ("Failed to load: \(error.localizedDescription)")
        }
    }
}