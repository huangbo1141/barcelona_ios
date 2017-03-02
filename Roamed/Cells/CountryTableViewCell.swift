//
//  CountryTableViewCell.swift
//  Roamed
//
//  Created by BoHuang on 2/21/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFlag: UIImageView!
    
    @IBOutlet weak var lblCountry: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data:WNACountry){
        if let name = data.webCode {
            let image = UIImage.init(named: name.lowercased())
            imgFlag.image = image;
        }
        
        lblCountry.text = data.countryName
    }
    func setData(tblCountry:TblCountry){
        if let name = tblCountry.iso {
            let image = UIImage.init(named: name.lowercased())
            imgFlag.image = image;
        }
        
        lblCountry.text = tblCountry.country
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
