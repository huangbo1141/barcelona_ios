//
//  CGlobal.swift
//  TravPholer
//
//  Created by BoHuang on 11/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
import StoreKit

private let _sharedManager = GlobalSwift()



class GlobalSwift:NSObject{
    class var sharedManager:GlobalSwift {
        return _sharedManager;
    }
    public required override init(){
        
    }
    // http://45.33.95.201/adminuser    http://139.162.42.92/adminuser
    static let g_baseUrl = "http://82.223.19.247/barcelona/index.php/api/";
    static let g_basePhoto = "http://82.223.19.247/barcelona/";

    static let g_baseUrl2 = "https://stream-hk.travpholer.com/adminuser";
    
//    static let g_baseUrl = "http://192.168.21.1/adminuser";
//    static let g_baseUrl2 = "http://stream-hk.travpholer.com/adminuser";
//    static let g_baseUrl = "http://192.168.21.1/adminuser";
//    static let g_baseUrl2 = "http://192.168.21.1/adminuser";
    
    
    static let g_baseImage = "/assets/base"
    
    
    static func getThumbPhotoPath(filename:String)->String{
        let uploadpath = g_baseUrl + "/assets/uploads/thumbnail/" + filename;
        return uploadpath;
    }
    
    static func getPhotoPath(filename:String)->String{
        let uploadpath = g_basePhoto + filename;
        return uploadpath;
    }
    
    static func getBasePhotoPath(filename:String)->String{
        let uploadpath = g_baseUrl + "/assets/base/" + filename;
        return uploadpath;
    }
    
    static func generateFilePath()->String{
        let date = NSDate.init();
        let path = String(date.timeIntervalSince1970) + ".jpg"
        let uploadpath = g_baseUrl + "uploads/" + path;
        
        
        return uploadpath;
    }
    
    var curUser:User?
    
    
    var loginResponse:LoginResponse?
    var uuid:String?
    var purchaseResponse:PurchaseResponse?
    
    static func heightForString(font: UIFont, width: CGFloat, string:String?) -> CGFloat {
        if let string = string {
            let rect = NSString(string: string).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            return ceil(rect.height)
        }
        return 0;
    }
    static func validateUrl(candidate:String)->Bool{
        if let url = URL.init(string: candidate){
            return true
        }else{
            return false
        }
    }

    static func getTimeOffset(tz:TimeZone)->String{
        var seconds:Int = tz.secondsFromGMT()
        var sign = ""
        if seconds < 0 {
            seconds = -1*seconds
            sign = "+"
        }else{
            sign = "-"
        }
        let hour:Int = seconds/3600
        var timezone = ""
        if seconds%3600 > 0 {
            let remain = seconds - hour*3600
            timezone = "\(sign)\(hour):30"
        }else{
            timezone = "\(sign)\(hour):00"
        }
        return timezone
    }
    static func getNumberDay(product:SKProduct)->[Int]?{
        let productID = product.productIdentifier
        if productID.hasPrefix(Constants.PRODUCT_ID_DAY) {
            let index = productID.index(productID.startIndex, offsetBy: Constants.PRODUCT_ID_DAY.characters.count)
            let suffix = productID.substring(from: index)
            let suffixArr = suffix.characters.split{$0 == " "}.map(String.init)
            if suffixArr.count == 2 {
                if let day1 = Int(suffixArr[0]),let day2 = Int(suffixArr[1]){
                    return [day1,day2];
                }
            }
            
        }
        return nil;
    }
    static func findProductInArray(day1:Int,day2:Int,array:[SKProduct])->SKProduct?{
        for i in 0..<array.count {
            let product = array[i]
            let productID = product.productIdentifier
            if productID == Constants.PRODUCT_ID_DAY + "\(day1)_\(day2)" {
                return product;
            }
        }
        return nil;
    }
    
}
