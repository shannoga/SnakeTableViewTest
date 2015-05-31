//
//  Lesson.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/27/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

class Lesson {
    
    enum LessonType:Int {
        case None = 0
        case Verbal = 1
        case Quant = 2
    }
    
    var lessonType = LessonType.Quant
    var imageName = String()
    var subTitle = String()
    var initials = String()
    var active = Bool()
    var isCurrent = Bool()
    
    init(lessonType:LessonType, initials:String, imageName:String, subTitle:String) {
        self.lessonType = lessonType
        self.initials = initials
        self.imageName = imageName
        self.subTitle = subTitle
    }

}
