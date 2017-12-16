//
//  MainViewController.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func tapMenu(_ sender: Any) {
        
        if let view = sender as? UIView {
            let tag = view.tag
            switch tag {
            case 4:
                
                break
            case 8:
                
                break
            default:
                startList(n: tag)
                break
            }
        }
    }
    
    func startList(n:Int){
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
