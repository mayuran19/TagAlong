//
//  LoginViewController.swift
//  PT_4SwiftProject
//
//  Created by Mayuran Satchi on 1/5/16.
//  Copyright © 2016 sg.edu.nus.iss.wlad. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        loginButton.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        if(FBSDKAccessToken.currentAccessToken() != nil){
            performSegueWithIdentifier("toProfile", sender: self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillApper")
        print(self.view)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        if(error == nil){
//            if(result.token != nil){
//                FBSDKAccessToken.setCurrentAccessToken(result.token)
//                let profileController = ProfileViewController()
//                self.presentViewController(profileController, animated: true, completion: nil)
//            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool{        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
