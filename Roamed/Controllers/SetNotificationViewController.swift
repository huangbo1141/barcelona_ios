//
//  SetNotificationViewController.swift
//  Roamed
//
//  Created by Twinklestar on 3/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class SetNotificationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

//    var inputData:PresentPurchase?
    var purchase_id:String?
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtTimezone: UITextField!
    @IBOutlet weak var btnSet: RoundCornerButton!

    
    lazy var timeZoneAbbreviations:[String:String] = TimeZone.abbreviationDictionary
    
//    var list_abb:[String] = [String]()
    var list_val:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.btnSet.addTarget(self, action: #selector(SetNotificationViewController.clickView(sender:)), for: .touchUpInside)
            self.btnSet.tag = 100
            
            let picker = UIDatePicker.init()
            picker.date = Date.init()
            picker.datePickerMode = .time
            self.txtTime.inputView = picker
            picker.addTarget(self, action: #selector(SetNotificationViewController.handleDate(sender:)), for: .valueChanged)
            
            var temp:[TblCountry] = [TblCountry]()
            
            
            for (key,value) in self.timeZoneAbbreviations {
                let country = TblCountry()
                country.iso = key
                country.country = value
                temp.append(country)
//                self.list_abb.append(key)
//                self.list_val.append(value)
            }
            temp.sort(by: { (first, second) -> Bool in
                if let c1 = first.country,let c2 = second.country {
                    if c1.compare(c2) == .orderedAscending {
                        return true
                    }
                }
                return false
            })
            
            for i in 0..<temp.count {
                let country = temp[i]
                if let key = country.iso, let value = country.country {
//                    self.list_abb.append(key)
                    self.list_val.append(value)
                }
            }
            
            let pkview = UIPickerView.init()
            pkview.delegate = self
            pkview.dataSource = self
            self.txtTimezone.inputView = pkview
            
            let ident = TimeZone.current.identifier
            if let index = self.list_val.index(of: ident){
                let val = self.list_val[index]
                self.txtTimezone.text = val
                self.index = index
            }else{
                self.list_val.append(ident)
                self.list_val.sort(by: { (c1, c2) -> Bool in
                    if c1.compare(c2) == .orderedAscending {
                        return true
                    }
                    return false
                })
                if let index = self.list_val.index(of: ident){
                    let val = self.list_val[index]
                    self.txtTimezone.text = val
                    self.index = index
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    func clickView(sender:UIView){
        let tag = sender.tag
        switch tag {
        case 100:
            let global = GlobalSwift.sharedManager
            if let user = global.curUser,let index = self.index{
//                let abb = list_abb[index]
//                let timezone = TimeZone.init(abbreviation: abb)
                let timezone = TimeZone.init(identifier: list_val[index])
                
                let manager = NetworkUtil.sharedManager
                let request = RequestLogin()
                request.setDefaultkeySecret()
                request.userid = user.userid
                request.phone = user.phoneno
                request.purchase_id = self.purchase_id
                request.timezone = GlobalSwift.getTimeOffset(tz: timezone!)
                if let datepicker = txtTime.inputView as? UIDatePicker{
                    let formatter = DateFormatter.init()
                    formatter.dateFormat = "HH:mm:ss"
                    request.time = formatter.string(from: datepicker.date)
                }
                
                CGlobal.showIndicator(self)
                manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_SETNOTI) { (dict, error) in
                    //            let loginResp = LoginResponse.init(dictionary: dict)
                    //            debugPrint(loginResp.response)
                    if error == nil {
                        let temp = LoginResponse.init(dictionary: dict)
                        if let status = temp.status{
                            if status == "success" {
                                if let message = temp.message {
                                    CGlobal.alertMessage(message, title: nil)
                                    // go to detail
                                    let ms = UIStoryboard.init(name: "Main", bundle: nil);
                                    DispatchQueue.main.async {
                                        let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                                        viewcon.purchase_id = self.purchase_id
                                        self.navigationController?.pushViewController(viewcon, animated: true)
                                    }
                                }
                                
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
            break
        default:
            break
        }
    }
    func handleDate(sender:UIDatePicker){
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        txtTime.text = format.string(from: sender.date)
    }
    func handlePicker(sender:UIPickerView){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.list_val.count
    }
    
    var index:Int?
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.index = row
        return self.list_val[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
        txtTimezone.text = self.list_val[row]
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
