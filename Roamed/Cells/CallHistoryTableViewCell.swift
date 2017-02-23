//
//  CallHistoryTableViewCell.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class CallHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var lblFrom: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(data:CallModel){
        if let name = data.country_iso {
            let image = UIImage.init(named: name.lowercased())
            imgFlag.image = image;
            
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            if let country = delegate.dbManager?.getCountryFromWebcode(name){
                lblFrom.text = country.countryName
            }
        }
        lblTo.text = ""
        if let min = data.minutes {
            lblDuration.text = min + " min"
        }else{
            lblDuration.text = "0 minutes"
        }
        lblDate.text = data.date
    }
    
}
