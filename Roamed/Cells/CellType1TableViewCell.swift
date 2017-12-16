//
//  CellType1TableViewCell.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class CellType1TableViewCell: BaseTableViewCell {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblTitle: ColoredLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setData(data: AnyObject?) {
        super.setData(data: data)
        var include = ""
        if let item = self.model as? TblItem {
            if let temp = item.include {
                include = temp
            }
            
            self.lblTitle.text = item.title
            
            
            if let image = item.image {
                let photopath = GlobalSwift.getPhotoPath(filename: image)
                let url = URL(string:photopath)
                let image = UIImage.init(named: "placeholder.png")
                self.imgBack.sd_setImage(with: url, placeholderImage: image)
                
            }
        }        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
