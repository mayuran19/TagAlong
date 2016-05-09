//
//  ProfileViewController.swift
//  Profile
//
//  Created by Mayuran Satchi on 23/4/16.
//  Copyright © 2016 Mayuran Satchi. All rights reserved.
//

import UIKit
import Social

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        cycleImageView()
        updateProfileDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func descYourselfValueChanged(sender: AnyObject) {
        let segCtl = sender as! UISegmentedControl
        print(segCtl.selectedSegmentIndex)
    }
    func updateProfileDetails(){
        let parameters = ["fields" : "email,first_name,last_name,picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{(connection, result, error) -> Void in
            if(error != nil){
                print("error")
                return
            }
            
            let firstName = result["first_name"] as? String
            let lastName = result["last_name"] as? String
            self.firstName.text = firstName
            self.lastName.text = lastName

            let imageURL = NSURL(string: result["picture"]!!["data"]!!["url"]!! as! String)
            let imagedData = NSData(contentsOfURL: imageURL!)!
            self.profileImageView?.image = UIImage(data: imagedData)
        }
    }
    
    func cycleImageView(){
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func faceBook(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbShare.addImage(UIImage(named: "Singapore.png"))
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func twitter(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.addImage(UIImage(named: "Singapore.png"))
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
