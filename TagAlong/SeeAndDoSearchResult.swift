//
//  SeeAndDoSearchResult.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 6/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation

class SeeAndDoSearchResult{
    var nameArray = NSMutableArray()
    var distanceArray = NSMutableArray()
    var vicinityArray = NSMutableArray()
    var isOpenArray = NSMutableArray()
    var latArray = NSMutableArray()
    var lngArray = NSMutableArray()
    var photoArray = NSMutableArray()
    var searchLocation = "Current"
    
    
    init(){
        nameArray = []
        distanceArray = []
        vicinityArray = []
        isOpenArray = []
        latArray = []
        lngArray = []
        photoArray = []
        
    }
}