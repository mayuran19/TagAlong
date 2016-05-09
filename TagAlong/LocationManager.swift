//
//  LocationManager.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 9/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager{
    
    static func getLocationByName(locationName : String) -> CLLocation?{
        let geoCoder = CLGeocoder()
        var clLocation : CLLocation?
        geoCoder.geocodeAddressString(locationName) { (placeMarks, error) in
            if error == nil{
                if let firstPlaceMark = placeMarks?[0]{
                    clLocation = firstPlaceMark.location
                }
            }
        }
        
        return clLocation
    }
}