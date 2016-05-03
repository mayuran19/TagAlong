//
//  CompanionSearchViewController.swift
//  TagAlong
//
//  Created by Mugu Kumar on 1/5/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CompanionSearchViewController: UIViewController {
    
    @IBOutlet weak var mapView : MKMapView!
    
    var companions = CompanionList().companions

    override func viewDidLoad() {
        print("viewDidLoad")
        let regionCoodinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1.341, longitude: 103.734)
        let latDelta : CLLocationDegrees = 0.02
        let longDelta : CLLocationDegrees = 0.02
        
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //let myLocation : CLLocationCoordinate2D = newCoodinate
        let theRegion : MKCoordinateRegion = MKCoordinateRegionMake(regionCoodinate, theSpan)
        self.mapView.setRegion(theRegion, animated: true)
        self.mapView.mapType = MKMapType.Standard
        for (name, user) in companions {
            print(name)
            annotateMap(user)
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func annotateMap(user : User){
        let coodinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longtitude)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coodinate
        pin.title = user.name
        self.mapView.addAnnotation(pin)
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
