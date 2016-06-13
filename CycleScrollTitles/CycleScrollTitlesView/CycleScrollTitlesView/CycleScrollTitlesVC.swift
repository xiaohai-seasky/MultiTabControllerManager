//
//  CycleScrollTitlesVC.swift
//  CycleScrollTitlesView
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 XiaoHaiSeaSky. All rights reserved.
//

import UIKit

protocol CycleScrollTitlesVCDataSource:NSObjectProtocol {
    // 视图个数
    // 视图
    // 高度
}

class CycleScrollTitlesVC: UIViewController {

    // MARK: 变量区
    var numberOfItems:NSInteger = 10
    var viewHeight:CGFloat = 35
    var isItemsWidthEqual:Bool = true
    
    var scrollView:UIScrollView!
    
    var titlesArray:[String]?
    var itemViewArray:[UIView]?
    
    
    
    
    // MARK: 系统生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: 自定义函数
    func setUpView() -> Void {
        let scrViuew:UIScrollView = UIScrollView(frame: self.view.bounds)
        scrViuew.backgroundColor = UIColor.blueColor()
        self.scrollView = scrViuew
        self.view.addSubview(scrViuew)
        
        
    }
    
    func configView() -> Void {
        
    }
    
    
    
    // MARK: 系统内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
