//
//  ExtendViewController.swift
//  Roamed
//
//  Created by Twinklestar on 3/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import StoreKit

class ExtendViewController: UIViewController,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    var inputData:PresentPurchase?
    var tblPurchaseDetail:TblPurchaseDetail?
    @IBOutlet weak var lblCountry: ColoredLabel!
    @IBOutlet weak var constraint_ProductHeight: NSLayoutConstraint!
    @IBOutlet weak var stackProduct: UIStackView!
    
    @IBOutlet weak var lblLabel0: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    
    @IBAction func clickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = self.inputData {
            lblCountry.text = data.country
        }else if let data = self.tblPurchaseDetail {
            lblCountry.text = data.country
        }
        
        loaded = false
        self.inappInit()
        
        debugPrint("viewDidload")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        Constants.purchase_mode = 2
    }
    
    var requestTerm:RequestLogin?
    func clickView(sender:UIView){
        let tag = sender.tag
        if  tag >= 400 {
            let index = tag - 400
            let product = self.iapProducts_head[index]
            debugPrint(product.productIdentifier)
            if let firArray = GlobalSwift.getNumberDay(product: product) {
                let day1 = firArray[0]
                debugPrint(firArray[1])
                
                let manager = NetworkUtil.sharedManager
                let request = RequestLogin()
                request.setDefaultkeySecret()
                
                CGlobal.showIndicator(self)
                manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_CHECK_NEXT_PURCHASE) { (dict, error) in
                    
                    if error == nil {
                        let response = NextPurchaseResponse.init(dictionary: dict)
                        let numday_str = String(day1)
                        if let next_purchase = response.next_purchase,let day2 = Int(next_purchase) {
                            if let product = GlobalSwift.findProductInArray(day1: day1, day2: day2, array: self.iapProducts_all) {
                                if self.isLoading == false {
                                    let global = GlobalSwift.sharedManager
                                    if let user = global.curUser{
                                        //let manager = NetworkUtil.sharedManager
                                        let request = RequestLogin()
                                        request.setDefaultkeySecret()
                                        request.userid = user.userid
                                        request.phone = user.phoneno
                                        request.iso = self.inputData?.country_iso
                                        if request.iso == nil {
                                            request.iso = self.tblPurchaseDetail?.country_iso
                                        }
                                        request.days = numday_str
                                        request.purchase_id = self.inputData?.id
                                        if request.purchase_id == nil {
                                            request.purchase_id = self.tblPurchaseDetail?.id
                                        }
                                        
                                        self.requestTerm = request
                                        self.purchaseMyProduct(product: product)
                                        
                                        
                                    }
                                }
                            }
                            
                            // success
                            
                        }else{
                            
                        }
                    }else{
                        //CGlobal.alertMessage("Server Error", title: nil)
                    }
                    CGlobal.stopIndicator(self)
                }
            }
            
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    var loaded = false
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            if loaded {
                return
            }
            debugPrint("enter 1")
            self.iapProducts_all = response.products
            self.iapProducts_head = [SKProduct]();
            
            self.iapProducts_all.sort(by: { (first, second) -> Bool in
                var fir:Int = 0;
                var sec:Int = 0;
                if let firArray = GlobalSwift.getNumberDay(product: first) {
                    fir = firArray[0]*Constants.PRODUCT_ID_MULTI + firArray[1];
                }
                if let secArray = GlobalSwift.getNumberDay(product: second) {
                    sec = secArray[0]*Constants.PRODUCT_ID_MULTI + secArray[1];
                }
                return fir < sec
            });
            
            for i in 0..<self.iapProducts_all.count {
                let iproduct = self.iapProducts_all[i];
                if let firArray = GlobalSwift.getNumberDay(product: iproduct) {
                    //let day1 = firArray[0]
                    let day2 = firArray[1]
                    if day2 == 1 {
                        self.iapProducts_head.append(self.iapProducts_all[i])
                    }
                }
                
            }
            // 1st IAP Product (Consumable) ------------------------------------
            
            var height = CGFloat(50)*CGFloat(self.iapProducts_head.count);
            height = max(height, CGFloat(50))
            if let cons = self.constraint_ProductHeight {
                debugPrint("enter 2",cons)
                cons.constant = height
                
                stackProduct.setNeedsUpdateConstraints();
                stackProduct.layoutIfNeeded()
                
                debugPrint("enter 3",cons)
                for i in 0..<self.iapProducts_head.count {
                    if let view:PurchaseItemView = Bundle.main.loadNibNamed("PurchaseItemView", owner: self, options: nil)?[0] as? PurchaseItemView{
                        view.setData(firstProduct: self.iapProducts_head[i], i: i, vc: self,mode: 2)
                        stackProduct.addArrangedSubview(view)
                        
                        if i == self.iapProducts_head.count - 1 {
                            view.viewLineBottom.isHidden = false
                        }else{
                            view.viewLineBottom.isHidden = true
                        }
                    }
                }
                isLoadingPurchase = false;
                loaded = true
            }
            
            
            
        }
        
    }
    
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts_all = [SKProduct]()
    var iapProducts_head = [SKProduct]()
    func fetchAvailableProducts()  {
        
        if self.iapProducts_all.count <= 0 , isLoadingPurchase == false {
            // Put here your IAP Products ID's
            var arrays:[String] = [String]()
            for i in 1..<15{
                arrays.append(Constants.PRODUCT_ID_DAY + "7_\(i)")
                arrays.append(Constants.PRODUCT_ID_DAY + "14_\(i)")
            }
            let productIdentifiers = NSSet(array: arrays)
            
            isLoadingPurchase = true;
            self.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            self.productsRequest.delegate = self
            self.productsRequest.start()
        }
        
    }
    func inappInit(){
        // Check your In-App Purchases
        
        // Fetch IAP Products available
        self.fetchAvailableProducts()
        
        let request = RequestLogin()
        request.setDefaultkeySecret()
        request.iso = self.inputData?.country_iso
        if request.iso == nil {
            request.iso = self.tblPurchaseDetail?.country_iso
        }
        let manager = NetworkUtil.sharedManager
        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_GETPRICE) { (dict, error) in
            if error == nil {
                if let min = dict?["minutes"] as? Int{
                    self.lblPrice.text = "\(min)"
                }
            }else{
                
                //                CGlobal.alertMessage("Failed to Load", title: nil)
            }
            //            CGlobal.stopIndicator(self)
            //            self.isLoading = false
        }
    }
    
    @IBAction func restorePurchaseButt(_ sender: Any) {
        //        SKPaymentQueue.default().add(self)
        //        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    //        nonConsumablePurchaseMade = true
    //        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
    //
    //        UIAlertView(title: "IAP Tutorial",
    //                    message: "You've successfully restored your purchase!",
    //                    delegate: nil, cancelButtonTitle: "OK").show()
    //    }
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    func purchaseMyProduct(product: SKProduct) {
        debugPrint("purchase purchase--")
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            self.productID = product.productIdentifier
            
            // IAP Purchases dsabled on the Device
        } else {
            CGlobal.alertMessage("Purchases are disabled in your device!", title: nil)
        }
    }
    
    var isLoading:Bool = false
    var isLoadingPurchase:Bool = false
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        debugPrint("paymentQueue")
        if Constants.purchase_mode != 2 {
            return
        }
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumable product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID.hasPrefix(Constants.PRODUCT_ID_DAY) {
                        let index = productID.index(productID.startIndex, offsetBy: Constants.PRODUCT_ID_DAY.characters.count)
                        let numday_str = productID.substring(from: index)
                        if let numday = Int(numday_str){
                            self.requestTerm?.days = numday_str;
                            self.purchase1()
                        }
                    }
                    //                    else if productID == PREMIUM_PRODUCT_ID {
                    //
                    //                        // Save your purchase locally (needed only for Non-Consumable IAP)
                    //                        nonConsumablePurchaseMade = true
                    //                        UserDefaults.standard.set(nonConsumablePurchaseMade, forKey: "nonConsumablePurchaseMade")
                    //
                    //                        premiumLabel.text = "Premium version PURCHASED!"
                    //
                    //                        UIAlertView(title: "IAP Tutorial",
                    //                                    message: "You've successfully unlocked the Premium version!",
                    //                                    delegate: nil,
                    //                                    cancelButtonTitle: "OK").show()
                    //                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    func purchase1(){
        if let request = self.requestTerm{
            CGlobal.showIndicator(self)
            let manager = NetworkUtil.sharedManager
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_EXTEND) { (dict, error) in
                if error == nil {
                    let temp = LoginResponse.init(dictionary: dict)
                    if let status = temp.status {
                        if status == "success" {
                            CGlobal.alertMessage("You've successfully extend Day!", title: "Purchase")
                            
                            
                            // after success change data
                            if let vcs = self.navigationController?.viewControllers {
                                for i in 0..<vcs.count {
                                    if vcs[i] is PurchaseDetailViewController {
                                        self.navigationController?.popToViewController(vcs[i], animated: false);
                                        return
                                    }
                                }
                                self.navigationController?.popToRootViewController(animated: true);
                            }
                            
                        }else{
                            // fail
                            if let message = temp.message {
                                CGlobal.alertMessage(message, title: nil)
                            }
                        }
                    }else{
                        CGlobal.alertMessage("Failed to Load", title: nil)
                    }
                }else{
                    CGlobal.alertMessage("Failed to Load", title: nil)
                }
                CGlobal.stopIndicator(self)
                self.isLoading = false
            }
        }
    }
}
