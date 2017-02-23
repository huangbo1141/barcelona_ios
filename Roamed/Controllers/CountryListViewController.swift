//
//  CountryListViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class CountryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var data:PresentPurchase?
    
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        // Do any additional setup after loading the view.
    }
    var countryList:NSMutableArray?
    func initData(){
        if let data = self.data{
            lblCountry.text = data.country
            if let name = data.country_iso {
                let image = UIImage.init(named: name.lowercased())
                imgFlag.image = image;
            }
        }
        let nib = UINib.init(nibName: "CountryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        countryList = delegate.dbManager?.getCountries()
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let countryList = countryList {
            return countryList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        if let countryList = self.countryList{
            if let data = countryList[indexPath.row] as? WNACountry {
                cell.setData(data: data)
            }
        }
        return cell
    }
    let tableHeight:CGFloat = 50.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did select
        if let countryList = self.countryList{
            if let data = countryList[indexPath.row] as? WNACountry {
                self.selectedData = data
            }
        }
    }
    var selectedData:WNACountry?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickChange(_ sender: Any) {
        //
        
        let global = GlobalSwift.sharedManager
        if let user = global.curUser, let inputData = self.data, let selectedData = self.selectedData{
            let manager = NetworkUtil.sharedManager
            let request = RequestLogin()
            request.setDefaultkeySecret()
            request.userid = user.userid
            request.phone = user.phoneno
            request.purchase_id = inputData.id
            request.country_iso = selectedData.webCode.lowercased()
            
            CGlobal.showIndicator(self)
            debugPrint(request)
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_CHANGECOUNTRY) { (dict, error) in
                
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
