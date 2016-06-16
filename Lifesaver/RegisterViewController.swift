//
//  RegisterViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 13/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{


    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var bloodTypePickerView: UIBloodTypePicker!
    
    @IBOutlet weak var bloodTypeChoiceButton: UIButton!
    
    let pickerData = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    var bloodType: String = "A+"
    
    override func viewDidAppear(animated: Bool) {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(RegisterViewController.handleSingleTap))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        bloodTypePickerView.bloodTypePicker.dataSource = self
        bloodTypePickerView.bloodTypePicker.delegate = self
        bloodTypePickerView.doneButton.target = self
        bloodTypePickerView.doneButton.action = #selector(RegisterViewController.onDoneClicked)
        
        bloodTypePickerView.hidden = true
        
    
    }
    
    func onDoneClicked(){
        bloodTypePickerView.hidden = true
        bloodTypeChoiceButton.setTitle(bloodType, forState: UIControlState.Normal)
    }
    
    
    func handleSingleTap(){
        self.view.endEditing(true)
        bloodTypePickerView.hidden = true
    }
    
    
    @IBAction func onBloodTypeClicked(sender: UIButton) {
        self.view.endEditing(false)
        bloodTypePickerView.hidden = false
        }
    
    @IBAction func onRegisterClicked(sender: AnyObject) {
    
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
        //bloodType = NSAttributedString(string: <#T##String#>, attributes: <#T##[String : AnyObject]?#>)
    }

    
    
    
    
}