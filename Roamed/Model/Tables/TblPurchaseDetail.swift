//
//  TblPurchaseDetail.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
import CoreData
class TblPurchaseDetail:BaseModelSwift{
    //"id":"35","country_iso":"my","minutes_left":"192","days_left":"4","country":"Malaysia","divert_number":"A Malaysia number has not been assigned to you yet. It will only be assigned 24 hours before your tr
    var id:String?
    var country_iso:String?
    var minutes_left:String?
    var days_left:String?
    var country:String?
    var divert_number:String?
    var divert_message:String?
    var divert_phone:String?
    var start_date:String?
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            // after get save it
            if let tblid = self.id {
                let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                
                let fetch = NSFetchRequest<PurchaseDetail>(entityName: "PurchaseDetail")
                fetch.predicate = NSPredicate.init(format: " id == '" + tblid + "'");
                delegate.saveContext()
                
                do {
                    let rows = try context.fetch(fetch)
                    for row in rows {
                        context.delete(row)
                    }
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                let data = PurchaseDetail(context:context)
                BaseModel.parseResponse(data, dict: dict)
                debugPrint(data.id)
                debugPrint(data.divert_message)
                
                delegate.saveContext()
            }
            
        }
    }
    required init(){
        
    }
}
