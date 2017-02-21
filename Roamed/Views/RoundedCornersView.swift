//
//  RoundedCornersView.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
    
    @IBInspectable var backMode: Int = -1 {
        didSet {
            switch backMode {
            case 7:// reserved
                self.backgroundColor = CGlobal.color(withHexString: "#f26336", alpha: 1.0)
            case 6:// secondary third color
                self.backgroundColor = CGlobal.color(withHexString: "#044154", alpha: 1.0)
            case 5:// secondary gray
                self.backgroundColor = CGlobal.color(withHexString: "#939498", alpha: 1.0)
            case 4:// secondary primary
                self.backgroundColor = CGlobal.color(withHexString: "#1c75bc", alpha: 1.0)
            case 3:// primary
                self.backgroundColor = CGlobal.color(withHexString: "#00a1e9", alpha: 1.0)
            case 2:
                self.backgroundColor = CGlobal.color(withHexString: "ffffff", alpha: 1.0)
                
            case 1:// primary
                self.backgroundColor = CGlobal.color(withHexString: "00a1e9", alpha: 1.0)
            case 0:
                
                self.backgroundColor = CGlobal.color(withHexString: "a2b0da", alpha: 1.0)
                
                
            default:
                break;
                
            }
        }
    }
  
}
