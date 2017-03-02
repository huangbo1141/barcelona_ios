//
//  ItinResponse.swift
//  DragTest
//
//  Created by BoHuang on 1/11/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation

class LoginResponse:BaseModelSwift{
    
    var status:String?
    var message:String?
    var userid:String?
    var verification_code:String?
    var phone:String?
    var country_iso:String?
    var country:String?

    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            
        }
    }
    func isSuccess()->Bool{
        if let status = status, status == "success" {
            return true
        }
        return false
    }
    required init(){
        
    }
}
