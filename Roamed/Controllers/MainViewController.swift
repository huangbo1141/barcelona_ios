//
//  MainViewController.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit
import StoreKit

class MainViewController: UIViewController {

    var products = [SKProduct]()
    
    @IBOutlet weak var stackMain: UIStackView!
    @IBOutlet weak var constraint_TOP: NSLayoutConstraint!
    @IBOutlet weak var btnRestore: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnRestore.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.initMainTop()
        }
        
    }
    func initMainTop(){
        let size = UIScreen.main.bounds.size
        if size.height <= 568{
            constraint_TOP.constant = 220
        }else if size.height <= 667 && size.height > 568 {
            constraint_TOP.constant = 270
        }else if size.height > 667 {
            constraint_TOP.constant = 300
        }
        stackMain.setNeedsUpdateConstraints()
        stackMain.layoutIfNeeded()
        debugPrint("constraint : height ",constraint_TOP.constant,size.height)
    }
    
    @IBAction func tapNearBy(_ sender: Any) {
        let ms = UIStoryboard.init(name: "Main", bundle: nil);
        DispatchQueue.main.async {
            let viewcon = ms.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController;
            viewcon.mode = 2
            if let navc = self.navigationController {
                navc.pushViewController(viewcon, animated: true)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        reload()
    }

    func reload() {
        products = []
        
        RageProducts.store.requestProducts{success, products in
            if success {
                print("products ",products)
                self.products = products!
            }
        }
    }
    
    @IBAction func restoreTapped(_ sender: AnyObject) {
        RageProducts.store.restorePurchases()
    }
    var prevTest:Int = 0
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            // when purchse done
            if index == 0 {
                self.startList(n: 4)
            }else if index == 1 {
                self.startList(n: 8)
            }else if index == 2{
                // test version
                self.startList(n: prevTest)
            }
            
            //tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    
    @IBAction func tapMenu(_ sender: Any) {
        
        if let view = sender as? UIView {
            let tag = view.tag
            switch tag {
            case 4:
                if self.products.count >= 0 {
                    var product:SKProduct?
                    for iproduct in self.products {
                        if iproduct.productIdentifier == RageProducts.test { //RageProducts.club {
                            product = iproduct
                        }
                    }
                    //let product = self.products[0]
                    if let product = product {
                        if RageProducts.store.isProductPurchased(product.productIdentifier) {
                            self.startList(n: tag)
                        }else{
                            prevTest = tag
                            RageProducts.store.buyProduct(product)
                        }
                    }
                    
                }
                break
            case 8:
                if self.products.count >= 3 {
                    var product:SKProduct?
                    for iproduct in self.products {
                        if iproduct.productIdentifier == RageProducts.test { //RageProducts.resistance {
                            product = iproduct
                        }
                    }
                    //let product = self.products[0]
                    if let product = product {
                        if RageProducts.store.isProductPurchased(product.productIdentifier) {
                            self.startList(n: tag)
                        }else{
                            prevTest = tag
                            RageProducts.store.buyProduct(product)
                        }
                    }
                }
                break
            default:
                startList(n: tag)
                break
            }
        }
    }
    
    func startList(n:Int){
        if n == 0 || n>8 {
            return
        }
        let ms = UIStoryboard.init(name: "Main", bundle: nil);
        DispatchQueue.main.async {
            let viewcon = ms.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController;
            viewcon.id = n
            if let navc = self.navigationController {
                navc.pushViewController(viewcon, animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
