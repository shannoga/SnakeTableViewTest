//
//  UIView+LoadNIB.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/19/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    class func autoLayoutView() -> UIView {
        var view = UIView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        return view
    }
}
