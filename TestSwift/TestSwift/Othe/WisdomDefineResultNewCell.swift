//
//  WisdomDefineResultNewCell.swift
//  TestSwift
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class WisdomDefineResultNewCell: UICollectionViewCell {
    
    var topPersentField: UITextField!
    var yearlyReturnLabel: UILabel!
    var threePointViewleft: UIImageView!
    var threePointViewCenter: UIImageView!
    var threePointViewRight: UIImageView!
    var topDetailLabel: UILabel!
    
    var weRecommendLabel: UILabel!
    var weLeftPointView: UIImageView!
    var weLeftLineView: UIView!
    var weRightPointView: UIImageView!
    var weRightLineView: UIView!
    var recommendForYouLabel: UILabel!
    var combinationBtn: UIButton!
    var bottomDetailLabel: UILabel!
    
    var realizeProbabilityLabel: UILabel!
    var showDataView: ProbabilityDataView!
    
    var reEvaluateBtn: UIButton!
    var adjustPlanBtn: UIButton!
    var seeOtherCombinationBtn: UIButton!
    
    var leftVSeperatorLineView: UIView!
    var rightVSeperatorLineView: UIView!
    
    
    let backColor: UIColor = UIColor.cyanColor()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        layoutWidgets()
        configureWidgets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
        self.topPersentField = UITextField()
        self.addSubview(self.topPersentField)
        self.yearlyReturnLabel = UILabel()
        self.addSubview(self.yearlyReturnLabel)
        self.threePointViewleft = UIImageView()
        self.addSubview(self.threePointViewleft)
        self.threePointViewCenter = UIImageView()
        self.addSubview(self.threePointViewCenter)
        self.threePointViewRight = UIImageView()
        self.addSubview(self.threePointViewRight)
        self.topDetailLabel = UILabel()
        self.addSubview(self.topDetailLabel)
        
        self.weRecommendLabel = UILabel()
        self.addSubview(self.weRecommendLabel)
        self.weLeftPointView = UIImageView()
        self.addSubview(self.weLeftPointView)
        self.weLeftLineView = UIView()
        self.addSubview(self.weLeftLineView)
        self.weRightPointView = UIImageView()
        self.addSubview(self.weRightPointView)
        self.weRightLineView = UIView()
        self.addSubview(self.weRightLineView)
        self.recommendForYouLabel = UILabel()
        self.addSubview(self.recommendForYouLabel)
        self.combinationBtn = UIButton(type: .Custom)
        self.addSubview(self.combinationBtn)
        self.bottomDetailLabel = UILabel()
        self.addSubview(self.bottomDetailLabel)
        
        self.realizeProbabilityLabel = UILabel()
        self.addSubview(self.realizeProbabilityLabel)
        self.showDataView = ProbabilityDataView()
        self.addSubview(self.showDataView)
        
        /// 底部三个按钮
        self.reEvaluateBtn = UIButton(type: .Custom)
        self.addSubview(self.reEvaluateBtn)
        self.adjustPlanBtn = UIButton(type: .Custom)
        self.addSubview(self.adjustPlanBtn)
        self.seeOtherCombinationBtn = UIButton(type: .Custom)
        self.addSubview(self.seeOtherCombinationBtn)
        
        self.leftVSeperatorLineView = UIView()
        self.addSubview(self.leftVSeperatorLineView)
        self.rightVSeperatorLineView = UIView()
        self.addSubview(self.rightVSeperatorLineView)
    }
    
    private func layoutWidgets() {
        
        let selfCenterX: CGFloat = self.frame.width/2.0
        let selfCenterY: CGFloat = self.frame.height/2.0
        let startX: CGFloat = 25
        
        
        self.topPersentField.frame = CGRect(x: startX, y: 48, width: self.frame.width-2*startX, height: 38)
        self.topDetailLabel.center.x = selfCenterX

        self.yearlyReturnLabel.frame = self.topPersentField.frame
        self.yearlyReturnLabel.frame.size.height = 10
        self.yearlyReturnLabel.frame.origin.y = self.topPersentField.frame.maxY + 15

        self.threePointViewCenter.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
        self.threePointViewCenter.frame.origin.y = self.yearlyReturnLabel.frame.maxY + 15
        self.threePointViewCenter.center.x = selfCenterX

        self.threePointViewleft.frame = self.threePointViewCenter.frame
        self.threePointViewleft.frame.origin.x = self.threePointViewCenter.frame.minX - 5 - self.threePointViewCenter.frame.width
        
        self.threePointViewRight.frame = self.threePointViewCenter.frame
        self.threePointViewRight.frame.origin.x = self.threePointViewCenter.frame.maxX + 5

        self.topDetailLabel.frame = self.yearlyReturnLabel.frame
        self.topDetailLabel.frame.size.height = 35
        self.topDetailLabel.frame.origin.y = self.threePointViewCenter.frame.maxY + 20

        
        self.weRecommendLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 15)
        self.weRecommendLabel.frame.origin.y = self.topDetailLabel.frame.maxY + 42
        self.weRecommendLabel.center.x = selfCenterX

        self.weLeftPointView.frame = self.threePointViewCenter.frame
        self.weLeftPointView.frame.origin.x = self.weRecommendLabel.frame.minX - 12 - self.threePointViewCenter.frame.width
        self.weLeftPointView.center.y = self.weRecommendLabel.center.y

        self.weLeftLineView.frame = CGRect(x: 0, y: 0, width: 42, height: 0.5)
        self.weLeftLineView.frame.origin.x = self.weLeftPointView.frame.minX - 4 - self.weLeftLineView.frame.width
        self.weLeftLineView.center.y = self.weLeftPointView.center.y

        self.weRightPointView.frame = self.weLeftPointView.frame
        self.weRightPointView.frame.origin.x = self.weRecommendLabel.frame.maxX + 12

        self.weRightLineView.frame = self.weLeftLineView.frame
        self.weRightLineView.frame.origin.x = self.weRightPointView.frame.maxX + 4

        self.recommendForYouLabel.frame = self.yearlyReturnLabel.frame
        self.recommendForYouLabel.frame.size.height = 12
        self.recommendForYouLabel.frame.origin.y = self.weRecommendLabel.frame.maxY + 25

        self.combinationBtn.frame = self.recommendForYouLabel.frame
        self.combinationBtn.frame.size.height = 45
        self.combinationBtn.frame.origin.y = self.recommendForYouLabel.frame.maxY + 12

        self.bottomDetailLabel.frame = self.topDetailLabel.frame
        self.bottomDetailLabel.frame.origin.y = self.combinationBtn.frame.maxY + 15

        
        self.realizeProbabilityLabel.frame = self.yearlyReturnLabel.frame
        self.realizeProbabilityLabel.frame.size.height = 12
        self.realizeProbabilityLabel.frame.origin.y = self.bottomDetailLabel.frame.maxY + 28

        self.showDataView.frame = self.realizeProbabilityLabel.frame
        self.showDataView.frame.size.height = 78
        self.showDataView.frame.origin.y = self.realizeProbabilityLabel.frame.maxY + 25
        self.showDataView.center.x = selfCenterX
        
        
        /// 底部三个按钮
        let btnW: CGFloat = (self.frame.width - 1)/3.0
        let btnH: CGFloat = 45
        
        self.adjustPlanBtn.frame = CGRect(x: 0, y: 0, width: btnW, height: btnH)
        self.adjustPlanBtn.frame.origin.y = self.showDataView.frame.maxY + 30
        self.adjustPlanBtn.center.x = selfCenterX
        
        self.reEvaluateBtn.frame = self.adjustPlanBtn.frame
        self.reEvaluateBtn.center.x -= (self.adjustPlanBtn.frame.width + 0.5)
        
        self.seeOtherCombinationBtn.frame = self.adjustPlanBtn.frame
        self.seeOtherCombinationBtn.center.x += (self.adjustPlanBtn.frame.width + 0.5)
        
        self.leftVSeperatorLineView.frame = CGRect(x: 0, y: 0, width: 0.5, height: 10)
        self.leftVSeperatorLineView.frame.origin.x = self.adjustPlanBtn.frame.minX - 0.5
        self.leftVSeperatorLineView.center.y = self.adjustPlanBtn.center.y
        
        self.rightVSeperatorLineView.frame = self.leftVSeperatorLineView.frame
        self.rightVSeperatorLineView.frame.origin.x = self.adjustPlanBtn.frame.maxX
        
        // cellHeight = 48 + 38 + 15 + 10 + 15 + 4 + 20 + 35 + 42 + 15 + 25 + 12 + 12 + 45 + 15 + 35 + 28 + 12 + 25 + 78 + 30 = 559
        // cellHeight = cellHeight + 45 = 604
    }
    
    private func configureWidgets() {
        
        self.topPersentField.text = "10%"                                           // 50/12 #ff721f
        self.topPersentField.textAlignment = .Center
        self.topPersentField.textColor = UIColor.orangeColor()
        self.topPersentField.font = UIFont.systemFontOfSize(50)
        let shouldConfig: Bool = (topPersentField.text! as NSString).hasSuffix("%")
        if shouldConfig {
            let attr = NSMutableAttributedString(string: self.topPersentField.text!)
            attr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSRange(location: (self.topPersentField.text! as NSString).length-1, length: 1))
            self.topPersentField.attributedText = attr
        }
        self.topPersentField.backgroundColor = backColor
        
        self.yearlyReturnLabel.text = "目标年化收益"                                            // 11 #333333
        self.yearlyReturnLabel.textColor = UIColor.lightGrayColor()
        self.yearlyReturnLabel.font = UIFont.systemFontOfSize(11)
        self.yearlyReturnLabel.textAlignment = .Center
        self.yearlyReturnLabel.backgroundColor = backColor
        
        self.threePointViewleft.backgroundColor = UIColor.grayColor()
        
        self.threePointViewCenter.backgroundColor = UIColor.grayColor()
        
        self.threePointViewRight.backgroundColor = UIColor.grayColor()
        
        self.topDetailLabel.text = ""                                               // 13 #333333
        self.topDetailLabel.textColor = UIColor.lightGrayColor()
        self.topDetailLabel.font = UIFont.systemFontOfSize(13)
        self.topDetailLabel.textAlignment = .Center
        self.topDetailLabel.backgroundColor = backColor
        
        self.weRecommendLabel.text = "WE推荐"                                             // song 16 #333333
        self.weRecommendLabel.textColor = UIColor.lightGrayColor()
        self.weRecommendLabel.font = UIFont.systemFontOfSize(16)
        self.weRecommendLabel.textAlignment = .Center
        self.weRecommendLabel.backgroundColor = backColor
        
        self.weLeftPointView.backgroundColor = UIColor.grayColor()
        
        self.weLeftLineView.backgroundColor = UIColor.grayColor()
        
        self.weRightPointView.backgroundColor = UIColor.grayColor()
        
        self.weRightLineView.backgroundColor = UIColor.grayColor()
        
        self.recommendForYouLabel.text = "基于WE团队对市场的判断，为您推荐"                                         // 13 #333333
        self.recommendForYouLabel.textColor = UIColor.lightGrayColor()
        self.recommendForYouLabel.font = UIFont.systemFontOfSize(13)
        self.recommendForYouLabel.textAlignment = .Center
        self.recommendForYouLabel.backgroundColor = backColor
        
        self.combinationBtn.setTitle("广发稳健1号组合", forState: .Normal)
        self.combinationBtn.backgroundColor = UIColor.orangeColor()
        
        self.bottomDetailLabel.text = ""                                            // 13 #333333
        self.bottomDetailLabel.textColor = UIColor.lightGrayColor()
        self.bottomDetailLabel.font = UIFont.systemFontOfSize(13)
        self.bottomDetailLabel.textAlignment = .Center
        self.bottomDetailLabel.backgroundColor = backColor
        
        self.realizeProbabilityLabel.text = "实现概率"                                      // 13 #333333
        self.realizeProbabilityLabel.textColor = UIColor.lightGrayColor()
        self.realizeProbabilityLabel.font = UIFont.systemFontOfSize(13)
        self.realizeProbabilityLabel.textAlignment = .Center
        self.realizeProbabilityLabel.backgroundColor = backColor
        
        self.showDataView.backgroundColor = UIColor.greenColor()
        
        /// 底部三个按钮
        self.reEvaluateBtn.setTitle("重新测评", forState: .Normal)
        self.reEvaluateBtn.backgroundColor = backColor

        self.adjustPlanBtn.setTitle("调整计划", forState: .Normal)
        self.adjustPlanBtn.backgroundColor = backColor

        self.seeOtherCombinationBtn.setTitle("其他组合", forState: .Normal)
        self.seeOtherCombinationBtn.backgroundColor = backColor

        
        self.leftVSeperatorLineView.backgroundColor = UIColor.lightGrayColor()

        self.rightVSeperatorLineView.backgroundColor = UIColor.lightGrayColor()

    }
}

/**
 return "fof_nav_list_page" // "navlist"
 
 case kApiCombinationHistoryNPV:  // 组合历史净值
 route = @"fof";
 break;
 
 
 guard let provider = self.myProvider as? WisdomDefineDataProvider where provider.fofList != nil && provider.fofList.count > 0 else { return }
 guard indexPath.item < provider.fofList.count else { return }
 let dataModle: WisdomDefineCustomListItemModle = provider.fofList[indexPath.item]
 
 let dic = ["id": dataModle.poCode]
 self.navigator.openString("rrdpage://FOFDetailVC", withQuery: dic, animate: true)
 */
