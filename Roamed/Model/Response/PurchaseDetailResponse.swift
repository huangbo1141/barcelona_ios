//
//  PurchaseDetailResponse.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
//
//  PurchaseResponse.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class PurchaseDetailResponse:BaseModelSwift{
    
    var present_purchase:[TblPurchaseDetail]?
    
    init(dictionary:[String:Any]?){
        super.init()
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            if let obj = dict["present_purchase"] as? [String:AnyObject]{
                present_purchase = [TblPurchaseDetail]()
                
                for (key,value) in obj {
                    if let item = value as? [String:AnyObject]{
                        
                        let data = TblPurchaseDetail.init(dictionary: item)
                        
                        
                        present_purchase?.append(data);
                    }
                    
                }
            }
        }
    }
    required init(){
        
    }
}
