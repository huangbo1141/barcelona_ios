//
//  TblMakeItin.swift
//  TravPholer
//
//  Created by BoHuang on 1/19/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation

class TblMakeItin:BaseModelSwift{
    var itin_id:String?
    var itin_days:String?
    var itin_stories:String?
    var tp_status:String?
    var tp_id:String?
    
    var action:String?
    
    var tu_id:String?
    
    
    init(dictionary:[String:Any]){
        super.init()
        BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
    }
    
    required init(){
        
    }
}
