//
//  TblItem.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class TblItem: BaseModelSwift {
    var image:String?
    var image2:String?
    
    var title:String?
    var phone:String?
    var lat:String?
    var lng:String?
    var location:String?
    var include:String?
    var ddescription:String?
    
    var schedule = [TblTime]()
    
    init(dictionary:[String:Any]?){
        super.init()
        
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
            if let val = dict["description"] as? String {
                self.ddescription = val
            }
            
            if let array = dict["schedule"] as? [AnyObject] {
                schedule = [TblTime]()
                for i in 0..<array.count {
                    if let idict = array[i] as? [String:Any] {
                        let ival = TblTime.init(dictionary: idict)
                        schedule.append(ival)
                    }
                }
            }
        }
    }
    required init(){
        
    }
}
