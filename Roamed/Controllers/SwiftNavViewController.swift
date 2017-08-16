//
//  NavViewController.swift
//  TravPholer
//
//  Created by BoHuang on 12/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import UIKit
import CoreData

class SwiftNavViewController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = UIImage()
//        
//        self.navigationBar.backgroundColor = Constants.COLOR_TOOLBAR_BACK
        
        let font:UIFont = UIFont.boldSystemFont(ofSize: 16)
        self.navigationBar.barTintColor = CGlobal.color(withHexString: "3799E5", alpha: 1.0)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Constants.COLOR_TOOLBAR_TEXT,NSFontAttributeName:font];
//        let titleDict: [String:Any] = [NSForegroundColorAttributeName: Constants.COLOR_TOOLBAR_TEXT]
//        self.navigationBar.titleTextAttributes = titleDict
//        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func downloadHelp(request1:RequestLogin){
        if let country = request1.country {
            let request = RequestLogin.init()
            let iso = country.replacingOccurrences(of: " ", with: "+")
            request.iso = iso
            request.country = country
            if let html = self.getTextShow(iso:iso) {
                // saved
                debugPrint("saved")
            }else{
                // not saved
                
                // Do any additional setup after loading the view, typically from a nib.
                //self.iso = "New+Zeland"
                let urlStr:String = "http://prepaid-data-sim-card.wikia.com/api/v1/Search/List?query="+iso+"&minArticleQuality=10&batch=1&namespaces=0%2C14"
                debugPrint(urlStr)
                self.show(urlStr: urlStr,request:request)
            }
        }
    }
    func getTextShow(iso:String)->String?{
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        do {
            
            //            let request = NSFetchRequest<HelpModel>.init(entityName: "HelpModel")
            //            request.predicate = NSPredicate(format: "iso = '%@'","aaa")
            let request = NSFetchRequest<HelpModel>.init(entityName: "HelpModel")
            request.predicate = NSPredicate.init(format: " iso == '" + iso.lowercased() + "'");
            
            let rows = try context.fetch(request)
            //            let rows = try context.fetch(HelpModel.fetchRequest())
            if rows.count>0 {
                let model:HelpModel = rows[0] as! HelpModel
                return model.html
            }
        } catch  {
            debugPrint("Fetch Failed")
        }
        return nil
    }
    func saveTexttoShow(text:String,iso:String)->Bool{
        
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let user = HelpModel(context:context)
        
        user.iso = iso.lowercased()
        user.html = text
        
        return delegate.saveContext()
        
    }
    func show(urlStr:String,request:RequestLogin){
        var textToShow:String = ""
        textToShow = "<style>a{ color:#43ABEA } p{ line-height:1.5; }</style>";
        
        let url = URL(string: urlStr) //set url
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            
            
            if error == nil{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any], let arrayDetails = jsonResult["items"] as? [AnyObject] {
                        let countArray = arrayDetails.count
                        
                        for i in 0..<countArray{
                            var arrayCountry = arrayDetails[i]["title"] as! String
                            arrayCountry = arrayCountry.lowercased()
                            let t2 = request.country?.lowercased()
                            debugPrint(arrayCountry)
                            debugPrint(t2)
                            
                            
                            if arrayCountry == t2{
                                
                                let pageId:AnyObject = (arrayDetails[i]["id"] as? NSNumber)!
                                let url = arrayDetails[i]["url"] as! String
                                
                                
                                let detailsUrl = URL(string: "http://prepaid-data-sim-card.wikia.com/api/v1/Articles/AsSimpleJson?id=\(pageId)")
                                let detailTask = URLSession.shared.dataTask(with: detailsUrl!, completionHandler: {
                                    (detailData, detailResponse, detailError) in
                                    
                                    do{
                                        if let detailTask = try JSONSerialization.jsonObject(with: detailData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any], let sectionDetails = detailTask["sections"] as? [AnyObject]{
                                            let countDetailsTask = sectionDetails.count
                                            //let sectionDetails = detailTask["sections"]!!
                                            for sectionLoop in 0..<countDetailsTask{
                                                
                                                
                                                
                                                let title = sectionDetails[sectionLoop]["title"] as! String
                                                let level = sectionDetails[sectionLoop]["level"] as! NSNumber
                                                if let imageGet = sectionDetails[sectionLoop]["images"] as? [AnyObject]{
                                                    if(imageGet.count > 0 ) {
                                                        
                                                        let imageResult = imageGet[0]["src"] as! String
                                                        
                                                        textToShow = textToShow + "<h\(level)>\(title)</h\(level)><div align=\"center\"><img align=\"center\" src=\"\(imageResult)\"></div>"
                                                    }else{
                                                        
                                                        textToShow = textToShow + "<h\(level)>\(title)</h\(level)>"
                                                    }
                                                }
                                                
                                                
                                                
                                                if(sectionLoop == 0){
                                                    textToShow = textToShow + "<p style=\"font-size:10px;\">Powered by Wikia. Visit <a href=\"\(url)\">\(url)</a> for more details.</p>"
                                                }
                                                if let contentGet = sectionDetails[sectionLoop]["content"] as? [AnyObject]{
                                                    let countContent = contentGet.count
                                                    
                                                    
                                                    if(countContent != 0){
                                                        for contentLoop in 0...countContent - 1{
                                                            if contentGet[contentLoop]["type"] as! String == "paragraph"{
                                                                let content = contentGet[contentLoop]["text"] as! String
                                                                
                                                                textToShow = textToShow + "\n<p>\(content)</p>"
                                                                
                                                                
                                                            }
                                                            
                                                            if contentGet[contentLoop]["type"] as! String == "list"{
                                                                if let tempElements = contentGet[contentLoop]["elements"] as? [AnyObject]{
                                                                    let contentElements = tempElements.count
                                                                    if contentElements != 0 {
                                                                        textToShow = textToShow + "<ul>"
                                                                        for elementsLoop in 0...contentElements - 1{
                                                                            let content = tempElements[elementsLoop]["text"] as! String
                                                                            
                                                                            textToShow = textToShow + "<li>\(content)</li>"
                                                                        }
                                                                        textToShow = textToShow + "</ul>"
                                                                    }
                                                                }
                                                                
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            
                                            if self.saveTexttoShow(text: textToShow,iso:request.iso!) {
                                                debugPrint("save succ")
                                            }
                                            
                                        }
                                        
                                        
                                    }catch{
                                        debugPrint("catch1");
                                    }
                                    
                                    
                                }) //like a mini webrowser to go the the url; open browser in background
                                
                                
                                detailTask.resume()
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }catch {
                    //                    let nserror = error as NSError
                    //                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    debugPrint("catch2");
                }
            }
            
        }) //like a mini webrowser to go the the url; open browser in background
        
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
