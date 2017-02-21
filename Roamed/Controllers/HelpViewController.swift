 //
 //  ViewController.swift
 //  WikiaJson
 //
 //  Created by QL on 2/8/16.
 //  Copyright © 2016 SIMPSY LLP. All rights reserved.
 //
 
 import UIKit
 
 class HelpViewController: UIViewController {
    var textToShow:String = ""
    var iso:String = "New+Zeland"
    
    
    @IBOutlet weak var webView: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textToShow = "<style>a{ color:#43ABEA } p{ line-height:1.5; }</style>";
        // Do any additional setup after loading the view, typically from a nib.
        let urlStr:String = "http://prepaid-data-sim-card.wikia.com/api/v1/Search/List?query="+iso+"&minArticleQuality=10&batch=1&namespaces=0%2C14"
        let url = URL(string: urlStr) //set url
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            
            
            if error == nil{
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any], let arrayDetails = jsonResult["items"] as? [AnyObject] {
                        let countArray = arrayDetails.count
                        
                        for i in 0..<countArray{
                            let arrayCountry = arrayDetails[i]["title"] as! String
                            
                            
                            if arrayCountry == "New Zealand"{
                                
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
                                                        
                                                        self.textToShow = self.textToShow + "<h\(level)>\(title)</h\(level)><div align=\"center\"><img align=\"center\" src=\"\(imageResult)\"></div>"
                                                    }else{
                                                        
                                                        self.textToShow = self.textToShow + "<h\(level)>\(title)</h\(level)>"
                                                    }
                                                }
                                                
                                                
                                                
                                                if(sectionLoop == 0){
                                                    self.textToShow = self.textToShow + "<p style=\"font-size:10px;\">Powered by Wikia. Visit <a href=\"\(url)\">\(url)</a> for more details.</p>"
                                                }
                                                if let contentGet = sectionDetails[sectionLoop]["content"] as? [AnyObject]{
                                                    let countContent = contentGet.count
                                                    
                                                    
                                                    if(countContent != 0){
                                                        for contentLoop in 0...countContent - 1{
                                                            if contentGet[contentLoop]["type"] as! String == "paragraph"{
                                                                let content = contentGet[contentLoop]["text"] as! String
                                                                
                                                                self.textToShow = self.textToShow + "\n<p>\(content)</p>"
                                                                
                                                                
                                                            }
                                                            
                                                            if contentGet[contentLoop]["type"] as! String == "list"{
                                                                if let tempElements = contentGet[contentLoop]["elements"] as? [AnyObject]{
                                                                    let contentElements = tempElements.count
                                                                    if contentElements != 0 {
                                                                        self.textToShow = self.textToShow + "<ul>"
                                                                        for elementsLoop in 0...contentElements - 1{
                                                                            let content = tempElements[elementsLoop]["text"] as! String
                                                                            
                                                                            self.textToShow = self.textToShow + "<li>\(content)</li>"
                                                                        }
                                                                        self.textToShow = self.textToShow + "</ul>"
                                                                    }
                                                                }
                                                                
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            DispatchQueue.main.async{
                                                // print(self.textToShow)
                                                self.webView.loadHTMLString(self.textToShow, baseURL: nil)
                                                
                                            }
                                        }
                                        
                                        
                                    }catch{
                                        
                                    }
                                    
                                    
                                }) //like a mini webrowser to go the the url; open browser in background
                                
                                
                                detailTask.resume()
                                
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }catch{
                    
                }
            }
            
        }) //like a mini webrowser to go the the url; open browser in background
        
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 }
 
