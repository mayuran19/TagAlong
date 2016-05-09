//
//  UIManager.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 9/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import UIKit

class UIManager{
    static func showAlert(title: String, message: String, controller: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        controller.presentViewController(alertController, animated: true, completion: nil)
    }
}