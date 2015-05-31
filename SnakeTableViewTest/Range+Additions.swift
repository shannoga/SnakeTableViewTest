//
//  Range+Additions.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/26/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

extension Range {
    func contains(val:T) -> Bool {
        for x in self {
            if(x == val) {
                return true
            }
        }
        
        return false
    }
    
    
    func maxValueIsLowerThen(val:Int) -> Bool {
        let maxIndex =  self.endIndex as! Int
        return maxIndex < val
    }
}
