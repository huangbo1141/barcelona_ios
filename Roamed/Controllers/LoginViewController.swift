//
//  LoginViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/20/17.
//  Copyright © 2017 SIMPSY LLP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    
    
    @IBOutlet weak var imgLogo1: UIImageView!
    
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var btnVerify: RoundCornerBorderButton!
    
    
    @IBOutlet weak var txtVerifyCode: CustomTextField!
    var country:TblCountry?
    
    
    @IBOutlet weak var btnLogin: UIButton!
    
    var apiCount = 0;
    var showProgress = true
    
    var step:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("Login ViewDidload")
        
        // Do any additional setup after loading the view.
        
        btnLogin.addTarget(self, action: #selector(LoginViewController.ClickView(view:)), for: .touchUpInside);
        btnLogin.tag = 200;
        
        btnVerify.addTarget(self, action: #selector(LoginViewController.ClickView(view:)), for: .touchUpInside);
        btnVerify.tag = 201;
        
        if showProgress {
            NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.loginFail), name: Notification.Name(Constants.GLOBALNOTIFICATION_RECEIVE_USERINFO_FAIL), object: nil)
            CGlobal.showIndicator(self)
        }
        self.setStep(num: 0)
        
        self.view1.backgroundColor = UIColor.clear
        self.view0.backgroundColor = UIColor.clear
        
        
//        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
//        
//        if let data = appdelegate.dbManager?.getCountries(){
//            for item in data {
//                if let idata = item as? WNACountry {
//                    self.countryData.append(idata)
//                }
//            }
//        }
        DispatchQueue.main.async {
            self.initCountryData()
        }
    }
    
    func initCountryData(){
        let manager = NetworkUtil.sharedManager
        let request = RequestLogin()
        request.setDefaultkeySecret()
        
        CGlobal.showIndicator(self)
        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_REG_COUNTRY) { (dict, error) in
            
            if error == nil {
                let response = CountryResponse.init(dictionary: dict)
                if let rows = response.countries, rows.count > 0 {
                    // success
                    self.countryData = rows
                    let pkview = UIPickerView.init()
                    pkview.delegate = self
                    pkview.dataSource = self
                    self.txtCountry.inputView = pkview;
                }else{
                    self.initCountryData()
                }
            }else{
                //CGlobal.alertMessage("Server Error", title: nil)
                self.initCountryData()
            }
            CGlobal.stopIndicator(self)
        }
    }
    var countryData = [TblCountry]()
    func setStep(num:Int){
        let views = [view0,view1];
        guard num>=0, num<views.count else{
            return
        }
        self.step = num
        view0.isHidden = true
        view1.isHidden = true
        views[num]?.isHidden = false
    }
    
    func loginFail(){
        CGlobal.stopIndicator(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }
    func ClickView(view:UIView){
        let tag = view.tag;
        switch tag {
        
        case 201:
            if let code = txtVerifyCode.text, !code.isEmpty,let resp = self.mLoginResponse {
                // check code
                if code == resp.verification_code {
                    //CGlobal.alertMessage("Code is Correct", title: nil)
                    UserDefaults.standard.set(self.muser?.name!, forKey: "name")
                    resp.country_iso = self.country?.iso
                    resp.country = self.country?.country
                    let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.goMainWindow(data: resp)
                }else{
                    CGlobal.alertMessage("Code is Incorrect", title: nil)
                }
            }
            break;
        case 200:
            if self.checkValidate() {
                
                apiCount = 0
                if let data = self.requestData {
                    self.callApiLogin(user: data)
                }
                
            }else{
                //
                
            }
            
            break;
        case 300:
            let ms = UIStoryboard.init(name: "Main", bundle: nil);
            
            DispatchQueue.main.async {
                let viewcon = ms.instantiateViewController(withIdentifier: "SignupViewController");
                self.navigationController?.pushViewController(viewcon, animated: true)
            }
            break;
        case 301:
            
            break;
        default:
            break
        }
    }
    var requestData:RequestLogin?
    func checkValidate()->Bool{
        guard let name = txtName.text, !name.isEmpty else {
            CGlobal.alertMessage("Input Name", title: nil)
            return false
        }
        guard let phone = txtPhone.text, !phone.isEmpty else {
            CGlobal.alertMessage("Input Phone", title: nil)
            return false
        }
        guard let cnt = self.country else {
            CGlobal.alertMessage("Input Country", title: nil)
            return false
        }
        let data = RequestLogin()
        data.setDefaultkeySecret()
        data.country = cnt.iso
        data.phone = phone
        data.name = name
        
        self.requestData = data
        return true;
    }
    var mLoginResponse:LoginResponse?
    var muser:RequestLogin?
    func callApiLogin(user:RequestLogin){
        let manager = NetworkUtil.sharedManager
        
        CGlobal.showIndicator(self)
        user.country = "sg"
        user.phone = "92997764"
        manager.ontemplateGeneralRequest(data: user,method:.get, url: Constants.ACTION_LOGIN) { (dict, error) in
            //            let loginResp = LoginResponse.init(dictionary: dict)
            //            debugPrint(loginResp.response)
            if error == nil {
                let loginResp = LoginResponse.init(dictionary: dict)
                let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate;
                
                if loginResp.isSuccess() {
                    self.muser = user
                    self.mLoginResponse = loginResp
                    self.setStep(num: 1)
                    
                }else{
                    if let message = loginResp.message {
                        CGlobal.alertMessage(message, title: nil)
                    }
                }
//
//                // phone verified 
//                delegate.goMainWindow(data: loginResp)
                
            }else{
                CGlobal.alertMessage("Username or Password is incorrect", title: nil)
                
            }
            CGlobal.stopIndicator(self)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data = self.countryData[row]
        return data.country
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = self.countryData[row]
        txtCountry.text = country.country
        self.country = country
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.setStep(num: 0)
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
