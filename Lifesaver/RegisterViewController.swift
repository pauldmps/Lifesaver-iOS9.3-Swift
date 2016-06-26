//
//  RegisterViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 13/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit
import QuartzCore
import MapKit
import CoreLocation

class RegisterViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate{


    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var bloodTypePickerView: UIBloodTypePicker!
    
    @IBOutlet weak var bloodTypeChoiceButton: UIButton!
    
    let pickerData = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    var bloodType: String!
    var bloodTypeButtonLabel: NSMutableAttributedString!
    var latitude: Double!
    var longitude: Double!
    let locationManager = CLLocationManager()
    
    override func viewDidAppear(animated: Bool) {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(RegisterViewController.handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer) // dismiss keyboard when tapped outside the text field
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)  //dismiss the blood type chooser when keyboard is opened
        
        
        bloodTypePickerView.bloodTypePicker.dataSource = self
        bloodTypePickerView.bloodTypePicker.delegate = self
        bloodTypePickerView.doneButton.target = self
        bloodTypePickerView.doneButton.action = #selector(RegisterViewController.onDoneClicked)
        
        bloodTypePickerView.hidden = true
        
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        else{
            //TODO Divert to settings if location is not enabled
        }
    
    }
    
    func onDoneClicked(){
        bloodTypePickerView.hidden = true
        bloodTypeButtonLabel = NSMutableAttributedString(string: bloodType == nil ? "A+":bloodType)
        bloodTypeButtonLabel.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, bloodTypeButtonLabel.length))
        bloodTypeButtonLabel.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14.0), range: NSMakeRange(0, bloodTypeButtonLabel.length))
        bloodTypeChoiceButton.setAttributedTitle(bloodTypeButtonLabel, forState: UIControlState.Normal)
    }
    
    
    func handleSingleTap(){
        self.view.endEditing(true)
        bloodTypePickerView.hidden = true
    }
    
    
    @IBAction func onBloodTypeClicked(sender: UIButton) {
        self.view.endEditing(false)
        bloodTypePickerView.hidden = false
        }
    
    @IBAction func onRegisterClicked() {
        
        if(name == nil ||  name.text == "")
        {
            highlightField(name)
        }
        else if(email == nil || email.text == "")
        {
            highlightField(email)
        }
        else if(password == nil || password.text == "") //TODO password enforcement
        {
            highlightField(password)
        }
        else if(confirmPassword == nil || confirmPassword.text == "")
        {
            highlightField(confirmPassword)
        }
        else if(password.text != confirmPassword.text)
        {
            showAlert("Password and Confirm password do not match")
        }
        else
        {
            performRegistration()
        }
    
    }
    
    func highlightField(textField:UITextField){
        let temp = textField.placeholder
        textField.attributedPlaceholder = NSAttributedString(string: temp!, attributes: [NSForegroundColorAttributeName : UIColor.redColor()])
    }
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Registration Failed!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func performRegistration(){
        
        let url = "https://lifesaver-paulshantanu.rhcloud.com/register"
        let dataToSend = NSMutableDictionary()
        
        dataToSend.setValue(email.text, forKey: "email")
        dataToSend.setValue(password.text, forKey: "password")
        dataToSend.setValue(bloodType, forKey: "bloodGroup")
        dataToSend.setValue(name.text, forKey: "name")
        dataToSend.setValue(NSString.localizedStringWithFormat("%.20f",latitude), forKey: "latitude")
        dataToSend.setValue(NSString.localizedStringWithFormat("%.20f",longitude), forKey: "longitude")
        

        for(key,value) in dataToSend{
            NSLog("\(key)=\(value)")
        }
        
        APIConnectionController(url:url, requestMethod:"POST", dataToSend: dataToSend).getDataFromAPI({(response: APIResponseObject) -> Void in
            
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
            self.performSegueWithIdentifier("RegisterToMainScreenSegue", sender: self)
            
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bloodType = pickerData[row]
    }

    func keyboardWillShow(){
        bloodTypePickerView.hidden = true
    }
    
    
    
}