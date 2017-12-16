//
//  DetailViewController.swift
//  Roamed
//
//  Created by Huang Bo on 12/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage
import MessageUI

class DetailViewController: UIViewController {

    var model:TblItem?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblInclude: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewSchedule: UIView!
    
    
    
    
    @IBOutlet weak var imgContent: UIImageView!
    
    @IBAction func tapMapView(_ sender: Any) {
    }
    
    @IBAction func tapCall(_ sender: Any) {
        if let phone = self.model?.phone{
            if !phone.contains("@") && phone.contains("+"),let url = URL(string:"tel://" + phone){
                
                UIApplication.shared.open(url, options: [:])
            }else if phone.contains("@"){
                let mailComposeViewController = self.configuredMailComposeViewController(mail: phone)
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            }
        }
        
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initSchedule()
        initMap()
    }
    func initView(){
        if let item = self.model {
            lblTitle.text = item.title
            lblInclude.text = item.include
            lblDescription.text = item.ddescription
            
            if let image = item.image2 {
                let photopath = GlobalSwift.getPhotoPath(filename: image)
                let url = URL(string:photopath)
                let image = UIImage.init(named: "placeholder.png")
                self.imgContent.sd_setImage(with: url, placeholderImage: image)
                
            }
            if let location = item.location, location.utf8CString.count > 0 {
                lblLocation.text = item.location
            }
            if let phone = item.phone,phone.utf8CString.count>0 {
                if phone.contains("+") || phone.contains("@"){
                    self.btnCall.setTitle("Reservation "+phone, for: .normal)
                    if(phone.contains("@")){
                        self.btnCall.setTitle(phone, for: .normal)
                    }
                }else{
                    viewPhone.isHidden = true
                }
            }
        }
    }
    func initSchedule(){
        if let item = self.model{
            if item.schedule.count>0 {
                var text = "";
                for i in 0..<item.schedule.count {
                    let time = item.schedule[i]
                    if let title = time.title {
                        text = text + title + "\n"
                    }
                }
                self.lblSchedule.text = text
            }else{
                self.viewSchedule.isHidden = true
            }
        }
    }
    func initMap(){
//        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.settings.compassButton = false
        
        
        var lat = 35.89093
        var lng = -106.324907
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let location = appDelegate.location {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
        }
        
        let marker = GMSMarker.init()
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        marker.title = ""
        let camera = GMSCameraPosition.init(target: marker.position, zoom: 2.0, bearing: 0, viewingAngle: 0)
        mapView.camera = camera
        marker.map = self.mapView
        
        
    }
    var marker:GMSMarker?

    
    
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
