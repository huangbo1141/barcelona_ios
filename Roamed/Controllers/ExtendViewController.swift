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
    @IBOutlet weak var lblCountry: ColoredLabel!
    
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
            
        }
        self.title = "Roamed"
        self.inappInit()
    }
    
    var requestTerm:RequestLogin?
    func clickView(sender:UIView){
        let tag = sender.tag
        if  tag >= 400 {
            let index = tag - 400
            let days:[String] = ["1"]
            if self.isLoading == false {
                let global = GlobalSwift.sharedManager
                if let user = global.curUser{
                    let manager = NetworkUtil.sharedManager
                    let request = RequestLogin()
                    request.setDefaultkeySecret()
                    request.userid = user.userid
                    request.phone = user.phoneno
                    request.iso = self.inputData?.country_iso
                    request.days = days[index]
                    request.purchase_id = self.inputData?.id
                    
                    self.requestTerm = request
                    let product = self.iapProducts[index]
                    self.purchaseMyProduct(product: product)
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
    
    @IBOutlet weak var lblDay1: UILabel!
    @IBOutlet weak var lblPrice1: UILabel!
    @IBOutlet weak var btnPurchase1: UIButton!
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        CGlobal.stopIndicator(self)
        if (response.products.count > 0) {
            iapProducts = response.products
            
            // 1st IAP Product (Consumable) ------------------------------------
            let lbldays:[UILabel] = [lblDay1]
            let lblprices:[UILabel] = [lblPrice1]
            let btnPurchases:[UIButton] = [btnPurchase1]
            
            for i in 0..<self.iapProducts.count {
                
                let firstProduct = self.iapProducts[i]
                // Get its price from iTunes Connect
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = firstProduct.priceLocale
                let price1Str = numberFormatter.string(from: firstProduct.price)
                
                // Show its description
                
                //let title = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
                lbldays[i].text = firstProduct.localizedDescription
                lblprices[i].text = price1Str
                // ------------------------------------------------
                
                let btn = btnPurchases[i]
                btn.addTarget(self, action: #selector(PurchaseViewController.clickView(sender:)), for: .touchUpInside)
                btn.tag = 400 + i
                
            }
            
        }
    }
    
    let PRODUCT_ID_DAY1 = "com.simpsy.roamed.day1"
    let PRODUCT_ID_DAY2 = "com.simpsy.roamed.day2"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    func inappInit(){
        // Check your In-App Purchases
        
        // Fetch IAP Products available
        fetchAvailableProducts()
    }
    func fetchAvailableProducts()  {
        
        // Put here your IAP Products ID's
        CGlobal.showIndicator(self)
        let productIdentifiers = NSSet(objects:
            PRODUCT_ID_DAY1
        )
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
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
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumable product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID == PRODUCT_ID_DAY1 {
                        
                        if let request = self.requestTerm{
                            CGlobal.showIndicator(self)
                            let manager = NetworkUtil.sharedManager
                            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_EXTEND) { (dict, error) in
                                if error == nil {
                                    let temp = LoginResponse.init(dictionary: dict)
                                    if let status = temp.status {
                                        if status == "success" {
                                            CGlobal.alertMessage("You've successfully bought 1 Day!", title: "Purchase")
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
                        // The Non-Consumable product (Premium) has been purchased!
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
}
