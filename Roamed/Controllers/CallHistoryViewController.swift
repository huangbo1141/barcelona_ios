//
//  CallHistoryViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class CallHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib.init(nibName: "CallHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var modelDatas:[CallModel] = [CallModel]()
    var pageIndex:Int = 0
    func loadData(){
        let global = GlobalSwift.sharedManager
        if let user = global.curUser{
            let manager = NetworkUtil.sharedManager
            let request = RequestLogin()
            request.setDefaultkeySecret()
            request.userid = user.userid
            request.phone = user.phoneno
            request.next = String(pageIndex)
            
            CGlobal.showIndicator(self)
            manager.ontemplateGeneralRequest(data: request,method:.get, url: Constants.ACTION_CALLLIST) { (dict, error) in
                //            let loginResp = LoginResponse.init(dictionary: dict)
                //            debugPrint(loginResp.response)
                if error == nil {
                    let temp = CallResponse.init(dictionary: dict)
                    if let calls = temp.calls {
                        self.modelDatas.append(contentsOf: calls)
                        self.tableView.reloadData()
                        self.pageIndex = self.pageIndex + 1
                    }
                    
                    
                }else{
                    CGlobal.alertMessage("Failed to Load", title: nil)
                    
                }
                CGlobal.stopIndicator(self)
            }
        }
        
    }
    var arrowUp = 0
    var arrowDown = 0
    var scrollViewSize:CGSize?
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if let scrollViewSize = scrollViewSize {
            if offset.y < 0 {
                arrowUp = arrowUp + 1
                debugPrint(" we are at the top")
                if arrowUp >= 1 {
                    arrowUp = 0
                    
                }
            }else{
                let bottomEdge = offset.y + scrollViewSize.height;
                let contentHeight = scrollView.contentSize.height
                let p = max(contentHeight,scrollViewSize.height)
                if (bottomEdge >= p && offset.y>0) {
                    debugPrint(" we are at the end")
                    arrowDown = arrowDown + 1
                    if arrowDown >= 1 {
                        arrowDown = 0
                        self.loadData()
                    }
                }
            }
            
            debugPrint("scrollViewDidEndDecelerating")
            debugPrint(offset.y)
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CallHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CallHistoryTableViewCell
        cell.setData(data: modelDatas[indexPath.row])
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