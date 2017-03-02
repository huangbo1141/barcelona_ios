//
//  CountryResponse.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class CountryResponse:BaseModelSwift{
    
    var countries:[TblCountry]?
    
    init(dictionary:[String:Any]?){
        super.init()
        if let dict = dictionary {
            BaseModelSwift.parseResponse(targetClass: self, dict: dict)
            
            countries = [TblCountry]()
            for (key,value) in dict {
                if let item = value as? [String:Any]{
                    let data = TblCountry.init(dictionary: item)
                    
                    countries?.append(data);
                }
                
            }
        }
    }
    required init(){
        
    }
}
