//
//  PurchaseResponse.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
import CoreData
class PurchaseResponse:BaseModelSwift{
    
    var present_purchase:[PresentPurchase]?
    var past_purchase:[PastPurchase]?
    
    init(dictionary:[String:Any]?){
        super.init()
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            
            if let obj = dict["present_purchase"] as? [String:AnyObject]{
                present_purchase = [PresentPurchase]()
                
                let fetch = NSFetchRequest<PresentPurchase>(entityName: "PresentPurchase")
                
                do {
                    let rows = try context.fetch(fetch)
                    for row in rows {
                        context.delete(row)
                    }
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                var values:[String:Any] = [String:Any]()
                var ids = [NSNumber]()
                for (key,value) in obj {
                    if let item = value as? [AnyHashable:Any]{
                        
                        let data = PresentPurchase(context:context)
                        BaseModel.parseResponse(data, dict: item)
//                        present_purchase?.append(data);
                        data.ordern = Double(key)!
                        values[key] = data
                        ids.append(NSNumber.init(value: Int(key)!))
                    }
                }
                 ids.sort(by: { (n1, n2) -> Bool in
                    let a = n1.intValue
                    let b = n2.intValue
                    if a<b {
                        return true
                    }
                    return false
                })
                for i in 0..<ids.count {
                    let key = String(ids[i].intValue)
                    if let value = values[key] as? PresentPurchase{
                        present_purchase?.append(value);
                    }
                    
                }
                
                delegate.saveContext()
            }
            if let obj = dict["past_purchase"] as? [String:AnyObject]{
                past_purchase = [PastPurchase]()
                
                let fetch = NSFetchRequest<PastPurchase>(entityName: "PastPurchase")
                
                do {
                    let rows = try context.fetch(fetch)
                    for row in rows {
                        context.delete(row)
                    }
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                for (key,value) in obj {
                    if let item = value as? [AnyHashable:Any]{
                        
                        let data = PastPurchase(context:context)
                        BaseModel.parseResponse(data, dict: item)
                        past_purchase?.append(data);
                    }
                }
                delegate.saveContext()
            }
        }
    }
    required init(){
        
    }
}
