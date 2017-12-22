//
//  NetworkUtil.swift
//  TravPholer
//
//  Created by BoHuang on 11/25/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
import Alamofire;

private let _networkUtil = NetworkUtil()

typealias NetworkCompletionBlock = ([String:Any]?,NSError?) -> Void

class NetworkUtil{
    
    var manager:DBManager?
    
    class var sharedManager:NetworkUtil {
        
        
        
        return _networkUtil;
    }
    
    func checkResponse(dict:[String:Any])->(Bool){
        if let response = dict["response"] as? NSNumber {
            if response.intValue == 200 {
                return true;
            }else{
                return false;
            }
        }
//        if let response = dict["status"] as? String {
//            if response == "success" {
//                return true;
//            }else{
//                return false;
//            }
//        }
        return true;
    }
    
    func ontemplateGeneralRequest(data: BaseModelSwift?,method:HTTPMethod, url:String,completionBlock:@escaping NetworkCompletionBlock){
        //let global = GlobalSwift.sharedManager
        
        var serverurl = GlobalSwift.g_baseUrl;
        serverurl = serverurl + url;
        
        var questionDict = [String:Any]()
        if let data = data {
            questionDict = BaseModelSwift.getQuestionDict(targetClass: data)
        }
        debugPrint(serverurl)
        debugPrint(questionDict)
        self.generalNetwork(serverurl: serverurl, questionDict: questionDict,method:method, completionBlock: completionBlock)
    }
    
    var afSessionMngr:SessionManager?
    
    func generalNetwork(serverurl:String,questionDict:[String:Any],method:HTTPMethod, completionBlock: NetworkCompletionBlock?){
        
//        let url = NSURL(string: serverurl);
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        afSessionMngr = Alamofire.SessionManager(configuration:config)
        
//        let afSessionMngr = Alamofire.SessionManager.default;
//        afSessionMngr.set
        
        afSessionMngr?.request(serverurl, method: method, parameters: questionDict, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            
            switch(response.result) {
            case .success(_):
                if let completionBlock = completionBlock {
                    guard let data = response.result.value as? [String:Any] else{
                        completionBlock(nil, NSError())
                        return;
                    }
                    // check data response
                    
                    if(self.checkResponse(dict: data)){
                        completionBlock(data,nil);
                    }else{
                        completionBlock(data,NSError());
                    }
                }
                break
                
            case .failure(_):
                if let completionBlock = completionBlock{
                    guard let error = response.result.error as? NSError else{
                        completionBlock(nil,NSError());
                        return;
                    }
                    completionBlock(nil,error as NSError);
                }
                
                break
                
            }
        }
    }
}
