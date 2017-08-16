//
//  PurchaseViewController.swift
//  Roamed
//
//  Created by Twinklestar on 3/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,SKProductsRequestDelegate,SKPaymentTransactionObserver {

    
    
    @IBOutlet weak var constraint_ProductHeight: NSLayoutConstraint!
    @IBOutlet weak var stackProduct: UIStackView!
    @IBOutlet weak var lblLabel0: UILabel!
    @IBOutlet weak var txtDateFrom: UITextField!
//    @IBOutlet weak var txtDays: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblPrice2: UILabel!
    
//    @IBOutlet weak var btnPurchase: RoundCornerButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        btnPurchase.addTarget(self, action: #selector(PurchaseViewController.clickView(sender:)), for: .touchUpInside)
//        btnPurchase.tag = 100
        let date = Date.init()
        let datePicker = UIDatePicker.init()
        datePicker.datePickerMode = .date
        datePicker.date = date
        txtDateFrom.inputView = datePicker
        datePicker.addTarget(self, action: #selector(PurchaseViewController.handleDatePicker(sender:)), for: .valueChanged)
//        txtDays.isHidden = true
        
        let pickerview = UIPickerView.init()
        pickerview.delegate = self
        pickerview.dataSource = self
        txtCountry.inputView = pickerview
        
        
//        self.title = "Roamed"
        
        DispatchQueue.main.async {
            
            var gesture = UISwipeGestureRecognizer.init(target: self, action: #selector(CallHistoryViewController.swipeLeft(gesture:)))
            gesture.direction = .right
            self.view.addGestureRecognizer(gesture)
        }
        
        self.inappInit()
        self.loadCountry()
    }
    func swipeLeft(gesture:UISwipeGestureRecognizer){
        if let tabvc  = self.tabBarController {
            self.view.slideIn(fromLeft: 0.5, delegate: nil, bounds: CGRect.zero)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // your code here
                tabvc.selectedIndex = 1
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        Constants.purchase_mode = 1
    }
    func handleDatePicker(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtDateFrom.text = dateFormatter.string(from: sender.date)
    }
    
    var countryList:[TblCountry] = [TblCountry]()
    func loadCountry(){
        if countryList.count > 0 {
            return
        }
        let manager = NetworkUtil.sharedManager
        let request = RequestLogin()
        request.setDefaultkeySecret()
        
        //                    request.divert_phone = "6597668866"
        CGlobal.showIndicator(self)
        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_COUNTRYISO) { (dict, error) in
            
            if error == nil {
                let response = CountryResponse.init(dictionary: dict)
                if let rows = response.countries, rows.count > 0 {
                    // success
                    
                    self.countryList = rows
                    self.countryList.sort(by: { (first, second) -> Bool in
                        let str1 = first.country
                        let str2 = second.country
                        
                        if(str1?.compare(str2!) == .orderedAscending ){
                            return true
                        }
                        return false
                    })
                    if let picker = self.txtCountry.inputView as? UIPickerView{
                        picker.reloadAllComponents()
                    }
                }else{
                    
                }
            }else{
                //CGlobal.alertMessage("Server Error", title: nil)
            }
            CGlobal.stopIndicator(self)
        }
    }
    
    static func getTimeOffset(tz:TimeZone)->String{
        var seconds:Int = tz.secondsFromGMT()
        var sign = ""
        if seconds < 0 {
            seconds = -1*seconds
            sign = "-"
        }else{
            sign = "+"
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

    var requestTerm:RequestLogin?
    var days = ""
    func clickView(sender:UIView){
        let tag = sender.tag
        if  tag >= 400 {
            
            
//            self.goToNotificationSetController(purchase_id: "1")
//            return;
            
            let index = tag - 400
            //self.iapProducts.count
            
            if self.isLoading == false {
                let global = GlobalSwift.sharedManager
                if let user = global.curUser{
                    let manager = NetworkUtil.sharedManager
                    let request = RequestLogin()
                    request.setDefaultkeySecret()
                    request.userid = user.userid
                    request.phone = user.phoneno
                    request.iso = self.country?.iso
                    request.country = self.country?.country
//                    request.iso = "hk"
                    
                    request.days = self.productDays[index]
                    self.days = self.productDays[index]
                    if let picker = txtDateFrom.inputView as? UIDatePicker {
                        let date = picker.date
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        request.startdate  = dateFormatter.string(from: date)
                    }
                    
                    request.timezone = PurchaseViewController.getTimeOffset(tz: TimeZone.current)
                    
                    CGlobal.showIndicator(self)
                    manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_CHECKPURCHASE) { (dict, error) in
                        //            let loginResp = LoginResponse.init(dictionary: dict)
                        //            debugPrint(loginResp.response)
                        if error == nil {
                            let temp = LoginResponse.init(dictionary: dict)
                            if let status = temp.status{
                                if status == "success" {
                                    self.requestTerm = request
                                    let product = self.iapProducts[index]
                                    self.purchaseMyProduct(product: product)
                                    
                                    
                                    
                                    
                                }else{
                                    if let message = temp.message {
                                        CGlobal.alertMessage(message, title: nil)
                                    }
                                }
                            }
                        }else{
                            CGlobal.alertMessage("Failed to Request Purchase", title: nil)
                        }
                        CGlobal.stopIndicator(self)
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = self.countryList[row]
        
        return country.country
    }
    var country:TblCountry?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = self.countryList[row]
        txtCountry.text = country.country
        self.country = country
        
        let request = RequestLogin()
        request.setDefaultkeySecret()
        request.iso = country.iso;
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            iapProducts.sort(by: { (first, second) -> Bool in
                let fir = GlobalSwift.getNumberDay(product: first)
                let sec = GlobalSwift.getNumberDay(product: second)
                return fir < sec
            });
            
            iapProducts = iapProducts.filter({ (product) -> Bool in
                let num = GlobalSwift.getNumberDay(product: product)
                if num == 3 {
                    return false
                }
                return true
            })
            
            
            
            // 1st IAP Product (Consumable) ------------------------------------
            
            var height = CGFloat(50)*CGFloat(self.iapProducts.count);
            height = max(height, CGFloat(50))
            constraint_ProductHeight.constant = height
            stackProduct.setNeedsUpdateConstraints();
            stackProduct.layoutIfNeeded()
            self.productDays = [String]()
            
            for i in 0..<self.iapProducts.count {
                
                if let view:PurchaseItemView = Bundle.main.loadNibNamed("PurchaseItemView", owner: self, options: nil)?[0] as? PurchaseItemView{
                    view.setData(firstProduct: self.iapProducts[i], i: i, vc: self, mode: 1)
                    if let numStr = view.numStr{
                        stackProduct.addArrangedSubview(view)
                        
                        productDays.append(view.numStr!)
                        
                        if i == self.iapProducts.count - 1 {
                            view.viewLineBottom.isHidden = false
                        }else{
                            view.viewLineBottom.isHidden = true
                        }
                    }
                    
                }
            }
            
            
        }
        isLoadingPurchase = false;
    }
    var views:[PurchaseItemView] = [PurchaseItemView] ()
    var productDays = [String]()
    let PRODUCT_ID_DAY = "com.simpsy.roamed.daya"
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    func inappInit(){
        // Check your In-App Purchases
        
        // Fetch IAP Products available
        fetchAvailableProducts()
    }
    func fetchAvailableProducts()  {
        
        if self.iapProducts.count <= 0 , isLoadingPurchase == false {
            // Put here your IAP Products ID's
            var arrays:[String] = [String]()
            for i in 0..<100{
                arrays.append(PRODUCT_ID_DAY + "\(i)")
            }
            let productIdentifiers = NSSet(array: arrays)
            
            isLoadingPurchase = true;
            self.productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            self.productsRequest.delegate = self
            self.productsRequest.start()
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
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            self.productID = product.productIdentifier
            
            debugPrint("purchase purchase--")
            // IAP Purchases dsabled on the Device
        } else {
            CGlobal.alertMessage("Purchases are disabled in your device!", title: nil)
        }
    }
    
    var isLoading:Bool = false
    var isLoadingPurchase:Bool = false
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        debugPrint("paymentQueue")
        if Constants.purchase_mode != 1 {
            return
        }
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                debugPrint(trans.transactionState)
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // The Consumable product (10 coins) has been purchased -> gain 10 extra coins!
                    if productID.hasPrefix(PRODUCT_ID_DAY) {
                        let index = productID.index(productID.startIndex, offsetBy: PRODUCT_ID_DAY.characters.count)
                        let numday_str = productID.substring(from: index)
                        if let numday = Int(numday_str){
                            self.requestTerm?.days = numday_str;
                            self.purchase1()
                        }
                    }
                    
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default:
                    break
                }}}
    }
    func goToNotificationSetController(data:PresentPurchase?){
        let ms = UIStoryboard.init(name: "Main", bundle: nil);
        DispatchQueue.main.async {
            if let viewcon = ms.instantiateViewController(withIdentifier: "SetNotificationViewController") as? SetNotificationViewController {
                viewcon.inputData = data
                self.navigationController?.pushViewController(viewcon, animated: true)
            }
        }
        //PresentPurchase
    }
    func purchase1(){
        if let request = self.requestTerm{
            CGlobal.showIndicator(self)
            let manager = NetworkUtil.sharedManager
            
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_DOPURCHASE) { (dict, error) in
                if error == nil {
                    let temp = LoginResponse.init(dictionary: dict)
                    
                    
                    if let status = temp.status {
                        if status == "success" {
                            CGlobal.alertMessage("You've successfully bought \(self.days) Days!", title: "Purchase")
                            if let navc = self.navigationController as? SwiftNavViewController {
                                navc.downloadHelp(request1: request)
                            }
                            
                            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                            let context = delegate.persistentContainer.viewContext
                            if let obj = dict as? [String:AnyObject]{
                                let data = PresentPurchase(context:context)
                                BaseModel.parseResponse(data, dict: obj)
                                
                                delegate.saveContext()
                                debugPrint(data.country_iso)
                                self.goToNotificationSetController(data: data)
                            }
                            
                            // download help page
                            if let navc = self.navigationController as? SwiftNavViewController {
                                let request:RequestLogin =  RequestLogin()
                                request.country = self.country?.country
                                
                                navc.downloadHelp(request1: request)
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
