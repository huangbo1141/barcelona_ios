//
//  BaseTableViewCell.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    var model:BaseModelSwift?
    var aDelegate:ViewDialogDelegate?
    @IBAction func clickEntireCell(_ sender: Any) {
        if let delegate = aDelegate,let view = sender as? UIView {
            var obj = [String:Any]()
            if let model = model {
                obj["model"] = model
            }
            let tag:Int = view.tag
            obj["tag"] = tag
            delegate.didSubmit(obj: obj as AnyObject, view: self)
        }
    }
    
    
    
    func setData(data:AnyObject?){
        if let data = data as? [String:AnyObject]{
            if let model = data["model"] as? BaseModelSwift{
                self.model = model
            }
            if let aDelegate = data["aDelegate"] as? ViewDialogDelegate{
                self.aDelegate = aDelegate
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
