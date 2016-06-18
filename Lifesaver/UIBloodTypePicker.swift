//
//  UIBloodTypePicker.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 15/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import UIKit


@IBDesignable class UIBloodTypePicker: UIView{

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
    }
    
    func load(){
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let view = UINib(nibName: "UIBloodTypePicker", bundle: bundle).instantiateWithOwner(self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        addSubview(view)
        
        /*
        let customPicker = NSBundle.mainBundle().loadNibNamed("UIBloodTypePicker", owner: self, options: nil).first as! UIView
        
        customPicker.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        customPicker.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(customPicker) */
    
    }
    
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    
    
    
}