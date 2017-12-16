//
//  TblTime.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class TblTime: BaseModelSwift {
    
    var title:String?
    var start:String?
    var end:String?
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            
        }
    }
    required init(){
        
    }
}
