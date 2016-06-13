//
//  ViewController.swift
//  MultiTabControllerManage
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MultiTabManangeControllerDelegate, MultiTabManangeControllerDataSource {

    var tabVC:MultiTabManangeController!
    var testVC1:TestController1!
    var testVC2:TestController2!
    var testVC3:TestController3!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabVC = MultiTabManangeController()
        self.tabVC.headContentViewHeight = 180
        self.testVC1 = TestController1()
        self.testVC2 = TestController2()
        self.testVC3 = TestController3()
        self.tabVC.controllers = [testVC1, testVC2, testVC3]
        self.tabVC.datasource = self
        self.tabVC.delegate = self
        
        self.tabVC.showINView(self.view)
    }
    
// MARK: MultiTabManangeControllerDelegate 
    func multiTabView(multiTabView: UIViewController, didSelectItemAtIndex: NSInteger) {
        print("delegate function didSelectedAtIndex called")
    }
    
// MARK: MultiTabManangeControllerDataSource
    func heightForHeadView(multiTabView: UIViewController) -> CGFloat {
        return 100
    }
    
    func numberOfHeadItems(multiTabView: UIViewController) -> NSInteger {
        return 5
    }
    
    func headItemView(multiTabView: UIViewController, index: NSInteger, frame: CGRect) -> UIView {
        let itemView:UIView = UIView()
        itemView.frame = frame
        let lab:UILabel = UILabel(frame: CGRect(x: 3, y: 3, width: itemView.bounds.width-6, height: (itemView.bounds.height-9)/2))
        lab.text = "label"
        lab.backgroundColor = UIColor.grayColor()
        itemView.addSubview(lab)
        let btn:UIButton = UIButton(type: .Custom)
        btn.frame = CGRect(x: 3, y: lab.frame.origin.y+lab.bounds.height+3, width: lab.bounds.width, height: lab.bounds.height)
        btn.setTitle("button", forState: .Normal)
        btn.backgroundColor = UIColor.purpleColor()
        itemView.addSubview(btn)
        
        return itemView
    }
    
    func viewController(multiTabView: UIViewController, index: NSInteger) -> UIViewController {
        if index == 0 {
            return self.testVC1
        }
        else if index == 1 {
            return self.testVC2
        }
        else if index == 2 {
            return self.testVC3
        }
        
        let vc:UIViewController = UIViewController()
        vc.view.backgroundColor = UIColor.redColor()
        return vc
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

