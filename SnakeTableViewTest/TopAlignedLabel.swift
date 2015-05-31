//
//  TopAlignedLabel.swift
//  SnakeTableViewTest
//
//  Created by Shani LTG on 5/27/15.
//  Copyright (c) 2015 Shani LTG. All rights reserved.
//

import UIKit

class TopAlignedLabel: UILabel {

    override func drawTextInRect(rect: CGRect) {
        if let stringText = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = self.lineBreakMode;
            let stringTextAsNSString: NSString = stringText as NSString
            var labelStringSize = stringTextAsNSString.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName:self.font,NSParagraphStyleAttributeName: paragraphStyle],
                context: nil).size
            super.drawTextInRect(CGRectMake(0, 0, CGRectGetWidth(self.frame), labelStringSize.height))
        } else {
            super.drawTextInRect(rect)
        }
    }
}
