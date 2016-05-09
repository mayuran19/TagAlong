//
//  HotelSearchResult.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 10/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import Foundation

class HotelSearchResult{
    var hotelNames = NSMutableArray()
    var imageURLS = NSMutableArray()
    var resultsForEntityId = NSMutableArray()
    var distances = NSMutableArray()
    
    init(){
        hotelNames = []
        imageURLS = []
        resultsForEntityId = []
        distances = []
    }
}