//
//  User.swift
//  Lifesaver
//
//  Created by Shantanu Paul on 25/06/16.
//  Copyright © 2016 Shantanu Paul. All rights reserved.
//

import Foundation

class User{

    var name:NSString!
    var address:NSString!
    var bloodType:NSString!
    var distance:NSString!
    var contactNumber:NSString!
    var email:NSString!
    
    init(name:NSString, address:NSString, bloodType:NSString, distance:NSString){
        self.name = name
        self.address = address
        self.bloodType = bloodType
        self.distance = distance
    }
}