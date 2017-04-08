//
//  ColoredLabel.swift
//  Roamed
//
//  Created by Twinklestar on 3/16/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
@IBDesignable
class ColoredLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBInspectable var backMode: Int = -1 {
        didSet {
            switch backMode {
            case 1:
                self.font = UIFont.systemFont(ofSize: 13)
                break
            case 0:
                self.textColor = CGlobal.color(withHexString: "3799E5", alpha: 1.0)
                break
            default:
                
                break
            }
        }
    }

}
