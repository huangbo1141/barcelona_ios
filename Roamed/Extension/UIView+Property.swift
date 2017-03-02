//
//  UIView+Property.swift
//  TravPholer
//
//  Created by BoHuang on 2/6/17.
//  Copyright © 2017 BoHuang. All rights reserved.
//

import Foundation

import ObjectiveC

private var xoAssociationKey: UInt8 = 0
private var goAssociationKey: UInt8 = 0

extension UIView {
    var xo: UIView! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
//    var go: UIView! {
//        get {
//            return objc_getAssociatedObject(self, &goAssociationKey) as? GeneralDialog
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &goAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
}
