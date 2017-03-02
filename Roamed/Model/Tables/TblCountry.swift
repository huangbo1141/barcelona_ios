//
//  TblCountry.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class TblCountry:BaseModelSwift{
    var iso:String?
    var country:String?
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            
        }
    }
    required init(){
        
    }
}
