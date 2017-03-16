//
//  SetNotificationViewController.swift
//  Roamed
//
//  Created by Twinklestar on 3/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class SetNotificationViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var inputData:PresentPurchase?
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtTimezone: UITextField!
    @IBOutlet weak var btnSet: RoundCornerButton!

    
    lazy var timeZoneAbbreviations:[String:String] = TimeZone.abbreviationDictionary
    
    var list_abb:[String] = [String]()
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
            
            for (key,value) in self.timeZoneAbbreviations {
                self.list_abb.append(key)
                self.list_val.append(value)
            }
            
            let pkview = UIPickerView.init()
            pkview.delegate = self
            pkview.dataSource = self
            self.txtTimezone.inputView = pkview
            
        }
        // Do any additional setup after loading the view.
    }
    func clickView(sender:UIView){
        let tag = sender.tag
        switch tag {
        case 100:
            let global = GlobalSwift.sharedManager
            if let user = global.curUser,let index = self.index{
                let abb = list_abb[index]
                let timezone = TimeZone.init(abbreviation: abb)
                
                let manager = NetworkUtil.sharedManager
                let request = RequestLogin()
                request.setDefaultkeySecret()
                request.userid = user.userid
                request.phone = user.phoneno
                request.purchase_id = self.inputData?.id
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
        format.dateFormat = "HH:mm:ss"
        txtTime.text = format.string(from: sender.date)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
