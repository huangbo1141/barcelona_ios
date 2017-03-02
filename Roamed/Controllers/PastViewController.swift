//
//  PastViewController.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class PastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "PastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let refreshControl:UIRefreshControl = UIRefreshControl.init()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(control:)), for: UIControlEvents.valueChanged)
        
        let global = GlobalSwift.sharedManager
        self.response = global.purchaseResponse
        // Do any additional setup after loading the view.
    }
    func refresh(control:UIRefreshControl){
        self.getPurchased()
        control.endRefreshing()
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
                    
                    global.purchaseResponse = PurchaseResponse.init(dictionary: dict)
                    self.response = global.purchaseResponse
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
        if let response = self.response, let present = response.past_purchase {
            return present.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PastTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PastTableViewCell
        if let response = self.response, let present = response.past_purchase {
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
