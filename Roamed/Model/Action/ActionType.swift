//
//  ActionType.swift
//  TravPholer
//
//  Created by BoHuang on 12/11/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
class ActionType:BaseModelSwift{
    
    var actiontype:Action = .none
    var sourceView:UIView?
    var imageview:UIImageView?
    var cell:AnyObject?
    
    var dayIndex:Int?
    var indexPath:IndexPath?
    var mindex:Int?
    var link:URL?
    
    // selection part data
    var selectionData : [AnyObject]?
    var queueLabel:String?
    
    var paramData1:AnyObject?
    var paramData2:AnyObject?
    var paramData3:AnyObject?
    
    
    init(dictionary:[String:Any]){
        super.init()
        BaseModelSwift.parseResponse(targetClass: self, dict: dictionary)
    }
    
    required init(){
        
    }
    
    enum Action{
        case none
        case like
        case report
        case clickname
        case clicksharesocial
        case clicklink
        case clickcoment
        case bucket
        case clickpost
        case clickpicturedetail
        case clickclose
        case addcomment
        case editpost
        
        
        // itin actions
        case clickaddfromlist
        case clickaddmanually
        case addstory
        //case addstorymanual
        case clickdetail
        
        // select actions
        case selectday
        
        // trip next before
        case nextday
        case prevday
        case submit
        case reserveday
        case droppeditin
        
        // notification cell
        case clicknoticel
    }
}
