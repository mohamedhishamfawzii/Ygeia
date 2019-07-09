//
//  User.swift
//  Ygeia
//
//  Created by mohamed hisham on 5/29/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import Foundation
import CoreLocation

class User : Codable {
    var name:String?
    var age:String?
    var bloodType:String?
    var weight:String?
    var height:String?
    var emergencyContact:String?
    var medicalCondition:String?
    var medicalNotes:String?
    var allergies:String?
    var medications:String?
   // var location : CLLocation?
    var hospitals :String?
    var generalNotes:String?
    //var userPhoto:[Data?]=[]
}
