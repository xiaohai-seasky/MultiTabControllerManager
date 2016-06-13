//
//  MultiTabManangeController.swift
//  MultiTabControllerManage
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

import UIKit

@objc (MultiTabManangeControllerDataSource)
public protocol MultiTabManangeControllerDataSource:NSObjectProtocol {
    optional func heightForHeadView(multiTabView:UIViewController) -> CGFloat
    optional func headItemView(multiTabView:UIViewController, index:NSInteger, frame:CGRect) -> UIView
    optional func numberOfHeadItems(multiTabView:UIViewController) -> NSInteger
    optional func viewController(multiTabView:UIViewController, index:NSInteger) -> UIViewController
}

@objc (MultiTabManangeControllerDelegate)
public protocol MultiTabManangeControllerDelegate:NSObjectProtocol {
    optional func multiTabView(multiTabView:UIViewController, didSelectItemAtIndex:NSInteger)
}

class MultiTabManangeController: UIViewController {
    
// MARK: 变量区
    weak var datasource:MultiTabManangeControllerDataSource?
    weak var delegate:MultiTabManangeControllerDelegate?
    
    weak var superContentView:UIView?
    
    var headContentView:UIView!
    var bodyContentView:UIView!
    var controllers:[UIViewController]! = [] {
        willSet{
            
        }
        didSet{
            //startShow()
            //isUseDatasurceVC = false
            ///////setUpUI()
        }
    }
    var innerItemViews:[UIView] = []
    // 默认数据
    var headContentViewHeight:CGFloat = 50
    var itemsCount:NSInteger = 3
    var currSelectedIndex:NSInteger = 0
    var currVC:UIViewController?
    let configItemTAg:NSInteger = 1000
    weak var currDisplayController:UIViewController!
    var isUseDatasurceVC:Bool = true
    
    

// MARK:
// MARK: 系统生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        //setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
// 自定义函数
    func showINView(superView:UIView) -> Void {
        self.superContentView = superView
        superView.addSubview(self.view)
        self.view.frame = superView.bounds
        
        setUpUI() /////////////
    }
    
    func clearNoUseUI() {
        //if ((self.datasource?.respondsToSelector(Selector(viewControllerForMultiTabView:atIndex:))) != nil) {
            //self.controllers.removeAll()
        //}
        if ((self.datasource?.viewController?(self, index: 0)) != nil) {
            self.controllers.removeAll()
        }
        self.innerItemViews.removeAll()
        
        if self.headContentView != nil {
            self.headContentView.removeFromSuperview()
            self.headContentView = nil
        }
        if self.bodyContentView != nil {
            self.bodyContentView.removeFromSuperview()
            self.bodyContentView = nil
        }
        
        //self.headContentViewHeight = 50
        self.itemsCount = 3
        self.currSelectedIndex = 0
        self.isUseDatasurceVC = true
        self.currDisplayController = nil
    }
    
    
    func setUpUI() -> Void {
        
        clearNoUseUI()
        
        //if let _:Bool = self.datasource?.respondsToSelector(Selector("heightForHeadView(_:)")) {
            //self.headContentViewHeight = (self.datasource?.heightForHeadView?(self)) ?? 50
        //}
        if ((self.datasource?.heightForHeadView?(self)) != nil) {
            self.headContentViewHeight = (self.datasource?.heightForHeadView?(self)) ?? 50
        }
        self.headContentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.headContentViewHeight)) // 高度可改
        self.view.addSubview(self.headContentView)
        self.headContentView.backgroundColor = UIColor.blueColor()
        
        let bodyContentViewY:CGFloat = self.headContentView.frame.origin.x+self.headContentView.bounds.size.height
        let bodyContentViewH:CGFloat = self.view.bounds.size.height-bodyContentViewY
        self.bodyContentView = UIView(frame: CGRect(x: 0, y: bodyContentViewY, width: self.view.bounds.size.width, height: bodyContentViewH))
        self.view.addSubview(self.bodyContentView)
        self.bodyContentView.backgroundColor = UIColor.brownColor()
        
        //if let currItems = self.datasource?.numberOfHeadItems!(self) {        // 数量可改
            //self.itemsCount = currItems
        //}
        if ((self.datasource?.numberOfHeadItems?(self)) != nil) {
            self.itemsCount = (self.datasource?.numberOfHeadItems?(self))!
        }
        
        let itemX:CGFloat = 0
        let itemY:CGFloat = 0
        let itemW:CGFloat = self.headContentView.bounds.size.width/CGFloat(itemsCount)
        let itemH:CGFloat = self.headContentView.bounds.size.height
        for i in 0..<self.itemsCount {
            var innerItem:UIView = UIView()    // 视图可改
            let itemFrame:CGRect = CGRect(x: CGFloat(i)*itemW + itemX, y: itemY, width: itemW, height: itemH)
            //if let _:Bool = self.datasource?.respondsToSelector(Selector("headItemView(_:, forIndex:)")) {
                //innerItem = (self.datasource?.headItemView!(self, index: i, frame: itemFrame))!
            //}
            if ((self.datasource?.headItemView?(self, index: i, frame: itemFrame)) != nil) {
                innerItem = (self.datasource?.headItemView?(self, index: i, frame: itemFrame))!
            }
            innerItem.frame = itemFrame
            innerItem.layoutSubviews()
            innerItem.backgroundColor = UIColor.cyanColor()
            innerItem.tag = self.configItemTAg + i
            //self.innerItemViews.append(innerItem)
            self.headContentView.addSubview(innerItem)
            self.innerItemViews =  self.headContentView.subviews
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapItemAtIndex(_:)))
            innerItem.addGestureRecognizer(tap)
            
            if isUseDatasurceVC {
                //if let _:Bool = self.datasource?.respondsToSelector(Selector("viewController(_: forIndex:)")) {      // 控制器
                    //let controller:UIViewController = (self.datasource?.viewController!(self, index: i))!
                    //self.controllers.append(controller)
                //}
                if ((self.datasource?.viewController?(self, index: i)) != nil) {
                    let controller:UIViewController = (self.datasource?.viewController?(self, index: i))!
                    self.controllers.append(controller)
                }
            }
        }
        
        if self.controllers.count > 0 {
            startShow()
        }
    }
    
    // 相应标签被点击的响应函数
    @objc func tapItemAtIndex(gesture:UITapGestureRecognizer) {
        let index:NSInteger = (gesture.view?.tag)! - self.configItemTAg
        self.currSelectedIndex = index
        print("item index is \(index)")
        
        // 内部动作逻辑
        changeSubVCShow(index)
        
        // 代理动作逻辑
        //if let _:Bool = self.delegate?.respondsToSelector(Selector("multiTabView(_: didSelectItemAtIndex:)")) {
           //self.delegate?.multiTabView!(self, didSelectItemAtIndex: index)
        //}
        if ((self.delegate?.multiTabView?(self, didSelectItemAtIndex: index)) != nil) {
            self.delegate?.multiTabView?(self, didSelectItemAtIndex: index)
        }
    }

    // 选择相应标签的动作函数
    func changeSubVCShow(index:NSInteger) -> Void {
        guard self.controllers.count > 0 else {
            print("必须给 MultiTabManangeController 的 controllers 属性赋值，或实现 MultiTabManangeControllerDataSource 的代理方法 viewController(multiTabView: forIndex:) -> UIViewController 提供所需要展示的视图控制器")
            return
        }
        
        for view in innerItemViews {
            view.backgroundColor = UIColor.cyanColor()
        }
        let selView:UIView = innerItemViews[index]
            selView.backgroundColor = UIColor.redColor()
        
        self.currDisplayController.willMoveToParentViewController(nil)
        self.currDisplayController.view.removeFromSuperview()
        self.currDisplayController.removeFromParentViewController()
        self.currDisplayController.didMoveToParentViewController(nil)
        let willShowView:UIViewController = self.controllers[index]
        willShowView.willMoveToParentViewController(self)
        self.bodyContentView.insertSubview(willShowView.view, atIndex: 0)
        self.addChildViewController(willShowView)
        willShowView.didMoveToParentViewController(self)
        
        self.currDisplayController = willShowView
        
        // 切换子视图控制器后重新布局
        repositionViewForVC(willShowView)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    // 初始显示配置
    func startShow() -> Void {
        guard self.controllers.count > 0 else {
            print("必须给 MultiTabManangeController 的 controllers 属性赋值，或实现 MultiTabManangeControllerDataSource 的代理方法 viewController(multiTabView: forIndex:) -> UIViewController 提供所需要展示的视图控制器")
            return
        }
        
        //changeSubVCShow(currSelectedIndex)
        self.innerItemViews[0].backgroundColor = UIColor.redColor()
        let willShowVC:UIViewController = self.controllers[currSelectedIndex]
        willShowVC.willMoveToParentViewController(self)
        self.bodyContentView.insertSubview(willShowVC.view, atIndex: 0)
        self.addChildViewController(willShowVC)
        willShowVC.didMoveToParentViewController(self)
        // 重新布局子视图的view
        repositionViewForVC(willShowVC)
        
        self.currDisplayController = willShowVC
    }
    
    // 重新布局子视图的view方法
    func repositionViewForVC(vc:UIViewController) -> Void {
        print("This method is not implemente yet")
    }
    
    
    
// MARK: NO USE
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
