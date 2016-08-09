//
//  CustomCollectionViewCell.swift
//  TestSwift
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var titleLabel:UILabel!
    var btn:UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpView()
        configureView()
    }
    
    
    private func setUpView() {
        titleLabel = UILabel(frame: CGRect(x: 3, y: 3, width: self.bounds.width-6, height: self.bounds.height/2-8))
        self.addSubview(titleLabel)
        
        btn = UIButton(type: .Custom)
        btn.frame = CGRect(x: 3, y: CGRectGetMaxY(titleLabel.frame)+2, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
        self.addSubview(btn)
    }
    
    private func configureView() {
        titleLabel.backgroundColor = UIColor.cyanColor()
        titleLabel.text = "label"

        btn.backgroundColor = UIColor.purpleColor()
        btn.setTitle("button", forState: .Normal)
    }
    
}
