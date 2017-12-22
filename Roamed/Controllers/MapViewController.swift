//
//  MapViewController.swift
//  Roamed
//
//  Created by Huang Bo on 12/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import GoogleMaps
class MapViewController: UIViewController {

    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    var mode = 0
    var lat = 40.42
    var lng = -3.7
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initView(){
        if mode == 1{
            self.viewTitle.isHidden = true
            
            let marker = GMSMarker.init()
            marker.position = CLLocationCoordinate2DMake(lat, lng)
            marker.title = ""
            let camera = GMSCameraPosition.init(target: marker.position, zoom: Constants.zoom_level, bearing: 0, viewingAngle: 0)
            mapView.camera = camera
            marker.map = self.mapView
        }else if mode == 2 {
            let delegate = UIApplication.shared.delegate as! AppDelegate
            if let loc = delegate.location {
                self.lat =  loc.coordinate.latitude
                self.lng =  loc.coordinate.longitude
            }
            print("location: ",self.lat,self.lng)
            
            let camera = GMSCameraPosition.init(target: CLLocationCoordinate2DMake(lat, lng), zoom: Constants.zoom_level, bearing: 0, viewingAngle: 0)
            mapView.camera = camera
            self.viewTitle.isHidden = false
            self.getNearByList()
        }
    }
    
    //var pointList:[]
    func getNearByList(){
        let request = RequestParam()
        request.setDefaultkeySecret()
        request.lat = String.init(format: "%f", self.lat)
        request.lng = String.init(format: "%f", self.lng)
        
        let manager = NetworkUtil.sharedManager
        CGlobal.showIndicator(self)
        manager.ontemplateGeneralRequest(data: request,method:.post, url: Constants.ACTION_GET_NEARBY) { (dict, error) in
            
            if error == nil {
                let response = NearByResponse.init(dictionary: dict)
                var temp = [Any]()
                for i in 0..<response.items.count {
                    let item = response.items[i]
                    if let lat = item.lat, let lng = item.lng,let lat_v = Double(lat), let lng_v = Double(lng) {
                        let pt = CLLocationCoordinate2DMake(lat_v,lng_v)
                        temp.append(pt)
                        
                        let marker = GMSMarker()
                        marker.position = pt
                        marker.map = self.mapView
                        marker.title = item.title
                    }
                }
                if temp.count>0 {
//                    for i in 0..<temp.count {
//
//                        if let position = temp[i] as? CLLocationCoordinate2D {
//                            let marker = GMSMarker()
//                            marker.position = position
//                            marker.map = self.mapView
//                        }
//                    }
                    let camera = GMSCameraPosition.init(target: CLLocationCoordinate2DMake(self.lat, self.lng), zoom: Constants.zoom_level, bearing: 0, viewingAngle: 0)
                    self.mapView.camera = camera
                }
                
            }else{
                //CGlobal.alertMessage("Server Error", title: nil)
            }
            CGlobal.stopIndicator(self)
        }
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
