//
//  NearbyDetailController.swift
//  TagAlong
//
//  Created by William Selamat Djingga on 7/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NearbyDetailController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var latitude : Double = 0.0
    var longtitude : Double = 0.0
    var myPin = MKPointAnnotation()
    var companionPin = MKPointAnnotation()
    
    var companion: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameLabel.text = companion.name
        latitude = companion.latitude
        longtitude = companion.longtitude
        
        navigationItem.title = companion.name
        
        let latDelta:CLLocationDegrees = 0.01
        let longDelta:CLLocationDegrees = 0.01
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1.291, longitude: 103.7763)
        let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        self.mapView.mapType = MKMapType.Standard
        
        companionPin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        companionPin.title = companion.name
        myPin.coordinate = CLLocationCoordinate2D(latitude: 1.291, longitude: 103.7763)
        myPin.title = "Me"
        self.mapView.addAnnotation(companionPin)
        self.mapView.addAnnotation(myPin)
        mapView.selectAnnotation(mapView.annotations[0], animated: true)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func sendInvitation(sender: AnyObject) {
    }
    
}
