//
//  NavViewController.swift
//  TravPholer
//
//  Created by BoHuang on 12/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

import UIKit

class SwiftNavViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = UIImage()
//        
//        self.navigationBar.backgroundColor = Constants.COLOR_TOOLBAR_BACK
        self.navigationBar.barTintColor = Constants.COLOR_TOOLBAR_BACK
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:Constants.COLOR_TOOLBAR_TEXT];
//        let titleDict: [String:Any] = [NSForegroundColorAttributeName: Constants.COLOR_TOOLBAR_TEXT]
//        self.navigationBar.titleTextAttributes = titleDict
//        self.navigationBar.isTranslucent = false
        
        
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
