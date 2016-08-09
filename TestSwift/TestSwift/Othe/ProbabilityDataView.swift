//
//  ProbabilityDataView.swift
//  TestSwift
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ProbabilityDataView: UIView {
    
    var leftLabel: UILabel!
    var centerLabel: UILabel!
    var rightLabel: UILabel!
    
    var leftCircleView: CircleWaveView!
    var centerCircleView: CircleWaveView!
    var rightCircleView: CircleWaveView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
//        setUp()
//        layoutWidgets()
//        configureWidgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var center: CGPoint {
        didSet {
            setUp()
            layoutWidgets()
            configureWidgets()
        }
    }
    
    
    private func setUp() {
        
        self.leftLabel = UILabel()
        self.addSubview(self.leftLabel)
        
        self.centerLabel = UILabel()
        self.addSubview(self.centerLabel)
        
        self.rightLabel = UILabel()
        self.addSubview(self.rightLabel)
        
        
        self.leftCircleView = CircleWaveView()
        self.addSubview(self.leftCircleView)
        
        self.centerCircleView = CircleWaveView()
        self.addSubview(self.centerCircleView)
        
        self.rightCircleView = CircleWaveView()
        self.addSubview(self.rightCircleView)
    }
    
    private func layoutWidgets() {
        
        let selfW: CGFloat = self.frame.width
        let selfH: CGFloat = self.frame.height
        let labelH: CGFloat = 11
        let labelW: CGFloat = selfW/3.0
        let circleW: CGFloat = 55
        let circleH: CGFloat = circleW
        let sapce: CGFloat = 12
        let offset: CGFloat = labelW
        
        self.leftLabel.frame = CGRect(x: 0, y: selfH-labelH, width: labelW, height: labelH)
        self.leftCircleView.frame = CGRect(x: 0, y: self.leftLabel.frame.minY-sapce-circleH, width: circleW, height: circleH)
        self.leftCircleView.center.x = self.leftLabel.center.x
        
        self.centerLabel.frame = self.leftLabel.frame
        self.centerLabel.center.x += offset
        self.centerCircleView.frame = self.leftCircleView.frame
        self.centerCircleView.center.x += offset
        
        self.rightLabel.frame = self.leftLabel.frame
        self.rightLabel.center.x += 2*offset
        self.rightCircleView.frame = self.leftCircleView.frame
        self.rightCircleView.center.x += 2*offset
    }
    
    private func configureWidgets() {
        
        self.leftLabel.text = "目标年化收益--%"                                           // 12 #333333 / #ff721f
        self.leftLabel.textColor = UIColor.lightGrayColor()
        self.leftLabel.font = UIFont.systemFontOfSize(12)
        self.leftLabel.textAlignment = .Center
        self.leftLabel.backgroundColor = UIColor.yellowColor()
        
        self.centerLabel.text = "年化收益--%"                                             // 12 #333333
        self.centerLabel.textColor = UIColor.lightGrayColor()
        self.centerLabel.font = UIFont.systemFontOfSize(12)
        self.centerLabel.textAlignment = .Center
        self.centerLabel.backgroundColor = UIColor.yellowColor()
        
        self.rightLabel.text = "本金不亏损"                                                // 12 #333333
        self.rightLabel.textColor = UIColor.lightGrayColor()
        self.rightLabel.font = UIFont.systemFontOfSize(12)
        self.rightLabel.textAlignment = .Center
        self.rightLabel.backgroundColor = UIColor.yellowColor()
        
        self.leftCircleView.setBorderColor(UIColor.orangeColor())
        self.leftCircleView.setPersent("90")
        
        self.centerCircleView.setBorderColor(UIColor.lightGrayColor())
        self.centerCircleView.setPersent("10")
        
        self.rightCircleView.setBorderColor(UIColor.lightGrayColor())
        self.rightCircleView.setPersent("40")
    }
    
    
    func setPersents(leftPersent: String, centerPersent: String, rightPersent: String) {
        self.leftCircleView.setPersent(leftPersent)
        self.centerCircleView.setPersent(centerPersent)
        self.rightCircleView.setPersent(rightPersent)
    }
    
    func setBottomText(leftText: String, centerText: String, rightText: String = "") {
        self.leftLabel.text = "目标年化收益\(leftText == "" ? "--" : leftText)%"
        self.centerLabel.text = "年化收益\(centerText == "" ? "--" : centerText)%"
        self.rightLabel.text = "本金不亏损"
    }
}
