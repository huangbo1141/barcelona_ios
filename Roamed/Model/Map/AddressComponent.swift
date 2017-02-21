//
//  AddressComponent.swift
//  TravPholer
//
//  Created by BoHuang on 12/8/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
class AddressComponent1:BaseModelSwift{
    var long_name:String?
    var short_name:String?
    var types:[String]?
    
    init(dictionary:[String:Any]){
        super.init()
        BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
    }
    
    required init(){
        
    }
}
