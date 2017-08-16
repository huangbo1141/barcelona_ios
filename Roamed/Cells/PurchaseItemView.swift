//
//  PurchaseItemView.swift
//  Roamed
//
//  Created by Twinklestar on 3/29/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import StoreKit
class PurchaseItemView: UIView {

    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var viewLineBottom: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var numStr:String?

    func setData(firstProduct:SKProduct,i:Int,vc:UIViewController,mode:Int){
        // Get its price from iTunes Connect
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = firstProduct.priceLocale
        let price1Str = numberFormatter.string(from: firstProduct.price)
        
        // Show its description
        
        //let title = firstProduct.localizedDescription + "\nfor just \(price1Str!)"
//        lblDay.text = firstProduct.localizedDescription
        lblPrice.text = price1Str
        // ------------------------------------------------
        if mode == 1 {
            btn.addTarget(vc, action: #selector(PurchaseViewController.clickView(sender:)), for: .touchUpInside)
        }else{
            btn.addTarget(vc, action: #selector(ExtendViewController.clickView(sender:)), for: .touchUpInside)
        }
        
        btn.tag = 400 + i
        
        let productID = firstProduct.productIdentifier
        if productID.hasPrefix(Constants.PRODUCT_ID_DAY) {
            let index = productID.index(productID.startIndex, offsetBy: Constants.PRODUCT_ID_DAY.characters.count)
            let numday_str = productID.substring(from: index)
            if let numday = Int(numday_str){
                if numday>1 {
                    lblDay.text = "Buy \(numday)Days"
                }else{
                    lblDay.text = "Buy \(numday)Day"
                }
                self.numStr = numday_str
            }
            
        }
    }
    
}
