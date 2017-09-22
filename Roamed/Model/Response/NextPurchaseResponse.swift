//
//  NextPurchaseResponse.swift
//  Roamed
//
//  Created by BoHuang on 9/1/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class NextPurchaseResponse: BaseModelSwift {
    var status:String?
    var message:String?
    var next_purchase:String?
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
        }
    }
    required init(){
        
    }
}
