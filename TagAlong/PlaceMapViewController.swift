//
//  PlaceMapViewController.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 7/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceMapViewController : UIViewController{
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var myHomeLocation: CLLocationCoordinate2D?
    var restLocation: CLLocationCoordinate2D?
    var myHomePin = MKPointAnnotation()
    var restPin = MKPointAnnotation()
    var placeName : String?
    var searchLocation : String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        let latDelta : CLLocationDegrees = 0.02
        let longDelta : CLLocationDegrees = 0.02
        
        placeLabel.text = placeName
        let theSpan:MKCoordinateSpan =
            MKCoordinateSpanMake(latDelta, longDelta)
        let myLocation : CLLocationCoordinate2D = myHomeLocation!
        let theRegion : MKCoordinateRegion = MKCoordinateRegionMake(myLocation, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        self.mapView.mapType = MKMapType.Standard
        self.mapView.zoomEnabled = true
        
        myHomePin.coordinate = myHomeLocation!
        if (searchLocation == "Current"){
            myHomePin.title = "You are Here"
        } else {
            myHomePin.title = searchLocation
        }
        self.mapView.addAnnotation(myHomePin)
        
        restPin.coordinate = restLocation!
        restPin.title = placeName
        self.mapView.addAnnotation(restPin)
    }
}