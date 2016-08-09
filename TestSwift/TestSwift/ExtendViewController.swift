//
//  ExtendViewController.swift
//  TestSwift
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ExtendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


extension ViewController {
    
    func callThisMethodInViewDidLoad() {
        
        //testSaveAndRestoreContext()
        
        testBreakBox()
    }
}


extension ViewController {
    func testSaveAndRestoreContext() {
        let saveAndRestore = SaveAndRestoreContext(frame: CGRect(x: 30, y: 100, width: self.view.frame.width-60, height: 300))
        self.view.addSubview(saveAndRestore)
    }
}

extension ViewController {
    func testBreakBox() {
        let breakBox: BreakBoxMainView = BreakBoxMainView(frame: CGRect(x: 30, y: 100, width: self.view.frame.width-60, height: 300))
        self.view.addSubview(breakBox)
    }
}