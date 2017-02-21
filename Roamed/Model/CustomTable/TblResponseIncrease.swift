//
//  TblResponseIncrease.swift
//  TravPholer
//
//  Created by q on 2/9/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class TblResponseIncrease:BaseModelSwift{
    var sql:String?
    
    
    init(dictionary:[String:Any]){
        super.init()
        BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
    }
    
    required init(){
        
    }
}
