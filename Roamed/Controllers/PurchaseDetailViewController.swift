//
//  PurchaseDetailViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import ReachabilitySwift
import CoreData

class PurchaseDetailViewController: UIViewController {
    
    @IBOutlet weak var lblSetting: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var lblDaysLeft: UILabel!
    var inputData:PresentPurchase?
    
    var purchase_id:String?
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtInputNumber: UITextField!
    
    @IBOutlet weak var lblMinutesLeft: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBOutlet weak var btnDivert: UIButton!
    
    @IBOutlet weak var lblDivert: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnChange.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
        btnDivert.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
        btnCopy.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
        
        btnChange.tag = 100
        btnDivert.tag = 101
        btnCopy.tag = 102
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(PurchaseDetailViewController.clickGesture(gesture:)));
        
        if let navc = self.navigationController {
            let button: UIButton = UIButton.init(type: .custom)
            //set image for button
            button.setImage(UIImage.init(named: "simcard"), for: .normal)
            
            //add function for button
            button.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
            
            //set frame
            button.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            button.tag = 200
            
            let barButton = UIBarButtonItem(customView: button)
            
            
            self.navigationItem.rightBarButtonItems = [barButton]
        }
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func indexChanged(_ sender: Any) {
        if let sender = sender as? UISegmentedControl {
            switch sender.selectedSegmentIndex {
            case 0:
                view0.isHidden = false
                view1.isHidden = true
                break
            case 1:
                view0.isHidden = true
                view1.isHidden = false
                break
            case 2:
                view0.isHidden = true
                view1.isHidden = true
                
                let ms = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = ms.instantiateViewController(withIdentifier: "ExtendViewController") as! ExtendViewController
                vc.inputData = self.inputData
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true);
                    //                    self.present(vc, animated: true, completion: nil)
                    self.segControl.selectedSegmentIndex = 1
                    self.view0.isHidden = true
                    self.view1.isHidden = false
                }
                break
                
            default:
                break
            }
        }
    }
    
    func initData(){
        if let data = self.inputData {
            
            
            self.purchase_id = data.id
            //            if let navc = self.navigationController as? SwiftNavViewController {
            //                let req = RequestLogin.init()
            //                req.country = data.country
            //                navc.downloadHelp(request1: req);
            //            }
        }
        self.getRequiredInfo()
        
    }
    func getRequiredInfo(){
        //PurchaseDetailResponse
        let global = GlobalSwift.sharedManager
        let reach = Reachability()!
        
        if let dataid = self.purchase_id ,let user = global.curUser{
            if reach.isReachableViaWiFi{
                let manager = NetworkUtil.sharedManager
                let request = RequestLogin()
                request.setDefaultkeySecret()
                request.userid = user.userid
                request.phone = user.phoneno
                request.purchase_id = dataid
                
                //                    request.divert_phone = "6597668866"
                CGlobal.showIndicator(self)
                manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_GET_PURCHASE) { (dict, error) in
                    
                    if error == nil {
                        let response = PurchaseDetailResponse.init(dictionary: dict)
                        self.showResult(response: response, user: user)
                    }else{
                        //CGlobal.alertMessage("Server Error", title: nil)
                    }
                    CGlobal.stopIndicator(self)
                }
            }else{
                if let tblid = self.purchase_id {
                    let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = delegate.persistentContainer.viewContext
                    
                    let fetch = NSFetchRequest<PurchaseDetail>(entityName: "PurchaseDetail")
                    fetch.predicate = NSPredicate.init(format: " id == '" + tblid + "'");
                    
                    do {
                        let rows = try context.fetch(fetch)
                        //            let rows = try context.fetch(HelpModel.fetchRequest())
                        if rows.count>0 {
                            let response = PurchaseDetailResponse.init()
                            var temp = [TblPurchaseDetail]()
                            for i in 0..<rows.count {
                                let detail = TblPurchaseDetail.init()
                                debugPrint(rows[i].country_iso)
                                debugPrint(rows[i].divert_message)
                                
                                BaseModel.copyValues(detail, source: rows[i])
                                temp.append(detail)
                            }
                            response.present_purchase = temp
                            self.showResult(response: response, user: user)
                        }
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                    
                }
            }
        }
        
    }
    func showResult(response:PurchaseDetailResponse,user:User){
        if let rows = response.present_purchase, rows.count > 0 {
            // success
            let row:TblPurchaseDetail  = rows[0]
            
            self.purchaseDetail = row
            
            let data:TblPurchaseDetail = row;
            if let name = data.country_iso {
                let image = UIImage.init(named: name)
                imgFlag.image = image;
            }
            
            if let country = data.country {
                txtInputNumber.placeholder = "Input \(country) Number";
            }
            
            lblCountry.text = data.country
            
            lblStartDate.text = row.start_date
            lblDaysLeft.text = row.days_left
            lblMinutesLeft.text = row.minutes_left
            if let country = user.country,let divert_number = row.divert_number ,divert_number.characters.count > 0 {
                
                let title = "Divert your \(country) number to \(divert_number)"
                
                //self.btnDivert.setTitle(title, for: .normal)
                self.lblDivert.text = title
                self.txtInputNumber.text = row.divert_phone
                btnCopy.isHidden = false
                lblSetting.isHidden = false
            }else{
                if let message = row.divert_message {
                    
                    self.lblDivert.text = message
                }
                
                // hide the message part
                btnCopy.isHidden = true
                lblSetting.isHidden = true
            }
        }else{
            
        }
    }
    var purchaseDetail:TblPurchaseDetail?
    func clickGesture(gesture:UITapGestureRecognizer){
        if let sender = gesture.view {
            self.clickView(sender:sender)
        }
    }
    func clickView(sender:UIView){
        let tag = sender.tag
        switch tag {
        case 200:
            if let data = self.inputData,let country = data.country{
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                DispatchQueue.main.async {
                    let viewcon = ms.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                    let iso = country.replacingOccurrences(of: " ", with: "+")
                    viewcon.iso = iso
                    viewcon.country =  country
                    if let navc = self.navigationController {
                        navc.pushViewController(viewcon, animated: true)
                    }
                }
            }
            break
        case 100:
            // change code
            if let data = self.inputData{
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                DispatchQueue.main.async {
                    let viewcon = ms.instantiateViewController(withIdentifier: "CountryListViewController") as! CountryListViewController
                    viewcon.data = data
                    if let navc = self.navigationController {
                        navc.pushViewController(viewcon, animated: true)
                    }
                }
            }
        case 102:
            // open setting
            
            UIPasteboard.general.string = self.purchaseDetail?.divert_number
            // call forwarding
            
            //            if let detail = self.purchaseDetail , let number = detail.divert_number , !number.isEmpty{
            //                let phonenumber = "tel://" + number
            //                var url:URL? =  URL.init(string: phonenumber)
            //                if let url = url {
            //                    UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
            //                    UIApplication.shared.openURL(url)
            //                }
            //
            //
            //            }else{
            //
            //            }
            break
        case 101:
            // divert code
            if checkValidate() {
                if let inputData = self.inputData, let detail = self.purchaseDetail {
                    let divNum = txtInputNumber.text
                    let global = GlobalSwift.sharedManager
                    if let user = global.curUser{
                        let manager = NetworkUtil.sharedManager
                        let request = RequestLogin()
                        request.setDefaultkeySecret()
                        request.userid = user.userid
                        request.phone = user.phoneno
                        request.purchase_id = inputData.id
                        request.divert_phone = divNum
                        
                        //                    request.divert_phone = "6597668866"
                        CGlobal.showIndicator(self)
                        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_DIVERT) { (dict, error) in
                            
                            if error == nil {
                                let response = LoginResponse.init(dictionary: dict)
                                if response.isSuccess() {
                                    // success
                                    CGlobal.alertMessage(response.message, title: nil)
                                }else{
                                    if let message = response.message {
                                        CGlobal.alertMessage(message, title: nil)
                                    }
                                }
                            }else{
                                CGlobal.alertMessage("Server Error", title: nil)
                                
                            }
                            CGlobal.stopIndicator(self)
                        }
                    }
                }
            }
            
        default:
            break
        }
    }
    func checkValidate()->Bool{
        guard let text = txtInputNumber.text, !text.isEmpty else {
            if let text = txtInputNumber.placeholder{
                CGlobal.alertMessage(text, title: nil)
            }
            
            return false
        }
        return true
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
    
}
