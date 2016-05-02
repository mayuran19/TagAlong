//
//  SearchResults.swift
//  RestSearch
//
//  Created by Mugu Kumar on 30/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import Foundation

class SearchResults {
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