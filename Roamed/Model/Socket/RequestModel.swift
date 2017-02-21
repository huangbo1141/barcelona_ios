//
//  RequestModel.swift
//  TravPholer
//
//  Created by BoHuang on 1/24/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
class RequestModel:BaseModelSwift{
    
//    action

    var action:String?
    var tripid:String?
    var dayid:String?
    var storyid:String?
    var type:String?
    var content:AnyObject?
    var id1:String?
    var id2:String?
    var type1:String?
    var type2:String?
    var dayid1:String?
    var dayid2:String?
    var senderid:String?
    var reserve_id1:String?
    var reserve_type1:String?
    var reserve_dayid1:String?
    var reserve_storyid1:String?
    var reserve_storytype1:String?
    var roomaction:String?
    var logdata:String?
    var s1:String?
    var s2:String?
    var d1:String?
    var d2:String?
    
    
    init(dictionary:[String:Any]){
        super.init()
        BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
    }
    
    required init(){
        
    }
}
