//
//  AppDelegate.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import ReachabilitySwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dbManager:DBManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initData(application: application)
        initServices(application: application)
        
        //defaultMainWindow()
        let global = CGlobal.sharedId();
        
        // check the launchOptions
        
        
        switch -2 {
        case 1:
            
            
            //            self.doLogin(username: "fb_alfredlam2010@yahoo.com.hk", password: "alfredlam2010@yahoo.com.hk",type:"0")
            
            //            self.doLogin(username: "fb_in_a_happy_shineing_days@hotmail.com", password: "in_a_happy_shineing_days@hotmail.com",type:"0")
            
            //            self.doLogin(username: "fb_bohuang29@hotmail.com", password: "bohuang29@hotmail.com",type:"0")
            
            
            break;
        case 2:
            self.defaultLogin()
            break
        default:
            
            if let env = global?.env {
                if env.lastLogin > 0 {
                    //let requestLogin = self.getRequestInfoLogin()
                    //self.doLogin(requestLogin: requestLogin)
                    if(checkOption(option:launchOptions)){
                        return true;
                    }
                    self.defaultMainWindow()
                    return true;
                }else{
                    if env.introviewed == 1 {
                        self.defaultLogin()
                        return true;
                    }else{
                        let ms = UIStoryboard.init(name: "Main2", bundle: nil);
                        DispatchQueue.main.async {
                            let viewcon = ms.instantiateViewController(withIdentifier: "IntroViewController");
                            self.window?.rootViewController = viewcon
                        }
                        return true;
                    }
                }
            }
            
            self.defaultLogin()
            break;
        }
        return true
    }
    func checkOption(option:[UIApplicationLaunchOptionsKey: Any]?)->Bool{
        if let userInfo = option?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable:Any] {
            if let data = userInfo["data"] as? [String:String]{
                let id = data["id"]
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                
                let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                viewcon.purchase_id = id
                
                let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                do {
                    let rows = try context.fetch(User.fetchRequest())
                    if rows.count>0 {
                        let user:User = rows[0] as! User
                        let global = GlobalSwift.sharedManager
                        global.curUser = user
                        self.registerDeviceUUID()

                        let tabbar = ms.instantiateViewController(withIdentifier: "CTabBar") ;
                        let navc = UINavigationController.init()
                        navc.viewControllers = [tabbar,viewcon];
                        navc.navigationBar.isHidden = true
                        self.window?.rootViewController = navc
                        return true;
                    }
                } catch  {
                    debugPrint("Fetch Failed")
                }
            }
        }
        return false
    }
    func getRequestInfoLogin()->RequestLogin{
        let ret = RequestLogin()
        return ret
    }
    func doLogin(requestLogin:RequestLogin){
        let manager = NetworkUtil.sharedManager
        
        manager.ontemplateGeneralRequest(data: requestLogin, method:.get,url: Constants.ACTION_LOGIN, completionBlock: { (dict, error) in
            if error != nil {
                self.defaultLogin()
                NotificationCenter.default.post(name: Notification.Name(Constants.GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL), object: nil)
            }else {
                let loginResp = LoginResponse.init(dictionary: dict)
                self.goMainWindow(data: loginResp)
                
                NotificationCenter.default.post(name: Notification.Name(Constants.GLOBALNOTIFICATION_RECEIVE_USERINFO_SUCC), object: nil)
            }
        });
    }
    
    func initData(application:UIApplication){
        dbManager = DBManager.init(databaseFilename: "country.sqlite3")
        COLOR_TOOLBAR_TEXT = Constants.COLOR_TOOLBAR_TEXT
        COLOR_TOOLBAR_BACK = Constants.COLOR_TOOLBAR_BACK
        COLOR_PRIMARY = CGlobal.color(withHexString: "00a1e9", alpha: 1.0);
        COLOR_SECONDARY_PRIMARY = CGlobal.color(withHexString: "1C75BC", alpha: 1.0);
        COLOR_SECONDARY_GRAY = CGlobal.color(withHexString: "939498", alpha: 1.0);
        COLOR_SECONDARY_THIRD = CGlobal.color(withHexString: "044154", alpha: 1.0);
        COLOR_RESERVED = CGlobal.color(withHexString: "F26336", alpha: 1.0);
        
        //        let fontManager = FontManager.sharedManager
        
    }
    var network_available:Bool = false
    func initServices(application:UIApplication){
        IQKeyboardManager.sharedManager().enable = true
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let newToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        debugPrint("My token is " + newToken)
        let global = GlobalSwift.sharedManager
        global.uuid = newToken
        self.registerDeviceUUID()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        debugPrint("didReceiveRemoteNotification")
        self.processMessage(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let data = userInfo["data"] as? [String:String]{
            let id = data["id"]
            if let vc = window?.rootViewController{
                var parentViewController:UIViewController = vc
                while (parentViewController.presentedViewController != nil){
                    parentViewController = parentViewController.presentedViewController!;
                }
                
                let curViewController = parentViewController
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                DispatchQueue.main.async {
                    let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                    viewcon.purchase_id = id
                    if let navc = curViewController.navigationController {
                        navc.pushViewController(viewcon, animated: true)
                    }
                }
            }
            
        }
    }
    func processMessage(userInfo: [AnyHashable : Any]){
        if let data = userInfo["data"] as? [String:AnyObject] {
            if let rdata = data["rdata"] as? [String:AnyObject] {
                if let title = rdata["ttc_subject"] as? String{
                    if let message = rdata["ttc_message"] as? String {
                        CGlobal.alertMessage(message, title: title)
                    }
                }
            }
        }
    }
    func logout(){
        if let env = CGlobal.sharedId().env{
            env.logOut()
            
            let user = TblUser.init()
            let global = GlobalSwift.sharedManager
            //            user.tu_id = global.curUser?.tu_id
            //            user.tu_apnid = "-1"
            //
            //            let manager = NetworkUtil.sharedManager
            //
            //            manager.ontemplateGeneralRequest(data: user,method:.post, url: Constants.ACTION_UPDATEPROFILE) { (dict, error) in
            //                if error == nil{
            //                    debugPrint("TokenRemoved: -1")
            //                }else{
            //                    debugPrint("Fail to RemoveToken")
            //                }
            //            }
            global.curUser = nil
            self.defaultLogin()
        }
    }
    func goMainWindow(data:LoginResponse){
        if let env = CGlobal.sharedId().env{
            
            
            if (self.saveLoginInfo(data: data)){
                let global = GlobalSwift.sharedManager
                
                env.lastLogin = Int((data.userid)!)!
                
                switch -4 {
                case 1:
                    let ms = UIStoryboard.init(name: "Main", bundle: nil);
                    DispatchQueue.main.async {
                        let viewcon = ms.instantiateViewController(withIdentifier: "CNavCheckInAttr");
                        self.window?.rootViewController = viewcon
                    }
                default:
                    self.defaultMainWindow()
                    break;
                    
                }
            }
        }
    }
    func saveLoginInfo(data:LoginResponse)->Bool{
        // save to coredata
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let user = User(context:context)
        
        user.phoneno = data.phone
        user.userid = data.userid
        user.iso = data.country_iso
        user.country = data.country
        
        return delegate.saveContext()
    }
    
    func defaultMainWindow(){
        // retrieve user info
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do {
            let rows = try context.fetch(User.fetchRequest())
            if rows.count>0 {
                let user:User = rows[0] as! User
                let global = GlobalSwift.sharedManager
                global.curUser = user
                self.registerDeviceUUID()
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                DispatchQueue.main.async {
                    let viewcon = ms.instantiateViewController(withIdentifier: "CTabBar");
                    let navc = UINavigationController.init()
                    navc.viewControllers = [viewcon];
                    navc.navigationBar.isHidden = true
                    self.window?.rootViewController = navc
                }
            }
        } catch  {
            debugPrint("Fetch Failed")
        }
    }
    
    func defaultLogin(){
        if let env = CGlobal.sharedId().env{
            env.lastLogin = 0
            let ms = UIStoryboard.init(name: "Main2", bundle: nil);
            
            DispatchQueue.main.async {
                if let viewcon = ms.instantiateViewController(withIdentifier: "CLoginNav") as? UINavigationController{
                    if viewcon.childViewControllers.count > 0 {
                        if let lc = viewcon.childViewControllers[0] as? LoginViewController {
                            lc.showProgress = false
                        }
                    }
                    self.window?.rootViewController = viewcon
                }
            }
        }
        
    }
    
    func registerDeviceUUID(){
        let global = GlobalSwift.sharedManager
        guard let user = global.curUser, let uuid = global.uuid else {
            debugPrint("registerUUID no value")
            return
        }
        
        let request = RequestLogin()
        request.setDefaultkeySecret()
        request.userid = user.userid
        request.phone = user.phoneno
        request.iso = user.iso
        request.country = user.iso
        request.name = UserDefaults.standard.string(forKey: "name")
        request.device_token = uuid
        
        let manager = NetworkUtil.sharedManager
        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_SAVETOKEN) { (dict, error) in
            
            if error == nil {
                let temp = LoginResponse.init(dictionary: dict)
                if let status = temp.status{
                    if status == "success" {
                        debugPrint("succ savetoken")
                    }else{
                        debugPrint("fail savetoken")
                    }
                }
            }else{
                debugPrint("fail savetoken")
            }
            
        }
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        debugPrint("fetchComplitionListener")
//    }
    func test(){
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do {
            let rows = try context.fetch(User.fetchRequest())
            if rows.count>0 {
                let user:User = rows[0] as! User
                debugPrint(user.phoneno)
            }
        } catch  {
            debugPrint("Fetch Failed")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Roamed")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext ()->Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }

}

