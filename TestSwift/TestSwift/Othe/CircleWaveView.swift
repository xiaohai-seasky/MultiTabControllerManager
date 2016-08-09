//
//  CircleWaveView.swift
//  TestSwift
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CircleWaveView: UIButton {
    
    private var moveImageView: UIImageView!
    private var persentLabel: UILabel!
    private var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setSelfStyle()
        //setUp()
        //layoutWidgets()
        //configureWidgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var center: CGPoint {
        didSet {
            setSelfStyle()
            setUp()
            layoutWidgets()
            configureWidgets()
        }
    }
    
    
    private func setSelfStyle() {
        self.frame.width > self.frame.height ? (self.frame.size.width = self.frame.height) : (self.frame.size.height = self.frame.width)
        self.layer.cornerRadius = self.frame.width/2                                            // 1 #ff721f / #cccccc
        self.layer.borderColor = UIColor.orangeColor().CGColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.userInteractionEnabled = false
    }
    
    private func setUp() {
        self.moveImageView = UIImageView()
        self.addSubview(self.moveImageView)
        
        self.persentLabel = UILabel()
        self.addSubview(self.persentLabel)
        
        self.textLabel = UILabel()
        self.addSubview(self.textLabel)
    }
    
    private func layoutWidgets() {
        
        let selfCenter: CGPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.moveImageView.frame = self.bounds
        self.moveImageView.frame.size.height *= 1
        self.moveImageView.frame.origin.y = self.frame.height //- 10
        
        self.persentLabel.frame = self.bounds
        self.persentLabel.frame.size.height = 10
        self.persentLabel.center.y = selfCenter.y - self.persentLabel.frame.height/2 - 2
        
        self.textLabel.frame = self.bounds
        self.textLabel.frame.size.height = 10
        self.textLabel.center.y = selfCenter.y + self.textLabel.frame.height/2 + 2
    }
    
    private func configureWidgets() {
        
        self.moveImageView.backgroundColor = UIColor.cyanColor()
//        self.moveImageView.contentMode = .ScaleToFill
        
        self.persentLabel.text = "70%"                                                               // 12 #333333
        self.persentLabel.textColor = UIColor.lightGrayColor()
        self.persentLabel.font = UIFont.systemFontOfSize(12)
        self.persentLabel.textAlignment = .Center
        self.persentLabel.backgroundColor = UIColor.yellowColor()
        
        self.textLabel.text = "概率"                                                                 // 12 #333333
        self.textLabel.textColor = UIColor.lightGrayColor()
        self.textLabel.font = UIFont.systemFontOfSize(12)
        self.textLabel.textAlignment = .Center
        self.textLabel.backgroundColor = UIColor.yellowColor()
    }
    
    
    func setPersent(persent: String) {
        self.persentLabel.text = "\(persent)%"
        let numPer: CGFloat = CGFloat((persent as NSString).floatValue)
        self.moveImageView.frame.origin.y = (self.frame.height - self.frame.height/100.0*numPer)
    }
    
    func setBorderColor(color: UIColor) {
        self.layer.borderColor = color.CGColor
    }
    
    func setWaveImage(image: UIImage) {
        self.moveImageView.image = image
    }
}
