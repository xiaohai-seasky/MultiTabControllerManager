//
//  ViewController.swift
//  MultiTabControllerManage
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MultiTabManangeControllerDelegate, MultiTabManangeControllerDataSource {

    var tabVC:MultiTabManangeController!
    var testVC1:TestController1!
    var testVC2:TestController2!
    var testVC3:TestController3!
    
    var collectionView: UICollectionView!
    
    var simpleTabVC:SimpleMultiTabManagerController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUP()
        
//        testMultiTabManangeController()
        testSimpleMultiTabManagerController()
    }
    
    
    func setUP() {
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
        
        self.collectionView.registerClass(MyCollectionCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    
    func testMultiTabManangeController() {
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
    
//// MARK: MultiTabManangeControllerDelegate 
//    func multiTabView(multiTabView: UIViewController, didSelectItemAtIndex: NSInteger) {
//        print("delegate function didSelectedAtIndex called")
//    }
//    
//// MARK: MultiTabManangeControllerDataSource
//    func heightForHeadView(multiTabView: UIViewController) -> CGFloat {
//        return 100
//    }
//    
//    func numberOfHeadItems(multiTabView: UIViewController) -> NSInteger {
//        return 5
//    }
//    
//    func headItemView(multiTabView: UIViewController, index: NSInteger, frame: CGRect) -> UIView {
//        let itemView:UIView = UIView()
//        itemView.frame = frame
//        let lab:UILabel = UILabel(frame: CGRect(x: 3, y: 3, width: itemView.bounds.width-6, height: (itemView.bounds.height-9)/2))
//        lab.text = "label"
//        lab.backgroundColor = UIColor.grayColor()
//        itemView.addSubview(lab)
//        let btn:UIButton = UIButton(type: .Custom)
//        btn.frame = CGRect(x: 3, y: lab.frame.origin.y+lab.bounds.height+3, width: lab.bounds.width, height: lab.bounds.height)
//        btn.setTitle("button", forState: .Normal)
//        btn.backgroundColor = UIColor.purpleColor()
//        itemView.addSubview(btn)
//        
//        return itemView
//    }
//
//    func viewController(multiTabView: UIViewController, index: NSInteger) -> UIViewController {
//        if index == 0 {
//            return self.testVC1
//        }
//        else if index == 1 {
//            return self.testVC2
//        }
//        else if index == 2 {
//            return self.testVC3
//        }
//        
//        let vc:UIViewController = UIViewController()
//        vc.view.backgroundColor = UIColor.redColor()
//        return vc
//    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: SimpleMultiTabManagerControllerDelegate {
    
    func testSimpleMultiTabManagerController() {
        self.simpleTabVC = SimpleMultiTabManagerController()
        self.simpleTabVC.headContentViewHeight = 180
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc1.view.backgroundColor = UIColor.redColor()
        vc2.view.backgroundColor = UIColor.greenColor()
        vc3.view.backgroundColor = UIColor.blueColor()
        self.simpleTabVC.controllers = [vc1, vc2, vc3]
        self.simpleTabVC.itemsCount = 3
        self.simpleTabVC.delegate = self

//        self.simpleTabVC.showINView(self.view)
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
    
    func multiTabView(multiTabView: UIViewController, didSelectItemAtIndex index: NSInteger) {
        print("selected the \(index) item !")
    }
    
    
// MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MyCollectionCell!
        cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! MyCollectionCell
        cell.backgroundColor = UIColor.cyanColor()
        if indexPath.item == 2 {
            self.simpleTabVC.showINView(cell)
        }
        return cell
    }
    
// MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 200)
    }
}

