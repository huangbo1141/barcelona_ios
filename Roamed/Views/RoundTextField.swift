//
//  RoundTextField.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.borderWidth = 1
            
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var backMode: Int = -1 {
        didSet {
            switch backMode {
                
            case 2:
                self.backgroundColor = CGlobal.color(withHexString: "ffffff", alpha: 1.0)
                
            case 1:
                self.backgroundColor = CGlobal.color(withHexString: "00a1e9", alpha: 1.0)
            case 0:
                
                self.layer.borderColor = CGlobal.color(withHexString: "ffffff", alpha: 1.0).cgColor
                self.backgroundColor = UIColor.clear
            default:
                break;
                
            }
        }
    }
}
