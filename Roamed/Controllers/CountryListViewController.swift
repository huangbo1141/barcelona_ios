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
    var tblPurchaseDetail:TblPurchaseDetail?
    var purchase_id:String?
    
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        // Do any additional setup after loading the view.
    }
    var countryList:[TblCountry] = [TblCountry]()
    func initData(){
        if let data = self.data{
            lblCountry.text = data.country
            if let name = data.country_iso {
                let image = UIImage.init(named: name.lowercased())
                imgFlag.image = image;
            }
            self.purchase_id = data.id
        }else if let data = self.tblPurchaseDetail{
            lblCountry.text = data.country
            if let name = data.country_iso {
                let image = UIImage.init(named: name.lowercased())
                imgFlag.image = image;
            }
            self.purchase_id = data.id
        }
        let nib = UINib.init(nibName: "CountryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        self.loadData()
    }
    func loadData(){
        
        
        if let id = self.purchase_id{
            
            let request = RequestLogin()
            request.setDefaultkeySecret()
            request.purchase_id = id
            
            self.loadData_proc1(request: request)
        }
    }
    func loadData_proc1(request:RequestLogin){
        //                    request.divert_phone = "6597668866"
        let manager = NetworkUtil.sharedManager
        CGlobal.showIndicator(self)
        manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_COUNTRYISO) { (dict, error) in
            
            if error == nil {
                let response = CountryResponse.init(dictionary: dict)
                if let rows = response.countries, rows.count > 0 {
                    // success
                    self.countryList = rows
                    self.countryList.sort(by: { (first, second) -> Bool in
                        if let c1 = first.country, let c2 = second.country {
                            if(c1.compare(c2) == .orderedAscending){
                                return true;
                            }
                        }
                        return false
                    })
                    self.tableView.reloadData()
                }else{
                    
                }
            }else{
                //CGlobal.alertMessage("Server Error", title: nil)
            }
            CGlobal.stopIndicator(self)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        
        cell.setData(tblCountry: countryList[indexPath.row])
        return cell
    }
    let tableHeight:CGFloat = 50.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did select
        self.selectedData = countryList[indexPath.row]
        if let name = self.selectedData?.iso {
            let image = UIImage.init(named: name.lowercased())
            imgFlag.image = image
        }
        
        lblCountry.text = selectedData?.country
    }
    var selectedData:TblCountry?
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickChange(_ sender: Any) {
        //
        
        let global = GlobalSwift.sharedManager
        if let user = global.curUser, let purchase_id = self.purchase_id, let iso = self.selectedData?.iso{
            let manager = NetworkUtil.sharedManager
            let request = RequestLogin()
            request.setDefaultkeySecret()
            request.userid = user.userid
            request.phone = user.phoneno
            request.purchase_id = purchase_id
            request.country_iso = iso.lowercased()
            
            CGlobal.showIndicator(self)
            debugPrint(request)
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_CHANGECOUNTRY) { (dict, error) in
                
                if error == nil {
                    let response = LoginResponse.init(dictionary: dict)
                    if response.isSuccess() {
                        // success
                        CGlobal.alertMessage(response.message, title: nil)
                        // pop and refresh
                        DispatchQueue.main.async {
                            if let navc = self.navigationController {
                                if navc.viewControllers.count > 0 , let vc = navc.viewControllers[0] as? HomeViewController{
                                    //vc.getPurchased()
                                    navc.popToRootViewController(animated: true)
                                }
                                
                            }
                        }
                        
                    }else{
                        if let message = response.message {
                            CGlobal.alertMessage(message, title: nil)
                        }
                    }
                }else{
//                    CGlobal.alertMessage("Username or Password is incorrect", title: nil)
                    
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
