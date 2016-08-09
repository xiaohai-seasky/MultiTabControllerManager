//
//  BreakBoxMainView.swift
//  TestSwift
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class BreakBoxMainView: UIView {
    
    private var rows: CGFloat = 4
    private var columns: CGFloat = 7
    private var totalWidth: CGFloat = 320
    private var totalHeight: CGFloat = 150
    private var startX: CGFloat = 0
    private var startY: CGFloat = 0
    private var spaceBetwenRows: CGFloat = 0
    private var spaceBetwenColumns: CGFloat = 0
    
    private var ball: UIImageView!
    private var ballW: CGFloat = 20
    private var ballH: CGFloat = 20
    private var ballRadius: CGFloat = 10
    private var ballX: CGFloat = 0
    private var ballY: CGFloat = 0
    private var ballCenterX: CGFloat = 0
    private var ballCenterY: CGFloat = 0
    private var ballColor: UIColor = UIColor.redColor()
    private var ballImage: UIImage?
    private var ballXSpeed: CGFloat = -10.0
    private var ballYSpeed: CGFloat = -10.0
    
    private var mover: UIImageView!
    private var moverW: CGFloat = 100
    private var moverH: CGFloat = 10
    private var moverX: CGFloat = 0
    private var moverY: CGFloat = 0
    private var moverCenterX: CGFloat = 0
    private var moverCenterY: CGFloat = 0
    private var moverColor: UIColor = UIColor.blueColor()
    private var moverImage: UIImage?
    private var moverSpeed: CGFloat = 10.0
    private lazy var moverBotFix: CGFloat = { return self.btnTopSpace + self.btnH + self.btnBotSpace }()
    
    private var timer: NSTimer?
    private var timerRate: NSTimeInterval = 0.3
    
    private var boxes: [UIView] = []
    
    // control
    private var settingBtn: UIButton!
    private var pauseOrResumeBtn: UIButton!
    private var moveLeftBtn: UIButton!
    private var moveRightBtn: UIButton!
    private var durationLabel: UILabel!
    
    private lazy var selfW: CGFloat = { return self.frame.width }()
    private lazy var selfH: CGFloat = { return self.frame.height }()
    
    private lazy var btnW: CGFloat = { return 50 }()
    private lazy var btnH: CGFloat = { return self.btnW }()
    private lazy var btnStartX: CGFloat = { return 20 }()
    private lazy var btnSpace: CGFloat = { return (self.selfW - 2*self.btnStartX - 4*self.btnW)/3.0 }()
    
    // setting
    private var settingGUIView: UIView!

    // other
    private var btnTopSpace: CGFloat = 25
    private var btnBotSpace: CGFloat = 20
    private var isPlaying: Bool = false
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orangeColor()
        self.frame = UIScreen.mainScreen().bounds
        start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func start() {
//        generat/eBoxes()
        createMover()
        createBall()
        createTimer()
        createControlBtn()
    }
}

extension BreakBoxMainView {
    private func generateBoxes() {
        
        let totalW: CGFloat = self.bounds.width
        let totalH: CGFloat = self.totalHeight
        
        let oneBoxW = (totalW - 2.0*startX - (columns-1)*spaceBetwenColumns)/self.columns
        let oneBoxH = (totalH - 2.0*startY - (rows-1)*spaceBetwenRows)/self.rows
        
        for i in 0 ..< Int(self.rows)*Int(self.columns) {
            
            let oneBox: UILabel = UILabel()
            oneBox.frame = CGRect(x: startX + CGFloat((i%Int(self.columns)))*(oneBoxW+spaceBetwenColumns), y: startY + CGFloat((i/Int(self.columns)))*(oneBoxH+spaceBetwenRows), width: oneBoxW, height: oneBoxH)
            oneBox.backgroundColor = genereteRandomColor()
            self.addSubview(oneBox)
            self.boxes.append(oneBox)
        }
    }
    
    private func genereteRandomColor() -> UIColor {
        
        let red: CGFloat = CGFloat(arc4random_uniform(255))/255.0
        let green: CGFloat = CGFloat(arc4random_uniform(255))/255.0
        let blue: CGFloat = CGFloat(arc4random_uniform(255))/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension BreakBoxMainView {
    private func createMover() {
        let mover = UIImageView()
        mover.frame = CGRect(x: 0, y: 0, width: self.moverW, height: self.moverH)
        mover.center.x = self.bounds.width/2.0
        mover.frame.origin.y = self.bounds.height - self.moverH - self.moverBotFix
        mover.backgroundColor = self.moverColor
        /// not set image 
        self.addSubview(mover)
        self.mover = mover
    }
}

extension BreakBoxMainView {
    private func createBall() {
        let ball = UIImageView()
        ball.frame = CGRect(x: 0, y: 0, width: self.ballW, height: self.ballH)
        ball.frame.origin.x = self.frame.width/2.0 // self.mover.frame.origin.x
        ball.frame.origin.y = self.mover.frame.minY - self.ballH
        ball.backgroundColor = self.ballColor
        /// not set image
        self.addSubview(ball)
        self.ball = ball
    }
}

extension BreakBoxMainView {
    private func createControlBtn() {
        setUpBtn()
        layoutBtn()
        configureBtn()
    }
    
    private func setUpBtn() {
        self.moveLeftBtn = UIButton(type: .Custom)
        self.addSubview(self.moveLeftBtn)
        
        self.settingBtn = UIButton(type: .Custom)
        self.addSubview(self.settingBtn)
        
        self.pauseOrResumeBtn = UIButton(type: .Custom)
        self.addSubview(self.pauseOrResumeBtn)
        
        self.moveRightBtn = UIButton(type: .Custom)
        self.addSubview(self.moveRightBtn)
    }
    
    private func layoutBtn() {
        self.moveLeftBtn.frame = CGRect(x: self.btnStartX, y: self.mover.frame.maxY + self.btnTopSpace, width: self.btnW, height: self.btnH)
        
        self.settingBtn.frame = self.moveLeftBtn.frame
        self.settingBtn.frame.origin.x += 1*(self.btnW + self.btnSpace)
        
        self.pauseOrResumeBtn.frame = self.moveLeftBtn.frame
        self.pauseOrResumeBtn.frame.origin.x += 2*(self.btnW + self.btnSpace)
        
        self.moveRightBtn.frame = self.moveLeftBtn.frame
        self.moveRightBtn.frame.origin.x += 3*(self.btnW + self.btnSpace)
    }
    
    private func configureBtn() {
        self.moveLeftBtn.backgroundColor = UIColor.cyanColor()
        self.moveLeftBtn.addTarget(self, action: #selector(moveLeft), forControlEvents: .TouchUpInside)
        
        self.settingBtn.backgroundColor = UIColor.cyanColor()
        self.settingBtn.addTarget(self, action: #selector(showSettingView), forControlEvents: .TouchUpInside)
        
        self.pauseOrResumeBtn.backgroundColor = UIColor.cyanColor()
        self.pauseOrResumeBtn.addTarget(self, action: #selector(pauseOrResume), forControlEvents: .TouchUpInside)
        
        self.moveRightBtn.backgroundColor = UIColor.cyanColor()
        self.moveRightBtn.addTarget(self, action: #selector(moveRight), forControlEvents: .TouchUpInside)
    }
}

extension BreakBoxMainView {
    @objc private func moveLeft() {
        self.mover.frame.origin.x -= self.moverSpeed
        if self.mover.frame.minX < 0 {
            self.mover.frame.origin.x = 0
        }
    }
    
    @objc private func moveRight() {
        self.mover.frame.origin.x += self.moverSpeed
        if self.mover.frame.maxX > self.bounds.width {
            self.mover.frame.origin.x = self.bounds.width - self.mover.frame.width
        }
    }
    
    @objc private func startPlay() {
        startTimer()
        self.isPlaying = true
    }
    
    @objc private func pauseOrResume() {
        if self.isPlaying {
            pauseTimer()
            self.isPlaying = false
        } else {
            resumeTimer()
            self.isPlaying = true
        }
    }
    
    @objc private func showSettingView() {
        self.isPlaying = true
        pauseOrResume()
        let setting: SettingGUIView = SettingGUIView(frame: CGRectZero)
        setting.showInView(self, settingFinishHandler: {[weak self] ()->() in
            self!.pauseOrResume()
        })
    }
}


extension BreakBoxMainView {
    private func createTimer() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(self.timerRate, target: self, selector: #selector(callByTimer), userInfo: nil, repeats: true)
        timer.fireDate = NSDate.distantFuture()
        self.timer = timer
    }
    
    private func clearTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = nil
    }
    
    private func pauseTimer() {
        if let timer = self.timer {
            timer.fireDate = NSDate.distantFuture()
        }
    }
    
    private func startTimer() {
        if let timer = self.timer {
            timer.fireDate = NSDate.distantPast()
        }
    }
    
    private func resumeTimer() {
        if let timer = self.timer {
            timer.fireDate = NSDate.distantPast()
        }
    }
    
}

extension BreakBoxMainView {
    @objc private func callByTimer() {
        updateBallFrame()
    }
    
    private func updateBallFrame() {
        self.ball.frame.origin.x += self.ballXSpeed
        self.ball.frame.origin.y += self.ballYSpeed
        
        var index: Int = 0
        for box in self.boxes {
            collisionTestWithBox(self.ball, box: box, index: index)
            index += 1
        }
        collisionTestWithBorder(self.ball, borderView: self)
        collisionTestWithMover(self.ball, mover: self.mover)
    }
    
    private func collisionTestWithBox(ball: UIView, box: UIView, index: Int) {
        let ballMaxX = ball.frame.maxX
        let ballMinX = ball.frame.minX
        let ballMaxY = ball.frame.maxY
        let ballMinY = ball.frame.minY
        
        let boxMaxX = box.frame.maxX
        let boxMinX = box.frame.minX
        let boxMaxY = box.frame.maxY
        let boxMinY = box.frame.minY
        
        /// error condition : ball W/H > box H/W   need to fix
        if ballMinX >= boxMinX && ballMinX <= boxMaxX && ((ballMinY >= boxMinY && ballMinY <= boxMaxY) || (ballMaxY >= boxMinY && ballMaxY <= boxMaxY)) {
            self.ballXSpeed *= -1
            box.removeFromSuperview()
            self.boxes.removeAtIndex(index)
        } else if ballMaxY >= boxMinX && ballMaxY <= boxMaxX && ((ballMinY >= boxMinY && ballMinY <= boxMaxY) || (ballMaxY >= boxMinY && ballMaxY <= boxMaxY)) {
            self.ballXSpeed *= -1
            box.removeFromSuperview()
            self.boxes.removeAtIndex(index)
        } else if boxMaxY >= ballMinX && boxMaxY <= ballMaxX && ((boxMinY >= ballMinY && boxMinY <= ballMaxY) || (boxMaxY >= ballMinY && boxMaxY <= ballMaxY)) {
            self.ballYSpeed *= -1
            box.removeFromSuperview()
            self.boxes.removeAtIndex(index)
        } else if boxMinY >= ballMinX && boxMinY <= ballMaxX && ((boxMinY >= ballMinY && boxMinY <= ballMaxY) || (boxMaxY >= ballMinY && boxMaxY <= ballMaxY)) {
            self.ballYSpeed *= -1
            box.removeFromSuperview()
            self.boxes.removeAtIndex(index)
        }
    }
    
    private func collisionTestWithBorder(ball: UIView, borderView: UIView) {
        let ballMaxX = ball.frame.maxX
        let ballMinX = ball.frame.minX
        let ballMaxY = ball.frame.maxY
        let ballMinY = ball.frame.minY
        
        if ballMinX <= borderView.frame.minX {
            self.ballXSpeed *= -1
        } else if ballMaxX >= borderView.frame.maxX {
            self.ballXSpeed *= -1
        } else if ballMinY <= borderView.frame.minY {
            self.ballYSpeed *= -1
        } else if ballMaxY >= borderView.frame.maxY {
            self.ballYSpeed *= -1  // should be game over
        }
    }
    
    private func collisionTestWithMover(ball: UIView, mover: UIView) {
        let ballMaxX = ball.frame.maxX
        let ballMinX = ball.frame.minX
        let ballMaxY = ball.frame.maxY
        let ballMinY = ball.frame.minY
        
        if ballMaxY >= mover.frame.minY && (ballMaxX >= mover.frame.minX && ballMaxX <= (mover.frame.maxX + ball.bounds.width)) {
            self.ballYSpeed *= -1
        }
    }
}

/// setting 
class SettingGUIView: UIView {
    
    private var startBtn: UIButton!
    private var pauseOrResumeBtn: UIButton!
    private var durationLabel: UILabel!
    
    private var rowLabel: UILabel!
    private var rowSlider: UISlider!
    
    private var columnLabel: UILabel!
    private var columnSlider: UISlider!
    
    private var ballWidthLabel: UILabel!
    private var ballWidthSlider: UISlider!
    
    private var moverWidthLabel: UILabel!
    private var moverWidthSlider: UISlider!
    
    private var color: UIColor = UIColor.blueColor()
    
    private var startX: CGFloat = 10
    private var startY: CGFloat = 10
    private var labelWidth: CGFloat = 80
    private var labelHeight: CGFloat = 25
    private var horizontalSpace: CGFloat = 5
    private var verticalSpace: CGFloat = 5
    private lazy var selfW: CGFloat = { return self.frame.width }()
    private lazy var selfH: CGFloat = { return self.frame.height }()
    
    private lazy var btnW: CGFloat = { return 50 }()
    private lazy var btnH: CGFloat = { return self.btnW }()
    private lazy var btnSpace: CGFloat = { return (self.selfW - 2*self.btnW)/3.0 }()
    private lazy var btnStartX: CGFloat = { return (self.selfW - self.btnSpace - 2*self.btnW)/2.0 }()
    
    // call back
    private var callback: () -> () = {()->() in}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showInView(view: UIView, settingFinishHandler:() -> () = {()->() in}) {
        self.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(self)
        self.callback = settingFinishHandler
        
        createUI()
    }
    
    private func dismiss() {
        self.callback()
        self.removeFromSuperview()
    }
}

extension SettingGUIView {
    private func createUI() {
        setUpUI()
        layoutUI()
        configureUI()
    }
    
    private func setUpUI() {
        self.startBtn = UIButton(type: .Custom)
        self.addSubview(self.startBtn)
        
        self.pauseOrResumeBtn = UIButton(type: .Custom)
        self.addSubview(self.pauseOrResumeBtn)
        
        self.durationLabel = UILabel()
        self.addSubview(self.durationLabel)
        
        self.rowLabel = UILabel()
        self.addSubview(self.rowLabel)
        
        self.rowSlider = UISlider()
        self.addSubview(self.rowSlider)
        
        self.columnLabel = UILabel()
        self.addSubview(self.columnLabel)

        self.columnSlider = UISlider()
        self.addSubview(self.columnSlider)

        self.ballWidthLabel = UILabel()
        self.addSubview(self.ballWidthLabel)

        self.ballWidthSlider = UISlider()
        self.addSubview(self.ballWidthSlider)

        self.moverWidthLabel = UILabel()
        self.addSubview(self.moverWidthLabel)

        self.moverWidthSlider = UISlider()
        self.addSubview(self.moverWidthSlider)

    }
    
    private func layoutUI() {
        
        self.rowLabel.frame = CGRect(x: self.startX, y: self.startY, width: self.labelWidth, height: self.labelHeight)
        setFrameForView(self.rowSlider, reference: self.rowLabel, direction: .horizontal)
        setFrameForView(self.columnLabel, reference: self.rowLabel, direction: .vertical)
        setFrameForView(self.columnSlider, reference: self.columnLabel, direction: .horizontal)
        setFrameForView(self.ballWidthLabel, reference: self.columnLabel, direction: .vertical)
        setFrameForView(self.ballWidthSlider, reference: self.ballWidthLabel, direction: .horizontal)
        setFrameForView(self.moverWidthLabel, reference: self.ballWidthLabel, direction: .vertical)
        setFrameForView(self.moverWidthSlider, reference: self.moverWidthLabel, direction: .horizontal)
        
        self.startBtn.frame = CGRect(x: self.btnStartX, y: self.moverWidthLabel.frame.maxY+self.verticalSpace, width: self.btnW, height: self.btnH)
        
        self.pauseOrResumeBtn.frame = self.startBtn.frame
        self.pauseOrResumeBtn.frame.origin.x += (self.btnSpace + self.btnW)
        
        self.durationLabel.frame = CGRectZero
    }
    
    private func configureUI() {
        self.rowLabel.backgroundColor = color
        configureLabel(self.rowLabel, title: "rows:")
        
        self.rowSlider.backgroundColor = color
        configureSlider(self.rowSlider, min: 1, max: 7, defaultValu: 3)
        
        self.columnLabel.backgroundColor = color
        configureLabel(self.columnLabel, title: "columns:")
        
        self.columnSlider.backgroundColor = color
        configureSlider(self.columnSlider, min: 1, max: 10, defaultValu: 5)
        
        self.ballWidthLabel.backgroundColor = color
        configureLabel(self.ballWidthLabel, title: "ballWidth:")
        
        self.ballWidthSlider.backgroundColor = color
        configureSlider(self.ballWidthSlider, min: 3, max: 30, defaultValu: 10)
        
        self.moverWidthLabel.backgroundColor = color
        configureLabel(self.moverWidthLabel, title: "moverWidth:")
        
        self.moverWidthSlider.backgroundColor = color
        configureSlider(self.moverWidthSlider, min: 3, max: 200, defaultValu: 100)
        
        self.startBtn.backgroundColor = color
        self.pauseOrResumeBtn.backgroundColor = color
        self.durationLabel.backgroundColor = color
    }
}

extension SettingGUIView {
    enum layoutDirection: Int {
        case horizontal = 1
        case vertical = 2
    }
    private func setFrameForView(target: UIView, reference: UIView, direction: layoutDirection) {
        switch direction {
        case .horizontal:
            target.frame = reference.frame
            target.frame.origin.x = reference.frame.maxX + self.horizontalSpace
            target.frame.size.width = self.selfW - target.frame.minX - self.startX
        case .vertical:
            target.frame = reference.frame
            target.frame.origin.y = reference.frame.maxY + self.verticalSpace
            target.frame.size.height = reference.frame.height
        default:
            break
        }
    }
}

extension SettingGUIView {
    private func configureLabel(label: UILabel, title: String) {
        label.text = title
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Left
    }
    
    private func configureSlider(slider: UISlider, min: Float, max: Float, defaultValu: Float) {
        slider.minimumValue = min
        slider.maximumValue = max
        slider.value = defaultValu
    }
}
