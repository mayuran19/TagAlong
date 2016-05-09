//
//  CustomTableCell.swift
//  HotelsDisplayCA
//
//  Created by Jain, Ankur on 5/2/16.
//  Copyright © 2016 sg.edu.nus.iss.wlad. All rights reserved.
//

import Foundation
import UIKit

class CustomTableCell: UITableViewCell {
    
    @IBOutlet var hotelName : UILabel!
    @IBOutlet var hoteldistance : UILabel!
    @IBOutlet weak var hotelImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}