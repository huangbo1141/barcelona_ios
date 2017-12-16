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
            if let val = dict["ddescription"] as? String {
                self.ddescription = val
            }
        }
    }
    required init(){
        
    }
}
