//
//  SnakeLessonView.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/19/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

class SnakeLessonView: UIView {
    
    private var lessonImageView:UIImageView = UIImageView()
    
    var isFiltered  = false
    var isStub = false
    var initialsFont:UIFont = UIFont.systemFontOfSize(12.0)
    
    var lessonType:Lesson.LessonType = Lesson.LessonType.Quant
    
    var lessonIcon:UIImage = UIImage() {
        didSet {
            lessonImageView.image = lessonIcon;
        }
    }
    
    private var lessonInitialsLabel:UILabel = UILabel()
    
    var lessonInitials:String = String() {
        didSet {
            lessonInitialsLabel.text = lessonInitials;
        }
    }

    
    func createSubViews(height:CGFloat)
    {
        lessonImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lessonImageView.backgroundColor = UIColor.clearColor()
        lessonImageView.contentMode = UIViewContentMode.Center
        lessonImageView.tintColor = UIColor.whiteColor()
        self.addSubview(lessonImageView)
        
        lessonInitialsLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        lessonInitialsLabel.backgroundColor = UIColor.clearColor()
        lessonInitialsLabel.textColor = UIColor.whiteColor()
        lessonInitialsLabel.textAlignment = NSTextAlignment.Center
        lessonInitialsLabel.font = initialsFont
        self.addSubview(lessonInitialsLabel)
        
        var lessonSubView = ["lessonImageView":lessonImageView, "lessonInitialsLabel":lessonInitialsLabel]
        let metrics = [
            "iconPadding" : self.layer.cornerRadius * 0.65,
            "labelHeight" : self.layer.cornerRadius * 0.65
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-==iconPadding-[lessonImageView]->=0-[lessonInitialsLabel]-==iconPadding-|", options:nil, metrics: metrics, views: lessonSubView))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[lessonImageView]|", options:nil, metrics: metrics, views: lessonSubView))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[lessonInitialsLabel]|", options:nil, metrics: metrics, views: lessonSubView))
        
        let iconHeightConstraint = NSLayoutConstraint(item:lessonImageView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem:lessonInitialsLabel, attribute:NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        self.addConstraint(iconHeightConstraint)
        
        let iconWidthConstraint = NSLayoutConstraint(item:lessonImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        self.addConstraint(iconWidthConstraint)
        
        let labelWidthConstraint = NSLayoutConstraint(item:lessonInitialsLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute:NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        self.addConstraint(labelWidthConstraint)
    }
   
    
}
