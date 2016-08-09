//
//  NibCollectionViewCell.swift
//  TestSwift
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class NibCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.image = UIImage(named:"u=4241713225,1400580340&fm=21&gp=0.jpg")
        imageView.backgroundColor = UIColor.grayColor()
        imageView.contentMode = UIViewContentMode(rawValue: 2)!
        imageView.clipsToBounds = true
    }
}
