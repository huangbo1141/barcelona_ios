//
//  RequestLogin.swift
//  Roamed
//
//  Created by BoHuang on 2/20/17.
//  Copyright © 2017 SIMPSY LLP. All rights reserved.
//

import Foundation

class RequestLogin:BaseModelSwift{
    var key:String?
    var secret:String?
    var phone:String?
    var country:String?
    var name:String?
    var userid:String?
    var purchase_id:String?
    var divert_phone:String?
    var country_iso:String?
    var next:String?
    var current_purchase:String?
    
    var iso:String?
    var days:String?
    var startdate:String?
    var timezone:String?
    var time:String?
    var device_token:String?
    
    func setDefaultkeySecret(){
        key = "abc123"
        secret = "123abc"
    }
}
