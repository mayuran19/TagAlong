//
//  HotelSearchViewController.swift
//  TagAlong
//
//  Created by Mayuran Satchi on 9/5/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import UIKit
import CoreLocation

class HotelSearchViewController : UIViewController, CLLocationManagerDelegate, UITextFieldDelegate{
    var locationManager :CLLocationManager!
    var currentLocation :CLLocation!
    
    var currentActiveTextField: UITextField!

    
    //Outlet variables
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var checkinTextField: UITextField!
    @IBOutlet weak var checkoutTextField: UITextField!
    @IBOutlet weak var guestTextField: UITextField!
    @IBOutlet weak var roomsTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundmain.png")!)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.location?.coordinate
        
        //Date delegates
        checkinTextField.delegate = self
        checkoutTextField.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var location = LocationManager.getLocationByName(locationTextField.text!)
        if (location == nil) {
            location = currentLocation
        }
        print(location)
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        let datePicker = UIDatePicker()
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HotelSearchViewController.doneDateSelection(_:)))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HotelSearchViewController.calcelDateSelection(_:)))
        toolBar.setItems([cancelButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true

        textField.inputAccessoryView = toolBar
        
        datePicker.datePickerMode = .Date
        if(textField == checkinTextField){
            currentActiveTextField = checkinTextField
            checkinTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(HotelSearchViewController.checkinDateChanged(_:)), forControlEvents: .ValueChanged)
        }else if(textField == checkoutTextField){
            currentActiveTextField = checkoutTextField
            checkoutTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(HotelSearchViewController.checkoutDateChanged(_:)), forControlEvents: .ValueChanged)
        }
       
    }
    
    func doneDateSelection(sender: AnyObject){
        currentActiveTextField.resignFirstResponder()
    }
    
    func calcelDateSelection(sender: AnyObject){
        currentActiveTextField.text = ""
        currentActiveTextField.resignFirstResponder()
    }
    
    func checkinDateChanged(sender: UIDatePicker){
        let formater = NSDateFormatter()
        formater.dateStyle = .MediumStyle
        checkinTextField.text = formater.stringFromDate(sender.date)
    }
    
    func checkoutDateChanged(sender: UIDatePicker){
        let formater = NSDateFormatter()
        formater.dateStyle = .MediumStyle
        checkoutTextField.text = formater.stringFromDate(sender.date)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations : [CLLocation]){
        print("LocationUpdate....")
        let lastLocation = locations.last
        currentLocation = lastLocation!
        locationManager.stopUpdatingLocation()
    }
    
    private func validateLocation(){
        
    }
}
