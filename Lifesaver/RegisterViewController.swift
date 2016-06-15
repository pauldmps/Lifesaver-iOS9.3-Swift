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
    
    
    override func viewDidAppear(animated: Bool) {
        
        //bloodTypePicker.addSubview(UIBloodTypePicker())
        
        bloodTypePickerView.bloodTypePicker.dataSource = self
        bloodTypePickerView.bloodTypePicker.delegate = self
        bloodTypePickerView.doneButton.target = self
        bloodTypePickerView.doneButton.action = #selector(self.onDoneClicked(_:))
        
        bloodTypePickerView.hidden = true
        
    
    }
    
    func onDoneClicked(){
        //TODO
        bloodTypePickerView.hidden = true

    }
    
    
    
    @IBAction func onBloodTypeClicked(sender: UIButton) {
        bloodTypePickerView.hidden = false
        }
        
    
    
    /*func showPicker(willShow:Bool){
        let transform = willShow ? CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.customPicker.frame)):CGAffineTransformIdentity
        
        UIView.animateWithDuration(0.3, animations: {self.customPicker.transform = transform})
    } */
    
    
    @IBAction func onRegisterClicked(sender: AnyObject) {
    
    }
    

    
    @IBAction func onDoneClicked(sender: UIBarButtonItem) {

    }
    
    
    
    let pickerData = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    
    
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
        //TODO
    }

    
    
    
    
}