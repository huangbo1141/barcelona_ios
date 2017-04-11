//
//  Constants.swift
//  TravPholer
//
//  Created by BoHuang on 11/26/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import Foundation
import StoreKit
private let _sharedManager = Constants()

class Constants:NSObject{
    class var sharedManager:Constants {
        return _sharedManager;
    }
    public override init(){
        
    }
    
    //
    static let PRIMARY_COLOR = UIColor.init(colorLiteralRed: 21.0/255.0, green: 129.0/255.0, blue: 198.0/255.0, alpha: 1.0)
//    https://roamed.co/api/register/?key=abc123&secret=123abc&phone=92997764&country=sg&name=test
    
    static let PRODUCT_ID_DAY = "com.simpsy.roamed.day"
    
    static let PATH_APNS = "apnsv2";
    static let APISERVICE_IP_URL = "http://ip-api.com/json";
    static let APISERVICE_MAP_URL = "http://maps.googleapis.com/maps";
    
    static let ACTION_LOGIN = "/api/register/";
    static let ACTION_GET_PURCHASE = "/api/get_purchased/";
    static let ACTION_DIVERT = "/api/divert/";
    static let ACTION_CHANGECOUNTRY = "/api/change_country/";
    static let ACTION_CALLLIST = "/api/calls/";
    static let ACTION_COUNTRYISO = "/api/get_country_iso/";
    static let ACTION_REG_COUNTRY = "/api/register_country/";
    static let ACTION_CHECKPURCHASE = "/api/check/";
    static let ACTION_DOPURCHASE = "/api/purchase/";
    static let ACTION_EXTEND = "/api/extend/";
    static let ACTION_SETNOTI = "/api/set_notification/";
    static let ACTION_SAVETOKEN = "/api/register/";
    static let ACTION_GETPRICE = "/api/get_price/";
    
    static let ACTION_UPLOAD = "/assets/rest/" + PATH_APNS + "/fileuploadmm.php";
    static let ACTION_UPLOAD_V = "/assets/rest/" + PATH_APNS + "/fileuploadvv.php";  //fileuploadvv.php

    
    static let ACTION_USERINFO = "/assets/rest/" + PATH_APNS + "/userinfo.php";
    static let ACTION_UPDATEPROFILE = "/assets/rest/" + PATH_APNS + "/updateprofile.php";
    static let ACTION_LOADNOTI = "/assets/rest/" + PATH_APNS + "/load_noti.php";
    static let ACTION_TOGO_IDS = "/assets/rest/" + PATH_APNS + "/loadtogo_ids.php";
    
    static let ACTION_TOGO_DATA = "/assets/rest/" + PATH_APNS + "/loadtogo_data.php";
    static let ACTION_CONQUERED_DATA = "/assets/rest/" + PATH_APNS + "/loadconquered_data.php";
    
    static let ACTION_DEFAULTPROFILE = "/assets/uploads/user1.png";
    static let ACTION_LOADCOMMENT = "/assets/rest/" + PATH_APNS + "/load_comment.php";
    
    static let ACTION_PROFILE_LOG = "/assets/rest/" + PATH_APNS + "/load_profile_log.php";
    static let ACTION_PROFILE_LOG_EX = "/assets/rest/" + PATH_APNS + "/load_profile_log_ex.php";
    static let ACTION_PROFILE_LIST = "/assets/rest/" + PATH_APNS + "/load_profile_list.php";
    static let ACTION_PROFILE_MAPLOG = "/assets/rest/" + PATH_APNS + "/load_profile_map_log.php";
    static let ACTION_PROFILE_MAPLIST = "/assets/rest/" + PATH_APNS + "/load_profile_map_list.php";
    
    static let ACTION_ITIN = "/assets/rest/" + PATH_APNS + "/actionitin.php";
    static let ACTION_TRIP = "/assets/rest/" + PATH_APNS + "/actiontrip.php";
    static let ACTION_MAKEANY = "/assets/rest/" + PATH_APNS + "/makeany.php";
    static let ACTION_BUCKET = "/assets/rest/" + PATH_APNS + "/actionbucket.php";
    static let ACTION_LOAD_BUCKET = "/assets/rest/" + PATH_APNS + "/load_bucket.php";
    static let ACTION_DUP_STORIES = "/assets/rest/" + PATH_APNS + "/makedup_stories.php";
    static let ACTION_MAKEITIN = "/assets/rest/" + PATH_APNS + "/makeitin.php";
    static let ACTION_FOLLOW = "/assets/rest/" + PATH_APNS + "/actionfollow.php";
    
    static let ACTION_CREATELIST = "/assets/rest/" + PATH_APNS + "/createlist.php";
    
    
    static let MENU_HEIGHT:CGFloat = 30.0
    static let COLOR_TOOLBAR_TEXT = UIColor.white
//    static let COLOR_TOOLBAR_TEXT = CGlobal.color(withHexString: "aaaaaa", alpha: 1.0)
    static let COLOR_TOOLBAR_BACK = CGlobal.color(withHexString: "#759ED3", alpha: 1.0)
    
    
    // notifications
    static let GLOBALNOTIFICATION_DATA_CHANGED_PHOTO = "GLOBALNOTIFICATION_DATA_CHANGED_PHOTO";
    static let GLOBALNOTIFICATION_MAP_PICKLOCATION = "GLOBALNOTIFICATION_MAP_PICKLOCATION";
    static let GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC = "GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC";
    static let GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL = "GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL";
    static let GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER = "GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER";
    static let GLOBALNOTIFICATION_CHANGEVIEWCONTROLLERREBATE = "GLOBALNOTIFICATION_CHANGEVIEWCONTROLLERREBATE";
    
    static let GLOBALNOTIFICATION_MQTTPAYLOAD = "GLOBALNOTIFICATION_MQTTPAYLOAD";
    static let GLOBALNOTIFICATION_MQTTPAYLOAD_PROCESS = "GLOBALNOTIFICATION_MQTTPAYLOAD_PROCESS";
    
    static let GLOBALNOTIFICATION_TRENDINGRESET = "GLOBALNOTIFICATION_TRENDINGRESET";
    static let GLOBALNOTIFICATION_LIKEDBUTTON =  "GLOBALNOTIFICATION_LIKEDBUTTON";
    
    static let NOTIFICATION_RECEIVEUUID =  "NOTIFICATION_RECEIVEUUID";
    
    static let kPhotoManagerChangedContentNotificationHot = "NOTIFICATION_PhotoManagerChangedContentHot";
    
    static let kPhotoManagerChangedContentNotificationFresh = "NOTIFICATION_PhotoManagerChangedContentFresh";
    
    static let kPhotoManagerChangedContentNotificationOthers = "NOTIFICATION_PhotoManagerChangedContentOthers";
    
    static let GoogleDirectionAPI = "AIzaSyCmvC_H5S08MvkO-ixoQTpJQGXdu5qyVWg"
    //&types=(cities)
    static let kGoogleAutoCompleteAPI  = "https://maps.googleapis.com/maps/api/place/autocomplete/json?language=en&key=" + GoogleDirectionAPI + "&input="
    
    static let DEFAULT_POS = CLLocationCoordinate2D.init(latitude: 47, longitude: 2)
    static let CATEGORY_CULTURE = 1;
    static let CATEGORY_ENTERTAINMENT = 2;
    static let CATEGORY_ACTIVITIES = 3;
    static let CATEGORY_FOOD = 4;
    static let CATEGORY_SHOPPING = 5;
    static let CATEGORY_SIGHTSEEING = 6;
    
    static let POST_PHOTO = "0";
    static let POST_VIDEO = "1";
    static let POST_ENDED_TRIP = "2";
    
    static let ACCOUNT_FB = "0";
    static let ACCOUNT_TW = "1";
    static let ACCOUNT_WB = "2";
    static let ACCOUNT_NM = "3";
    
    static let BUCKET_CONTENTTYPE_0 = "0";
    static let BUCKET_CONTENTTYPE_1 = "1";
    
    
    static let STATUS_INITIAL   = "2";
    static let STATUS_PUBLISHED = "0";
    static let STATUS_DELETED   = "3";
    static let STATUS_COMPLETED = "4";
    
    static let PRE_EXPLORE_PAGE = ["Hot","Fresh","Followed"]
    
    static let POST_LEADING:CGFloat = 20
    static let POST_TOP:CGFloat =   40
    
    static let DEFAULT_FETCH_ROWS = "50"
    static let DEFAULT_FETCH_STEPS = "50"
    
    static let DEFAULT_FETCH_UP = "1"
    static let DEFAULT_FETCH_DOWN = "0"
    static let DEFAULT_FETCH_NORMAL = "2"
    
    static let DEFAULT_BOTTOM_TAB_HEIGHT:CGFloat = 60
    
    static let JOIN_ACCEPT = "2"
    static let JOIN_REJECT = "1"
    static let JOIN_INITIAL = "0"
    
    static let STORYTYPE_ATTR = "a";
    static let STORYTYPE_TRANSPORT = "b";
    static let STORYTYPE_REST = "c";
    
    static let STORYTYPE_TRIP = "t";
    
    static var iapProducts = [SKProduct]()
//    static var PRE_EXPLORE_PAGE:[BaseModelSwift] {
//        get {
//            let data1 = BaseModelSwift.init()
//            data1.mystring = "Hot"
//            
//            let data2 = BaseModelSwift.init()
//            data2.mystring = "Fresh"
//            
//            let data3 = BaseModelSwift.init()
//            data3.mystring = "Followed"
//            let row = [data1,data2,data3]
//            return row
//        }
//    }
}




