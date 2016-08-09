//
//  SaveAndRestoreContext.swift
//  TestSwift
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class SaveAndRestoreContext: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.cyanColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func drawRect(rect: CGRect) {
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
//        CGContextSaveGState(context)
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        CGContextSetLineWidth(context, 3)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, 0 + self.frame.width, 0 + self.frame.height/2.0)
        CGContextStrokePath(context)
        
//        CGContextRestoreGState(context)
        
        
//        CGContextSaveGState(context)
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 5)
        
        CGContextMoveToPoint(context, self.frame.width, self.frame.height/2.0)
        CGContextAddLineToPoint(context, 0, self.frame.height)
        CGContextStrokePath(context)
        
//        CGContextRestoreGState(context)
        
        
//        CGContextSaveGState(context)
        CGContextSetStrokeColorWithColor(context, UIColor.greenColor().CGColor)
        CGContextSetLineWidth(context, 9)
        
        CGContextMoveToPoint(context, 0, self.frame.height)
        CGContextAddLineToPoint(context, self.frame.width/2.0, self.frame.height/2.0)
        CGContextAddLineToPoint(context, 0, 0)
        CGContextStrokePath(context)
        
//        CGContextRestoreGState(context)
        
        
        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor)
        CGContextSetLineWidth(context, 4)
        
        CGContextAddRect(context, CGRect(x: 0, y: self.frame.height/2.0-25, width: 150, height: 50))
        CGContextStrokePath(context)
    }

}
