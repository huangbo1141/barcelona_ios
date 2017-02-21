//
//  PurchaseDetailViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class PurchaseDetailViewController: UIViewController {

    var inputData:PresentPurchase?
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var txtInputNumber: UITextField!
    @IBOutlet weak var btnDivert: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnChange.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
        btnDivert.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
        btnChange.tag = 100
        btnDivert.tag = 101
        
        if let navc = self.navigationController {
            let button: UIButton = UIButton.init(type: .custom)
            //set image for button
            button.setImage(UIImage.init(named: "ico_help.png"), for: .normal)
            
            //add function for button
            button.addTarget(self, action: #selector(PurchaseDetailViewController.clickView(sender:)), for: .touchUpInside)
            
            //set frame
            button.frame = CGRect.init(x: 0, y: 0, width: 53, height: 31)
            button.tag = 200
            
            let barButton = UIBarButtonItem(customView: button)
            
            
            self.navigationItem.rightBarButtonItems = [barButton]
        }
        // Do any additional setup after loading the view.
    }

    func initViews(){
        
    }
    func clickView(sender:UIView){
        let tag = sender.tag
        switch tag {
        case 200:
            if let data = self.inputData,let webcode = data.country_iso{
                let ms = UIStoryboard.init(name: "Main", bundle: nil);
                DispatchQueue.main.async {
                    let viewcon = ms.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
                    let iso = webcode.replacingOccurrences(of: " ", with: "+")
                    viewcon.iso = iso
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
            
            break
        case 101:
            // divert code
            if let inputData = self.inputData, checkValidate() {
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
                            CGlobal.alertMessage("Username or Password is incorrect", title: nil)
                            
                        }
                        CGlobal.stopIndicator(self)
                    }
                }
            }
        default:
            break
        }
    }
    func checkValidate()->Bool{
        guard let text = txtInputNumber.text, !text.isEmpty else {
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
