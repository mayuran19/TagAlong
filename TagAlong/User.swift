//
//  User.swift
//  TagAlong
//
//  Created by Mugu Kumar on 1/5/16.
//  Copyright © 2016 MK. All rights reserved.
//

import Foundation

class User {
    
     var name : String = ""
     var latitude : Double = 0.0
     var longtitude : Double = 0.0
    
    init(name : String, lat : Double, lng : Double){
        self.name = name
        self.latitude = lat
        self.longtitude = lng
    }
    
    class func getExistingCompanion() -> NSMutableArray{
        let companions = NSMutableArray()
        
        let lat : Double = 1.291
        let lng : Double = 103.7763
        companions.addObject(User(name: "Mugunthan", lat: lat + 0.0005, lng: lng + 0.0005))
        companions.addObject(User(name: "Mayuran", lat: lat + 0.0010, lng: lng + 0.0060))
        companions.addObject(User(name: "Ankur", lat: lat + 0.0015, lng: lng + 0.0015))
        companions.addObject(User(name: "Keerthi", lat: lat + 0.0020, lng: lng + 0.0005))
        companions.addObject(User(name: "William", lat: lat + 0.000, lng: lng + 0.0025))
        
        return companions
    }
}
