//
//  EnvVar.swift
//  TravPholer
//
//  Created by BoHuang on 12/2/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation

private let _sharedManager = EnvVarSwift()

class EnvVarSwift{
    class var sharedManager:EnvVarSwift {
        return _sharedManager;
    }
    public init(){
//        loadFromDefaults()
    }
    var username:String?
    var password:String?
    var token:String?
    var fbtoken:String?
    var email:String?
    var fbid:String?
    var lastLogin = -1
    var pushtoken:String?
    var first_name:String?
    var last_name:String?
    var country:String?
    var introviewed = -1
    
    
}
