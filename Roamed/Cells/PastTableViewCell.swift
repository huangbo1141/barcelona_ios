//
//  PastTableViewCell.swift
//  Roamed
//
//  Created by BoHuang on 3/2/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class PastTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:PastPurchase){
        if let name = data.country_iso {
            let image = UIImage.init(named: name)
            imgFlag.image = image;
        }
//        if let dayleft = data.days_left {
//            lblDaysLeft.text = dayleft + " Days"
//        }else{
//            lblDaysLeft.text = "0 Days"
//        }
        
        lblCountry.text = data.country
        if let min = data.minutes_left {
            lblMinutes.text = min + " minutes"
        }else{
            lblMinutes.text = "0 minutes"
        }
        
        if let status = data.ended {
            lblStatus.text = status;
        }else{
            lblStatus.text = ""
        }
        //        if let status = data.
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
