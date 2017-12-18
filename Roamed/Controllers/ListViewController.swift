//
//  ListViewController.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import MessageUI

class ListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,ViewDialogDelegate,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btnBack1: UIButton!
    @IBOutlet weak var btnBack2: UIButton!
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var txtSearch: RoundTextField!
    @IBOutlet weak var btnSearch: UIButton!
    
    @IBOutlet weak var imgTitle: UIImageView!
    var id:Int = 0
    
    @IBAction func tapSearch(_ sender: Any) {
        let visible = txtSearch.isHidden
        txtSearch.isHidden = !visible
    }
    var cellHeight:CGFloat = 0
    func setTitle(){
        let width = UIScreen.main.bounds.size.width
        cellHeight = width * 0.5
        self.txtSearch.placeholder = "Search"
        self.txtSearch.isHidden = true
        switch id {
            case 1:
            imgTitle.image = UIImage.init(named: "title_disco")
            break
            case 2:
            imgTitle.image = UIImage.init(named: "title_disco_gay")
            break
            case 3:
            imgTitle.image = UIImage.init(named: "title_escort")
            break
            case 4:
            imgTitle.image = UIImage.init(named: "title_club")
            break
            case 5:
            imgTitle.image = UIImage.init(named: "title_live")
            break
            case 6:
            imgTitle.image = UIImage.init(named: "title_latin")
            break
            case 7:
            imgTitle.image = UIImage.init(named: "title_swinger")
            break
            case 8:
            imgTitle.image = UIImage.init(named: "title_techo")
            break
            default:
            break
        }
        
        txtSearch.addTarget(self, action: #selector(ListViewController.textFieldDidChange(textField:)), for: .editingChanged)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        let nib1 = UINib.init(nibName: "CellType1TableViewCell", bundle: nil)
        let nib2 = UINib.init(nibName: "CellType2TableViewCell", bundle: nil)
        let nib3 = UINib.init(nibName: "CellType3TableViewCell", bundle: nil)
        tableview.register(nib1, forCellReuseIdentifier: "cell1")
        tableview.register(nib2, forCellReuseIdentifier: "cell2")
        tableview.register(nib3, forCellReuseIdentifier: "cell3")
        
        tableview.separatorStyle = .none
    }
    
    
    var items:[TblItem] = [TblItem]()
    var searchItems:[TblItem] = [TblItem]()
    func getClubs(){
        let request = RequestParam()
        request.setDefaultkeySecret()
        request.category_id = String.init(format: "%d", id)
        
        let manager = NetworkUtil.sharedManager
        CGlobal.showIndicator(self)
        manager.ontemplateGeneralRequest(data: request,method:.post, url: Constants.ACTION_GET_CLUB) { (dict, error) in
            
            if error == nil {
                let response = ClubResponse.init(dictionary: dict)
                self.items = response.items
                if self.items.count > 0 {
                    self.tableview.reloadData()
                }
                
            }else{
                //CGlobal.alertMessage("Server Error", title: nil)
            }
            CGlobal.stopIndicator(self)
        }
        
    }
    var isSearch = false
    @objc private func textFieldDidChange(textField:UITextField){
        if textField == txtSearch {
            if let str = textField.text {
                if str.characters.count == 0 {
                    isSearch = false
                    self.tableview.reloadData()
                }else{
                    isSearch = true
                    var tempItems = [TblItem]()
                    for i in 0..<self.items.count {
                        let item = self.items[i]
                        if let title = item.title {
                            if title.lowercased().contains(str) {
                                tempItems.append(item)
                            }
                        }
                    }
                    self.searchItems = tempItems
                    self.tableview.reloadData()
                }
            }else{
                isSearch = false
                self.tableview.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setTitle()
        self.getClubs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return self.searchItems.count
        }else{
            return self.items.count
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = TblItem()
        if isSearch {
            item = self.searchItems[indexPath.row]
        }else{
            item = self.items[indexPath.row]
        }
        var obj = [String:AnyObject]()
        obj["model"] = item
        obj["aDelegate"] = self
        if id == 3 {
            
            let cell:CellType2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CellType2TableViewCell
            cell.setData(data: obj as AnyObject)
            
            return cell
        }else if id == 4 {
            
            let cell:CellType3TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! CellType3TableViewCell
            
            cell.setData(data: obj as AnyObject)
            
            return cell
        }
        else{
            let cell:CellType1TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CellType1TableViewCell
            
            cell.setData(data: obj as AnyObject)
            
            return cell
        }
        
    }
    
    func didSubmit(obj: AnyObject, view: UIView) {
        let ms = UIStoryboard.init(name: "Main", bundle: nil);
        let dict = obj as! [String:Any]
        let model = dict["model"] as! TblItem
        if view.isKind(of: CellType1TableViewCell.self) {
            // normal
            DispatchQueue.main.async {
                let viewcon = ms.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController;
                viewcon.model = model
                if let navc = self.navigationController {
                    navc.pushViewController(viewcon, animated: true)
                }
            }
        }else if view.isKind(of: CellType2TableViewCell.self) {
            // id 3
            if let tag = dict["tag"] as? Int {
                if tag == 0 {
                    if let phone = model.phone {
                        if !phone.contains("@") && phone.contains("+"){
                            GlobalSwift.callNumber(phone: phone)
                        }else if phone.contains("@"){
                            let mailComposeViewController = self.configuredMailComposeViewController(mail: phone)
                            if MFMailComposeViewController.canSendMail() {
                                self.present(mailComposeViewController, animated: true, completion: nil)
                            } else {
                                self.showSendMailErrorAlert()
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        // open safari
                        if let urlstr = model.phone,
                            urlstr.contains("http"),
                            let url = URL(string: urlstr) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                }
            }
            
           
        }
        else if view.isKind(of: CellType3TableViewCell.self) {
            // id 4
            if let phone = model.phone {
                if !phone.contains("@") && phone.contains("+"){
                    
                    GlobalSwift.callNumber(phone: phone)
                }else if phone.contains("@"){
                    let mailComposeViewController = self.configuredMailComposeViewController(mail: phone)
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                }else if phone.contains("."){
                    let url = URL(string: "http://" + phone)
                    UIApplication.shared.open(url!, options: [:])
                }
            }
            
        }
    }
    
    func configuredMailComposeViewController(mail:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([mail])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    func didCancel(view: UIView) {
        
    }

}
