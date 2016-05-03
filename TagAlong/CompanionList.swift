//
//  CompanionList.swift
//  TagAlong
//
//  Created by Mugu Kumar on 1/5/16.
//  Copyright © 2016 MK. All rights reserved.
//

import Foundation

class CompanionList {
    
    var companions = [String : User]()
    
    init(){
        let lat : Double = 1.341233
        let lng : Double = 103.734720
        let user1 = User(name: "Mugunthan", lat: lat + 0.0005, lng: lng + 0.0005)
        let user2 = User(name: "Mayuran", lat: lat + 0.0010, lng: lng + 0.0060)
        let user3 = User(name: "Ankur", lat: lat + 0.0015, lng: lng + 0.0015)
        let user4 = User(name: "Keerthi", lat: lat + 0.0020, lng: lng + 0.0035)
        let user5 = User(name: "William", lat: lat + 0.0095, lng: lng + 0.0025)
        
        self.companions[user1.name] = user1
        self.companions[user2.name] = user2
        self.companions[user3.name] = user3
        self.companions[user4.name] = user4
        self.companions[user5.name] = user5
        
    }
    
}
