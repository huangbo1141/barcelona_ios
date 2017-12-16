//
//  customtypes.swift
//  Roamed
//
//  Created by Huang Bo on 12/15/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation
import UIKit
@objc protocol ViewDialogDelegate {
    func didSubmit(obj:AnyObject, view:UIView)
    func didCancel(view:UIView)
}
