//
//  BaseModelSwift.swift
//  TravPholer
//
//  Created by BoHuang on 11/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
import SocketIO
protocol PropertyNames {
    func propertyNames() -> [String]
    func propertyNamesFull() -> [String]
}

extension PropertyNames
{
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
    
    func propertyNamesFull() -> [String] {
//        let mirror = Mirror(reflecting: self).children;
//        
//        let reflected = reflect(self)
//        var members = [String: String]()
//        for index in 0..<reflected.count {
//            members[reflected[index].0] = reflected[index].1.summary
//        }
//        println(members)
        
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}

class BaseModelSwift:NSObject, PropertyNames,SocketData{
    var response:Int = 0;
    var mystring = ""
    
    func getMyString()->String{
        return mystring
    }
    
    func getQuestionDict()->[String:Any]{
        let ret = BaseModelSwift.getQuestionDict(targetClass: self)
        return ret
    }
    
    func getStoryType()->String{
        return "";
    }
    func getStoryId()->String?{
        return "";
    }
    static func parseResponse(targetClass:BaseModelSwift,dict:[String:Any]?){
        if let dict = dict {
            let properties = targetClass.propertyNames();
            for property_name in properties{
                guard let value = dict[property_name] else {
                    continue;
                }
                
                if let value = value as? String {
                    targetClass.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    targetClass.setValue(value.stringValue, forKey: property_name);
                }
//                targetClass.setValue(200, forKey: "response");
            }
        }
    }
    static func parseResponse(model:BaseModelSwift,targetClass:BaseModelSwift,dict:[String:Any]?){
        if let dict = dict {
            let properties = model.propertyNames();
            for property_name in properties{
                guard let value = dict[property_name] else {
                    continue;
                }
                if let value = value as? String {
                    targetClass.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    targetClass.setValue(value.stringValue, forKey: property_name);
                }
                //targetClass.setValue(200, forKey: "response");
            }
        }
    }
    static func parseResponse(properties:[String],targetClass:BaseModelSwift,dict:[String:Any]?){
        if let dict = dict {
            for property_name in properties{
                guard let value = dict[property_name] else {
                    continue;
                }
                if let value = value as? String {
                    targetClass.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    targetClass.setValue(value.stringValue, forKey: property_name);
                }
                //targetClass.setValue(200, forKey: "response");
            }
        }
        
    }
    
    static func getQuestionDict(targetClass:BaseModelSwift)->[String:Any]{
        let properties = targetClass.propertyNames();
        var questionDict = [String:Any]();
        for property_name in properties{
            if let value = targetClass.value(forKey: property_name) {
                if let value = value as? String {
                    questionDict[property_name] = value;
                }else if let value = value as? NSNumber {
                    questionDict[property_name] = value;
                }
            }
        }
        return questionDict;
    }
    static func getQuestionDict(targetClass:BaseModelSwift,model:BaseModelSwift,prevData:[String:Any]?)->[String:Any]{
        let properties = model.propertyNames();
        var questionDict = [String:Any]();
        if let prevData = prevData {
            questionDict = prevData;
        }
        for property_name in properties{
            if let value = targetClass.value(forKey: property_name) {
                if let value = value as? String {
                    questionDict[property_name] = value;
                }else if let value = value as? NSNumber {
                    questionDict[property_name] = value;
                }
                
            }
        }
        return questionDict;
    }
    
    static func copyToItem(source:BaseModelSwift,target:BaseModelSwift){
        
        let properties = source.propertyNames();
        
        for property_name in properties{
            if let value = source.value(forKey: property_name) {
                if let value = value as? String {
                    target.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    target.setValue(value.stringValue, forKey: property_name);
                }
            }
        }
    }
    static func copyNSObjectToBaseModel(source:NSObject,target:BaseModelSwift){
        let properties = target.propertyNames();
        
        for property_name in properties{
            if let value = source.value(forKey: property_name) {
                if let value = value as? String {
                    target.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    target.setValue(value.stringValue, forKey: property_name);
                }
            }
        }
        
        
        
//        var count = UInt32()
//        
//        let properties : UnsafeMutablePointer<objc_property_t?> = class_copyPropertyList(source.classForCoder, &count)
//        var propertyNames = [String]()
//        let intCount = Int(count)
//        for i in 0 ..< intCount {
//            if let property : objc_property_t = properties[i] {
//                if let propertyName = NSString.init(utf8String:  property_getName(property)) as? String {
//                    if let value = source.value(forKey: propertyName){
//                        if let value = value as? String {
//                            
//                        }
//                    }
//                    propertyNames.append(propertyName)
//                }
//            }
//        }
//        free(properties)
//        print(propertyNames)
    }
    
    static func copyToItem(source:BaseModelSwift,target:BaseModelSwift,model:BaseModelSwift){
        
        let properties = model.propertyNames();
        
        for property_name in properties{
            if let value = source.value(forKey: property_name) {
                if let value = value as? String {
                    target.setValue(value, forKey: property_name);
                }else if let value = value as? NSNumber {
                    target.setValue(value.stringValue, forKey: property_name);
                }
            }
        }
    }
    
    static func getDuplicate(targetClass:BaseModelSwift)->BaseModelSwift{
        let theClass = type(of: targetClass)
        let ret = theClass.init()
        let properties = targetClass.propertyNames();
        
        for property_name in properties{
            if let value = targetClass.value(forKey: property_name) {
                ret.setValue(value, forKey: property_name);
            }
        }
        return ret
    }
    
    required override init() {
        super.init()
    }
}
