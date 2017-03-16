//
//  PurchaseResponse.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class CallResponse:BaseModelSwift{
    
    var calls:[CallModel]?

    init(dictionary:[String:Any]?){
        super.init()
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            if let obj = dict["calls"] as? [String:AnyObject]{
                calls = [CallModel]()
                
                for (key,value) in obj {
                    if let item = value as? [AnyHashable:Any]{
                        
                        let data = CallModel(context:context)
                        BaseModel.parseResponse(data, dict: item)
                        data.sortid = key
                        calls?.append(data);
                    }
                }
                calls?.sort(by: { (first, second) -> Bool in
                    if let id1 = Int(first.sortid!),let id2=Int(second.sortid!){
                        return id1 < id2;
                    }
                    return true;
                })
                
            }
        }
    }
    required init(){
        
    }
}
