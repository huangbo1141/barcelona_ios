//
//  ClubResponse.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class ClubResponse: BaseModelSwift {
    var items:[TblItem] = [TblItem]()
    
    init(dictionary:[String:Any]?){
        super.init()
        if let dictionary = dictionary {
            if let dict = dictionary["data"] as? [String:Any] {
                items = [TblItem]()
                var model:TblItem?
                if let club = dict["club"] as? [String:Any]{
                    model = TblItem.init(dictionary: club)
                }
                
                if let model = model {
                    if let array = dict["schedule"] as? [AnyObject]{
                        for obj in array{
                            if let obj = obj as? [String:Any]{
                                let time = TblTime.init(dictionary: obj)
                                model.schedule.append(time)
                            }
                        }
                    }
                    items.append(model)
                }
            }
        }
    }
    required init(){
        
    }
}
