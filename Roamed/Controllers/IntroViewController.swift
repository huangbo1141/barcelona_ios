//
//  IntroViewController.swift
//  Roamed
//
//  Created by BoHuang on 2/18/17.
//  Copyright © 2017 SIMPSY LLP. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController,UIScrollViewDelegate {

    
    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraint_width: NSLayoutConstraint!
    
    @IBOutlet weak var btnSkip: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSkip.addTarget(self, action: #selector(IntroViewController.clickView(sender:)), for: .touchUpInside)
        btnSkip.tag = 200
        
        self.initCons()
        // Do any additional setup after loading the view.
    }
    
    func initCons(){
        let height_status = UIApplication.shared.statusBarFrame.size.height;
        
        let sc = UIScreen.main.bounds;
        constraint_width.constant = sc.size.width
        //constraint_height.constant = sc.size.height - height_status
        
        scrollView.isPagingEnabled = true
        scrollView.contentInset = UIEdgeInsets.zero
        
        view0.setNeedsUpdateConstraints()
        view1.setNeedsUpdateConstraints()
        view2.setNeedsUpdateConstraints()
        
        view0.layoutIfNeeded();
        view1.layoutIfNeeded();
        view2.layoutIfNeeded();
        
//        view0.backgroundColor = UIColor.white
//        view1.backgroundColor = UIColor.white
//        view2.backgroundColor = UIColor.white
        
        scrollView.contentSize = CGSize.init(width: sc.size.width, height: sc.size.height - height_status)
        scrollView.showsHorizontalScrollIndicator = false;
        
        scrollView.delegate = self
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        debugPrint("dd",scrollView.contentOffset)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        debugPrint("deceleratin",scrollView.contentOffset)
        
        let pt:CGPoint = scrollView.contentOffset
        let width:Int = Int(constraint_width.constant)
        let pageIndex:Int = Int(pt.x)/width
        self.pageControl.currentPage = pageIndex
    }
    
    func clickView(sender:UIView){
        let tag = sender.tag
        switch tag {
        case 200:
            let delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let global = CGlobal.sharedId();
            global?.env.introviewed = 1
            delegate.defaultLogin()
            break
        default:
            
            break;
        }
        
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
