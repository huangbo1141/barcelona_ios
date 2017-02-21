import UIKit

@IBDesignable
class RoundCornerButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
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
                
                self.backgroundColor = CGlobal.color(withHexString: "26c6da", alpha: 1.0)
                
            default:
                break;
                
            }
        }
    }
    
}
