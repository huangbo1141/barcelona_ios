//
//  PurchaseTableViewCell.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDaysLeft: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var rootView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:PresentPurchase){
        if let name = data.country_iso {
            let image = UIImage.init(named: name)
            imgFlag.image = image;
        }
        lblDaysLeft.text = data.days_left
        lblCountry.text = data.country
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
