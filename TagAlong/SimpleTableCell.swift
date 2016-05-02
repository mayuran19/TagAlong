//
//  SimpleTableCell.swift
//  Master-Detail Application
//
//  Created by Mugu Kumar on 28/4/16.
//  Copyright © 2016 MK. All rights reserved.
//

import UIKit

class SimpleTableCell: UITableViewCell {
    
    @IBOutlet var name : UILabel!
    @IBOutlet var address : UILabel!
    @IBOutlet var distance : UILabel!
    @IBOutlet var status : UILabel!
    @IBOutlet weak var thumpImage : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
