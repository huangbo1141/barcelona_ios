//
//  PurchaseResponse.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class PurchaseResponse:BaseModelSwift{
    
    var present_purchase:[PresentPurchase]?
    var past_purchase:[PastPurchase]?
    
    init(dictionary:[String:Any]?){
        super.init()
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
            
            if let obj = dict["present_purchase"]{
                present_purchase = [PresentPurchase]()
                for item in obj as! [AnyObject] {
                    if let item = item as? [AnyHashable:Any]{
                        let data = PresentPurchase()
                        BaseModel.parseResponse(data, dict: item)
                        present_purchase?.append(data);
                    }
                    
                }
            }
        }
    }
    required init(){
        
    }
}
