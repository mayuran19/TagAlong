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
}
