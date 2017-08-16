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
    @IBOutlet weak var view3: UIView!
    
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
        self.initText()
        // Do any additional setup after loading the view.
    }
    func initText(){
        let scRect = UIScreen.main.bounds
        
        let toppadding:CGFloat = 100 + 128 + 20;
        let strs = ["<b>In-app purchase</b> days package for your trip. Each day come with minutes based on the country destination.",
                    "<b>Forward</b> your local phone to a number given by us, before departing",
                    "<b>Purchase</b> and switch to an overseas prepaid number. See our in-app guide in getting one.",
                    "<b>Insert</b> your overseas prepaid number and enjoy Roamed."];
        let views = [view0,view1,view2,view3]
        
        for i in 0..<4 {
            let label0 = RTLabel.init(frame: CGRect.init(x: 10, y: 10, width: 240, height: 100))
            label0.text = strs[i]
            views[i]?.addSubview(label0)
//            let size0 = label0.optimumSize;
            label0.center = CGPoint.init(x: scRect.size.width/2, y: toppadding + 50)
            label0.paragraphReplacement = ""
            label0.textAlignment = RTTextAlignmentLeft
            
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 30))
            label.text = "Step \(i+1)"
            views[i]?.addSubview(label)
            label.center = CGPoint.init(x: scRect.size.width/2, y: 50)
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textAlignment = .center
        }
        
        
//        label0.textAlignment = RTTextAlignmentCenter
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
