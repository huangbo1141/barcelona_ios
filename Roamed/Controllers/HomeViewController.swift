//
//  HomeViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift
import StoreKit
class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SKProductsRequestDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "Roamed"
        
        let nib = UINib.init(nibName: "PurchaseTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.async {
            let refreshControl:UIRefreshControl = UIRefreshControl.init()
            self.tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(control:)), for: UIControlEvents.valueChanged)
            
            self.refreshControl = refreshControl
        
            if let navc = self.navigationController {
//                let item:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "history"), style: .plain, target: self, action: #selector(HomeViewController.clickView(sender:)))
                //            let item1:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: ., target: <#T##Any?#>, action: <#T##Selector?#>)
                let btn = UIButton.init(type: .custom)
                btn.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
                btn.addTarget(self, action: #selector(HomeViewController.clickView(sender:)), for: .touchUpInside)
                //btn.showsTouchWhenHighlighted = true
                
                let image = UIImage.init(named: "history")
                btn.setImage(image, for: .normal)
                
                let item:UIBarButtonItem = UIBarButtonItem.init(customView: btn)
                btn.tag = 100
//                item.tag = 100
                self.navigationItem.rightBarButtonItems = [item]
            }
            
            let gesture = UISwipeGestureRecognizer.init(target: self, action: #selector(HomeViewController.swipeRight(gesture:)))
            gesture.direction = .left
            self.tableView.addGestureRecognizer(gesture)
            
            if let tabvc = self.tabBarController as? TabViewController {
                if let pushid = tabvc.push_id {
                    let ms = UIStoryboard.init(name: "Main", bundle: nil);
                    let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                    viewcon.purchase_id = pushid
                    DispatchQueue.main.async {
                        if let navc = self.navigationController {
                            navc.pushViewController(viewcon, animated: true)
                            tabvc.push_id = nil
                        }
                    }
                }
            }
        }
        
        self.inappInit()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getPurchased()
        
        
    }
    
    var refreshControl:UIRefreshControl?
    func swipeRight(gesture:UISwipeGestureRecognizer){
        if let tabvc  = self.tabBarController {
            
            self.view.slideIn(fromRight: 0.5, delegate: nil, bounds: CGRect.zero)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // your code here
                tabvc.selectedIndex = 1
            }
        }
    }
    
    func clickView(sender:UIView){
        let tag = sender.tag
        if tag == 100 {
            let ms = UIStoryboard.init(name: "Main", bundle: nil);
            DispatchQueue.main.async {
                let viewcon = ms.instantiateViewController(withIdentifier: "PastViewController");
                self.navigationController?.pushViewController(viewcon, animated: true)
            }
        }
    }
    func refresh(control:UIRefreshControl){
        self.getPurchased()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var response:PurchaseResponse?
    func getPurchased(){
        let reach = Reachability()!
        let global = GlobalSwift.sharedManager
        if reach.isReachableViaWiFi || reach.reachableOnWWAN {
            if let user = global.curUser{
                let manager = NetworkUtil.sharedManager
                let request = RequestLogin()
                request.setDefaultkeySecret()
                request.userid = user.userid
                request.phone = user.phoneno
                request.current_purchase = "yes"
                
                CGlobal.showIndicator(self)
                manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_GET_PURCHASE) { (dict, error) in
                    //            let loginResp = LoginResponse.init(dictionary: dict)
                    //            debugPrint(loginResp.response)
                    if error == nil {
                        global.purchaseResponse = PurchaseResponse.init(dictionary: dict)
                        self.response = global.purchaseResponse
                        self.tableView.reloadData()
                    }else{
//                        if request.userid == nil {
//                            CGlobal.alertMessage("Fail to Load user id nil", title: nil)
//                            
//                        }else{
//                            CGlobal.alertMessage("Fail to Load " + request.userid!, title: nil)
//                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            // your code here
                            self.getPurchased();
                            return;
                        }
                    }
                    CGlobal.stopIndicator(self)
                    self.refreshControl?.endRefreshing()
                }
            }
        }else{
            // load from store
            let pResp = PurchaseResponse.init()
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = delegate.persistentContainer.viewContext
            do {
                
                let request = NSFetchRequest<PresentPurchase>.init(entityName: "PresentPurchase")
                
                let rows = try context.fetch(request)
                pResp.present_purchase = rows
            } catch  {
                debugPrint("Fetch Failed")
            }
            do {
                
                let request = NSFetchRequest<PastPurchase>.init(entityName: "PastPurchase")
                let rows = try context.fetch(request)
                pResp.past_purchase = rows
            } catch  {
                debugPrint("Fetch Failed")
            }
            global.purchaseResponse = pResp
            self.response = global.purchaseResponse
            self.tableView.reloadData()
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = self.response, let present = response.present_purchase {
            return present.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PurchaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseTableViewCell
        if let response = self.response, let present = response.present_purchase {
            cell.setData(data: present[indexPath.row])
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    let tableHeight:CGFloat = 50.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did select
        if let response = self.response, let present = response.present_purchase {
            let ms = UIStoryboard.init(name: "Main", bundle: nil);
            DispatchQueue.main.async {
                let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                viewcon.inputData = present[indexPath.row]
                self.navigationController?.pushViewController(viewcon, animated: true)
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    var productsRequest = SKProductsRequest()
    func inappInit(){
        // Check your In-App Purchases
        
        // Fetch IAP Products available
        fetchAvailableProducts()
        debugPrint("inappInit")
    }
    func fetchAvailableProducts()  {
        
        if Constants.iapProducts.count <= 0 {
            // Put here your IAP Products ID's
            var arrays:[String] = [String]()
            for i in 0..<100{
                arrays.append(Constants.PRODUCT_ID_DAY + "\(i)")
            }
            let productIdentifiers = NSSet(array: arrays)
            
            self.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            self.productsRequest.delegate = self
            
            self.productsRequest.start()
            debugPrint("fetchAvailableProducts")
        }
        
    }
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            debugPrint("enter 1")
            Constants.iapProducts = response.products
            
            Constants.iapProducts.sort(by: { (first, second) -> Bool in
                let fir = GlobalSwift.getNumberDay(product: first)
                let sec = GlobalSwift.getNumberDay(product: second)
                return fir < sec
            });
            
        }
        
    }
}
