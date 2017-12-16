//
//  CellType3TableViewCell.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import SDWebImage

class CellType3TableViewCell: BaseTableViewCell {

    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var viewText1: UIView!
    @IBOutlet weak var viewText2: UIView!
    @IBOutlet weak var lblText1_1: UILabel!
    @IBOutlet weak var lblText2_1: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblText1_1.textColor = UIColor.white
        lblText2_1.textColor = UIColor.black
        btn1.tag = 1
        btn2.tag = 2
    }
    
    override func setData(data: AnyObject?) {
        super.setData(data: data)
        var include = ""
        if let item = self.model as? TblItem {
            if let temp = item.include {
                include = temp
            }
            
            lblText1_1.text = item.location
            lblText2_1.text = item.location
            
            if let phone = item.phone, !phone.contains("@"),phone.contains("+") {
                let title = "Reservation "+phone
                
                btn1.setTitle(title, for: .normal)
                btn2.setTitle(title, for: .normal)
            }
            else{
                btn1.setTitle(item.phone, for: .normal)
                btn2.setTitle(item.phone, for: .normal)
            }
            
            if let image = item.image {
                let photopath = GlobalSwift.getPhotoPath(filename: image)
                let url = URL(string:photopath)
                let image = UIImage.init(named: "placeholder.png")
                self.imgBack.sd_setImage(with: url, placeholderImage: image)
                
            }
            
            
            if include.lowercased().contains("0") {
                self.viewText1.isHidden = false
                self.btn1.isHidden = false
                
                self.viewText2.isHidden = true
                self.btn2.isHidden = true
                
                
                
            }else{
                self.viewText1.isHidden = true
                self.btn1.isHidden = true
                
                self.viewText2.isHidden = false
                self.btn2.isHidden = false
            }
        }
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
