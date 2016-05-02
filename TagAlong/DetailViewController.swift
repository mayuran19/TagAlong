//
//  DetailViewController.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var name : UILabel!
    
    var myHomeLocation: CLLocationCoordinate2D?
    var restLocation: CLLocationCoordinate2D?
    var myHomePin = MKPointAnnotation()
    var restPin = MKPointAnnotation()
    var object : String?
    var searchLocation : String?

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        self.name.text = object
        let latDelta : CLLocationDegrees = 0.02
        let longDelta : CLLocationDegrees = 0.02
        
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
        restPin.title = self.name.text
        self.mapView.addAnnotation(restPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

