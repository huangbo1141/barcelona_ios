//
//  TblPurchaseDetail.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation

class TblPurchaseDetail:BaseModelSwift{
    //"id":"35","country_iso":"my","minutes_left":"192","days_left":"4","country":"Malaysia","divert_number":"A Malaysia number has not been assigned to you yet. It will only be assigned 24 hours before your tr
    var id:String?
    var country_iso:String?
    var minutes_left:String?
    var days_left:String?
    var country:String?
    var divert_number:String?
    var divert_message:String?
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            
        }
    }
    required init(){
        
    }
}
