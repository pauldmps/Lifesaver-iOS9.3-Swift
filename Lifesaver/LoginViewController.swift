//
//  RegisterViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 11/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let prefsEmail = prefs.stringForKey("email")
        let prefsToken = prefs.stringForKey("token")
        if(prefsEmail != nil && prefsToken != nil){
            self.performSegueWithIdentifier("LoginToMainScreenSegue", sender: self)
        }
        
    }

    @IBAction func onLoginClicked(sender: UIButton) {
        
        var email:NSString = ""
        var password:NSString = ""
        
        if(self.email != nil && self.password != nil){
            email = self.email.text!
            password = self.password.text!
            if(email.isEqualToString("")||password.isEqualToString("")){
                showAlert("Please enter a valid email and password")
            }
            else {
                performLoginWithEmail(email,password: password)
            }
        }
        else {
            showAlert("Please enter email and password")
        }

    }
    
    func showAlert(message:String){
        
        let alertController = UIAlertController(title: "Sign in Failed!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
   
    }
    
    
    func performLoginWithEmail(email: NSString, password: NSString){
        let url = "https://lifesaver-paulshantanu.rhcloud.com/signin"
        let dataToSend = NSMutableDictionary()
        
        dataToSend.setValue(email, forKey: "email")
        dataToSend.setValue(password, forKey: "password")
        
        
        APIConnectionController(url: url, requestMethod: "POST", dataToSend: dataToSend).getDataFromAPI({(response:APIResponseObject)->Void in
            if response.responseCode == 200 {
                self.saveLoginToken(response.responseData)
            }
            else if response.responseCode == 401 {
                self.showAlert("Please enter a valid email and password")
            }
            else{
                self.showAlert("An unknown error occurred while trying to log in: \(response.responseCode)")
            }
            
        
        })
    }
    
    
    func saveLoginToken(loginData: NSData?){
        var jsonData: NSDictionary?
        do{
          jsonData = try NSJSONSerialization.JSONObjectWithData(loginData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        }catch let error as NSError {
            NSLog("\(error)")
            showAlert("An unknown error occurred while trying to log in")
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let prefsEmail = jsonData!["email"] as? String{
           // NSLog(prefsEmail)
            
           defaults.setObject(prefsEmail, forKey: "email")
        }
        
        if let prefsToken = jsonData!["token"] as? String{
           // NSLog(prefsToken)
           defaults.setObject(prefsToken, forKey: "token")
        }
        
        if(defaults.synchronize()){
            self.performSegueWithIdentifier("LoginToMainScreenSegue", sender: self)

        }
    }
   
    @IBAction func onSignupClicked(sender: UIButton) {
        
        self.performSegueWithIdentifier("LoginToRegisterScreenSegue", sender: self)
    }
}
