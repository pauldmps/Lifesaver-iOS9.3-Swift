//
//  RegisterViewController.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 13/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit

class RegisterViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{


    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var bloodTypePicker: UIPickerView!

    @IBOutlet var customPicker: UIView!
    
    let pickerData = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
    
    
    @IBAction func onBloodTypeClicked(sender: UIButton) {
        
        
        if let customPicker = NSBundle.mainBundle().loadNibNamed("UIBloodTypePicker", owner: self, options:nil).first as? RegisterViewController{
        
        
        self.bloodTypePicker.dataSource = self
        self.bloodTypePicker.delegate = self
        
        self.customPicker.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.customPicker.frame), CGRectGetHeight(self.customPicker.frame))
        
        self.view.addSubview(self.customPicker)
            
        showPicker(true)

        }
        
    }
    
    func showPicker(willShow:Bool){
        let transform = willShow ? CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.customPicker.frame)):CGAffineTransformIdentity
        
        UIView.animateWithDuration(0.3, animations: {self.customPicker.transform = transform})
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
        //TODO
    }
    
    @IBAction func onDoneClicked(sender: UIBarButtonItem) {
        showPicker(false)
    }
    
    
    
    
    
    
}