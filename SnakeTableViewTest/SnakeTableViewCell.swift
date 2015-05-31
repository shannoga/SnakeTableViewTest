//
//  SnakeTableViewCell.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/19/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

class SnakeTableViewCell: UITableViewCell {

    enum SnakeLineStyle {
        case Dashed
        case Continuous
    }
    
    //cell
    var isLastCell = false
    var didSetUpCells = false
    
    //snack line properties
    var snakeThickness = CGFloat(1.5)
    var snakeLineStyle = SnakeLineStyle.Continuous
    var snakeContinuousLineColor = UIColor()
    var snakeDashedColor = UIColor()

    
    //lessons views
    var lessonsIndexRange:Range<Int> = 0...0
    var lessonInRow = Int()
    var lessons = Array<Lesson>()
    var lessonViews = Array<SnakeLessonView>()
    var lessonLables = Array<UITextView>()
    var vflViews = Dictionary<String, UIView>()
  
    var isEvenRow = false

    var centerView = UIView()
    
    var lessonSquereWidth:CGFloat  {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return 86
        }
        let maxLessonsinRow = isEvenRow ? lessonInRow + 1 : lessonInRow
        let width = ((UIScreen.mainScreen().bounds.width - padding) / CGFloat(maxLessonsinRow)) * 0.70
        return ((UIScreen.mainScreen().bounds.width - padding) / CGFloat(maxLessonsinRow)) * 0.70
    }
    
 
    var padding:CGFloat {
        return snakeInset * 2
    }
    
    var snakeInset:CGFloat {
        return UIScreen.mainScreen().bounds.width / 20
    }
    
    var innerPadding:CGFloat {
        let maxLessonsinRow = isEvenRow ? lessonInRow + 1 : lessonInRow
        let screenWidth = UIScreen.mainScreen().bounds.width - padding * 2.0
        let innerPadding = (screenWidth - (CGFloat(maxLessonsinRow) * lessonSquereWidth)) / (CGFloat(maxLessonsinRow)-1)
        return innerPadding
    }
    
    
    var lessonViewColor:UIColor = UIColor.mainSnakeColor()
    var currentLinePoint = CGPoint()
    var currentLessonIndex = Int()
    
    override func awakeFromNib() {
       super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setNeedsDisplay()
    }
    
    func setUpLessonsSqueurs()
    {
        if didSetUpCells {return}

        for var i = 0; i < lessonInRow; ++i
        {

            var lessonView = SnakeLessonView()
            lessonView.backgroundColor = lessonViewColor
            lessonView.setTranslatesAutoresizingMaskIntoConstraints(false)
            //lessonView.alpha = 0.2

            lessonView.layer.cornerRadius = CGFloat(lessonSquereWidth * 0.20)
            vflViews["view\(i)"] = lessonView
            lessonView.initialsFont = UIFont.systemFontOfSize(12.0)
            self.contentView.addSubview(lessonView)
            lessonView.createSubViews(lessonSquereWidth)
            
            var subTitleLabel = UITextView()
            subTitleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            subTitleLabel.backgroundColor = UIColor.clearColor()
            subTitleLabel.textColor = UIColor.blackColor()
            subTitleLabel.editable = false
            subTitleLabel.scrollEnabled = false
            subTitleLabel.textAlignment = NSTextAlignment.Center
            subTitleLabel.font = UIFont.systemFontOfSize(12.0)
            vflViews["subTitleLabel\(i)"] = subTitleLabel
            self.contentView.addSubview(subTitleLabel)
            
            lessonViews.append(lessonView)
            lessonLables.append(subTitleLabel)
        }
        
        
        if isEvenRow
        {
            centerView.setTranslatesAutoresizingMaskIntoConstraints(false)
            centerView.backgroundColor = UIColor.purpleColor()
            self.contentView.addSubview(centerView)
            vflViews["centerView"] = centerView
            addConstraintsToContentViewForEvenLessons()
        }
        else
        {
            addConstraintsToContentViewForOddLessons()
        }

        
        didSetUpCells = true
    }
    
    func addConstraintsToContentViewForOddLessons() { //odd lessons row
        
        let metrics = [
            "lessonViewWidth" : lessonSquereWidth,
            "padding" : padding,
            "innerPadding" : self.innerPadding
        ]
        
        var VFLHorisontalString = "H:|-<=padding@1000-"
        
        for (index, lessonView) in enumerate(self.lessonViews)
        {
            var subTitleLabel = self.lessonLables[index]
            centerLessonLabel(lessonView, subTitleLabel: subTitleLabel)
            positionLessonView(lessonView)

            VFLHorisontalString += "[view\(index)(lessonViewWidth)]"
            if index < (lessonInRow - 1)
            {
                VFLHorisontalString += "-<=innerPadding@500-"
            }
        }
        
        VFLHorisontalString += "-<=padding@1000-|"
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(VFLHorisontalString, options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: vflViews))
        
    }
    
    func addConstraintsToContentViewForEvenLessons() {// even lessons row
        
        let metrics = [
            "lessonViewWidth" : lessonSquereWidth,
            "padding" : padding,
            "innerPadding" : self.innerPadding,
            "halfInnerPadding" : self.innerPadding / 2
        ]
        
        var VFLHorisontalString = "H:|->=0-"
        
        for (index, lessonView) in enumerate(self.lessonViews)
        {
            var subTitleLabel = self.lessonLables[index]
            positionCenterView()
            centerLessonLabel(lessonView, subTitleLabel: subTitleLabel)
            positionLessonView(lessonView)
            
            VFLHorisontalString += "[view\(index)(lessonViewWidth)]"
            if index < (lessonInRow - 1)
            {
                VFLHorisontalString += "-==innerPadding@1000-"
            }
            
            if index == lessonInRow / 2 {
                if self.lessonInRow % 2 == 0 {
                    
                    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[centerView]-(halfInnerPadding)-[view\(index)]", options:NSLayoutFormatOptions.AlignAllCenterY, metrics:metrics, views: vflViews))
                    
                } else {
                    self.contentView.addConstraint(NSLayoutConstraint(item: lessonView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:centerView, attribute:  NSLayoutAttribute.CenterX, multiplier:1.0, constant: 0))
                }
            }
            
        }
        
        VFLHorisontalString += "->=0-|"
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(VFLHorisontalString, options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: vflViews))
      
        
    }
    
    func positionLessonView(lessonView:SnakeLessonView)
    {
        //lesson view size
        self.contentView.addConstraint( NSLayoutConstraint(item: lessonView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem:lessonView, attribute:  NSLayoutAttribute.Width, multiplier: 1.02, constant: 0))
//        //lesson view center Y
        self.contentView.addConstraint(NSLayoutConstraint(item:lessonView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:self.contentView, attribute:NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
    }
    
    func centerLessonLabel(lessonView:SnakeLessonView, subTitleLabel:UITextView)
    {
        
        //width
        self.contentView.addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:lessonView, attribute:  NSLayoutAttribute.Width, multiplier:1.0, constant: 0))
        //height
        self.contentView.addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem:lessonView, attribute:  NSLayoutAttribute.Height, multiplier:0.65, constant: 0))
        //center label
        self.contentView.addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:lessonView, attribute:  NSLayoutAttribute.CenterX, multiplier:1.0, constant: 0))
        //vertical position
        self.contentView.addConstraint(NSLayoutConstraint(item: subTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:lessonView, attribute:  NSLayoutAttribute.Bottom, multiplier:0.98, constant: 0))
    
    }
    
    func positionCenterView()
    {
        let metrics = ["lessonViewWidth" : 1]

        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=20)-[centerView(lessonViewWidth)]-(>=20)-|", options:NSLayoutFormatOptions.AlignAllCenterY, metrics:metrics, views: vflViews))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=20)-[centerView(lessonViewWidth)]-(>=20)-|", options:NSLayoutFormatOptions.AlignAllCenterX, metrics:metrics, views: vflViews))
        self.contentView.addConstraint(NSLayoutConstraint(item: centerView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem:centerView.superview , attribute:  NSLayoutAttribute.CenterX, multiplier:1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: centerView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:centerView.superview , attribute:  NSLayoutAttribute.CenterY, multiplier:1.0, constant: 0))
    }
    

    
    func updateLessonsData()
    {
        for (index, lessonView) in enumerate(lessonViews) {
            
            let emptyViewsCount = (lessonInRow - self.lessons.count)
            var lessonLabel = lessonLables[index]
            
            
            func hideView() {
                lessonView.isStub = true
                lessonView.hidden = true
                lessonLabel.hidden = true
            }
            
            func updateViewAtIndex(index:Int) {
                let lesson = self.lessons[index]
                updateLessonViewWithLesson(lesson, lessonView: lessonView,lessonLabel:lessonLabel, index: index)
            }
            
            if isEvenRow {
                if index < self.lessons.count {
                    updateViewAtIndex(index)
                } else {
                    hideView()
                }
            } else {
                if index < emptyViewsCount {
                    hideView()
                } else {
                    updateViewAtIndex(index - emptyViewsCount)
                }
                
            }
        }
    }
    
 
    func updateLessonViewWithLesson(lesson:Lesson, lessonView:SnakeLessonView, lessonLabel:UITextView, index:Int) {
        
        lessonView.isStub = false
        lessonView.hidden = false
        lessonLabel.hidden = false
        
        lessonView.tag = isEvenRow ?  lessonsIndexRange.startIndex + index : lessonsIndexRange.endIndex - index - 1
        lessonView.lessonType = lesson.lessonType
        let icon = UIImage(named: lesson.imageName)
        if let lessonViewIcon = icon {
            lessonView.lessonIcon = lessonViewIcon
        }
        lessonView.lessonInitials = lesson.initials
        lessonLabel.text = lesson.subTitle
        
        if(lessonView.tag == self.currentLessonIndex){
            lessonView.backgroundColor = UIColor.orangeColor()
        } else if (lessonView.tag < self.currentLessonIndex) {
            lessonView.backgroundColor = UIColor.mainSnakeColor()
        } else {
            lessonView.backgroundColor = UIColor.lightGrayColor()
        }
    }
   
  
    
    //MARK : Snake drawing

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var ctx = UIGraphicsGetCurrentContext();
        CGContextBeginPath(ctx)
        
        if (self.lessonsIndexRange.startIndex < self.currentLessonIndex || self.lessonsIndexRange.contains(self.currentLessonIndex))
        {
            setLineStyleForContext(ctx, style:SnakeLineStyle.Continuous)
        }
        else
        {
            setLineStyleForContext(ctx, style:SnakeLineStyle.Dashed)
        }
        
        if !self.lessonsIndexRange.contains(1)
        {
            drawStartingCurveInContext(ctx, rect: rect)
            CGContextStrokePath(ctx)
        }

        drawLinesBetweenCellsInContext(ctx, rect: rect)
       // CGContextStrokePath(ctx)
        
        if (!self.isLastCell)
        {
            drawEndingCurveInContext(ctx, rect: rect)
            CGContextStrokePath(ctx)
        }
    }
    
    func setLineStyleForContext(ctx:CGContextRef, style:SnakeLineStyle) {
        
        switch style {
            case let .Continuous:
                CGContextSetLineDash(ctx, 0.0, [], 0)
                CGContextSetStrokeColorWithColor(ctx, snakeContinuousLineColor.CGColor)
                CGContextSetLineWidth(ctx, snakeThickness);
                
            case let .Dashed:
                CGContextSetLineDash(ctx, 0.0, [5.0, 2.0], 2)
                CGContextSetStrokeColorWithColor(ctx, snakeDashedColor.CGColor)
                CGContextSetLineWidth(ctx, snakeThickness);
        }
        self.snakeLineStyle = style
    }
    
    
    func drawStartingCurveInContext(ctx:CGContextRef, rect:CGRect) {
        let h = rect.height
        let w = rect.width
        
        if isEvenRow {
            CGContextMoveToPoint(ctx, snakeInset, 0) //starting point
            CGContextAddArcToPoint(ctx, snakeInset, h/2, snakeInset*3, h/2, h/4)
            CGContextAddLineToPoint(ctx, snakeInset*3, h/2)
            CGContextMoveToPoint(ctx, snakeInset*3, h/2)
            currentLinePoint = CGPoint(x: snakeInset*3, y: h/2)

        } else {
            CGContextMoveToPoint(ctx, w-snakeInset, 0) //starting point
            CGContextAddArcToPoint(ctx, w-snakeInset, h/2, w-snakeInset*3, h/2, h/4)
            CGContextAddLineToPoint(ctx, w-snakeInset*3, h/2)
            CGContextMoveToPoint(ctx, w-snakeInset*3, h/2)
            currentLinePoint = CGPoint(x: w-snakeInset*3, y: h/2)

        }
    }
    
    func drawLinesBetweenCellsInContext(ctx:CGContextRef, rect:CGRect) {
        let h = rect.height
        let w = rect.width
        
        if !self.lessonsIndexRange.contains(1) {
            CGContextMoveToPoint(ctx, currentLinePoint.x, currentLinePoint.y)
        }
        
        let views =  isEvenRow ? lessonViews : lessonViews.reverse()
        
        for (index, view) in enumerate(views) {
            if !view.isStub {

                if view.tag != 0 {
                    CGContextMoveToPoint(ctx, currentLinePoint.x, currentLinePoint.y)
                }
                CGContextAddLineToPoint(ctx, view.frame.midX, h/2)
                CGContextMoveToPoint(ctx, view.frame.midX, h/2)
                currentLinePoint = CGPoint(x: view.frame.midX, y: h/2)
                CGContextStrokePath(ctx)
                
                if (view.tag == self.currentLessonIndex) {
                    if self.snakeLineStyle != SnakeLineStyle.Dashed {
                        setLineStyleForContext(ctx, style:SnakeLineStyle.Dashed)
                        CGContextMoveToPoint(ctx, currentLinePoint.x, currentLinePoint.y)
                        CGContextStrokePath(ctx)
                        currentLinePoint = CGPoint(x: view.frame.midX, y: h/2)
                    }
                }
            }
        }
        
    }
    
    func drawEndingCurveInContext(ctx:CGContextRef, rect:CGRect) {
        let h = rect.height
        let w = rect.width
        CGContextMoveToPoint(ctx, currentLinePoint.x, currentLinePoint.y)
        
        if isEvenRow {
            CGContextAddArcToPoint(ctx, w-snakeInset, h/2, w-snakeInset, h, h/4)
            CGContextAddLineToPoint(ctx, w-snakeInset, h)
            CGContextMoveToPoint(ctx, w-snakeInset, h)
        } else {
            CGContextAddArcToPoint(ctx, snakeInset, h/2, snakeInset, h, h/4)
            CGContextAddLineToPoint(ctx, snakeInset, h)
            CGContextMoveToPoint(ctx, snakeInset, h)
        }
    }
    
    func filterLessonOfType(type:Lesson.LessonType, animated:Bool) {
        for (index, lessonView) in enumerate(self.lessonViews) {
            let isFiltered = (lessonView.lessonType == type)
            lessonView.isFiltered = isFiltered
            scaleLessonViews(lessonView, label:self.lessonLables[index], filtered: isFiltered, animated:animated)
            self.setNeedsDisplay()
        }
    }
    
    
    //MARK : Filtering animation
    func scaleLessonViews(lessonView:UIView, label:UITextView, filtered:Bool, animated:Bool) {
        
        UIView.animateWithDuration(animated ? 0.6 : 0.0, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: nil, animations: { () -> Void in
            if filtered
            {
                var scale = CGAffineTransformMakeScale(0.3, 0.3)
                var move = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -lessonView.frame.size.height * 0.55)
                var transform = CGAffineTransformConcat(scale, move)
                label.transform = transform
                lessonView.transform = scale
                label.alpha = 0.5
            } else {
                label.transform = CGAffineTransformIdentity
                lessonView.transform = CGAffineTransformIdentity
                label.alpha = 1
            }
            }) { (Bool) -> Void in
                
        }
    }
    
   
}
