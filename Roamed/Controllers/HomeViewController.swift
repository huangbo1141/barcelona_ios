//
//  HomeViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "PurchaseTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        getPurchased()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var response:PurchaseResponse?
    func getPurchased(){
        let global = GlobalSwift.sharedManager
        if let user = global.curUser{
            let manager = NetworkUtil.sharedManager
            let request = RequestLogin()
            request.setDefaultkeySecret()
            request.userid = user.userid
            request.phone = user.phoneno
            
            CGlobal.showIndicator(self)
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_GET_PURCHASE) { (dict, error) in
                //            let loginResp = LoginResponse.init(dictionary: dict)
                //            debugPrint(loginResp.response)
                if error == nil {
                    self.response = PurchaseResponse.init(dictionary: dict)
                    self.tableView.reloadData()
                }else{
                    CGlobal.alertMessage("Username or Password is incorrect", title: nil)
                    
                }
                CGlobal.stopIndicator(self)
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let response = self.response, let present = response.present_purchase {
            return present.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PurchaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseTableViewCell
        if let response = self.response, let present = response.present_purchase {
            cell.setData(data: present[indexPath.row])
        }
        return cell
    }
    let tableHeight:CGFloat = 50.0
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableHeight;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // did select
        if let response = self.response, let present = response.present_purchase {
            let ms = UIStoryboard.init(name: "Main", bundle: nil);
            DispatchQueue.main.async {
                let viewcon:PurchaseDetailViewController = ms.instantiateViewController(withIdentifier: "PurchaseDetailViewController") as! PurchaseDetailViewController;
                viewcon.inputData = present[indexPath.row]
                self.navigationController?.pushViewController(viewcon, animated: true)
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
