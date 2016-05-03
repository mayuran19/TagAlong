//
//  StayDineSeeDo.swift
//  PT_4SwiftProject
//
//  Created by William Selamat Djingga on 25/4/16.
//  Copyright © 2016 sg.edu.nus.iss.wlad. All rights reserved.
//

import Foundation
import UIKit

class StayDineSeeDo: UIViewController {
    
    
    @IBAction func stayAction(sender: AnyObject) {
        printMessage("Stay")
    }
    
    @IBAction func dineAction(sender: AnyObject) {
        printMessage("Dine")
    }

    @IBAction func seeDoAction(sender: AnyObject) {
        printMessage("SeeDo")
    }
    
    
    func printMessage (name:String)
    {
        let alertPopUp:UIAlertController = UIAlertController(title: "Alert", message: name, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel){action -> Void in}
        alertPopUp.addAction(cancelAction)
        self.presentViewController(alertPopUp, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}