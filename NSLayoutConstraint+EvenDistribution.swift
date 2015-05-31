//
//  NSLayoutConstraint+EvenDistribution.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/19/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    class func constraintsForEvenDistributionOfViews(views:Array<UIView>,relativeToCenterOfView toView:UIView, vertically:Bool ) -> Array<NSLayoutConstraint> {
        var constraints = Array<NSLayoutConstraint>()
        let attribute = vertically ? NSLayoutAttribute.CenterY : NSLayoutAttribute.CenterX
        
        for (index, view) in enumerate(views) {
            view.setTranslatesAutoresizingMaskIntoConstraints(false)

            let multiplier = CGFloat(2*index + 2) / (CGFloat)(views.count + 1)
            let constraint = NSLayoutConstraint(item: view, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem:toView, attribute: attribute, multiplier: multiplier, constant: 0)
            constraints.append(constraint)
            
            
        }
        return constraints
    }
}
