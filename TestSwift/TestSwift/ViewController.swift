//
//  ViewController.swift
//  TestSwift
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView! = nil
    let items: Int = 1
    let sections:Int = 3
    
    let systemCellIdentifier:String = "systemCellType"
    let nibCellIdentifier:String = "nibCellType"
    let customCellIdentifier:String = "customCellType"
    
    let systemFooterIdentifier:String = "systemFooterType"
    let nibFooterIdentifier:String = "nibFooterType"
    let customFooterIdentifier:String = "customFooterType"
    
    let systemHeaderIdentifier:String = "systemHeaderType"
    let nibHeaderIdentifier:String = "nibHeaderType"
    let customHeaderIdentifier:String = "customHeaderType"
    
    let threeCircleDataViewId: String = "threeCircleDataViewId"
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 打印测试
        print("hello world !");
        
        //syntaxTast()
        
        //collectionViewAbout()
        
        
//        testWaveBtn()
        
        
        callThisMethodInViewDidLoad()
    }
    
    func testWaveBtn() {
//        let circleBtn: UIButton = UIButton(type: .Custom)
//        circleBtn.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        circleBtn.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//        circleBtn.backgroundColor = UIColor.blueColor()
//        circleBtn.layer.cornerRadius = circleBtn.frame.width/2
//        circleBtn.layer.borderColor = UIColor.orangeColor().CGColor
//        circleBtn.layer.borderWidth = 3
//        circleBtn.clipsToBounds = true
//        circleBtn.userInteractionEnabled = false
//        
//        //circleBtn.setBackgroundImage(UIImage(named: "u=4241713225,1400580340&fm=21&gp=0.jpg"), forState: .Normal)
//        ///circleBtn.setImage(UIImage(named: "u=4241713225,1400580340&fm=21&gp=0.jpg"), forState: .Normal)
//        //circleBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        //circleBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 300, right: 10)
//        self.view.addSubview(circleBtn)
//        
//        let imageView: UIImageView = UIImageView(image: UIImage(named: "u=4241713225,1400580340&fm=21&gp=0.jpg"))
//        circleBtn.addSubview(imageView)
//        imageView.frame = circleBtn.bounds
//        imageView.frame.size.height *= 2
//        imageView.frame.size.width -= 0
//        imageView.frame.origin.y += 10
        
        
        
        let proView = ProbabilityDataView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height:150))
        proView.backgroundColor = UIColor.greenColor()
        proView.setPersents("40", centerPersent: "10", rightPersent: "90")
        proView.setBottomText("30", centerText: "10", rightText: "")
        self.view.addSubview(proView)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
// MARK : CollectionView 测试
    func collectionViewAbout() -> Void {
        
//        let tcvvc: TestUICollectionViewController! = TestUICollectionViewController()
//        self.navigationController?.presentViewController(tcvvc, animated: true, completion: { 
//            print("已经加载 CollectionView 控制器")
//        })
        
        initCollectionView()
    }
    
// MARK: - MYSelfMethod
    private func initCollectionView() {
        let collectionViewLayout:UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout.itemSize = CGSize(width: 60, height: 70)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        collectionViewLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout:collectionViewLayout)
        self.view.addSubview(collectionView)
        registerCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollEnabled = true
        collectionView.bounces = true
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.reloadData()
        
        collectionView.backgroundView = UIImageView(image: UIImage(named: "u=4241713225,1400580340&fm=21&gp=0.jpg"))
    }
    
    func registerCollectionView() -> Void {
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: systemCellIdentifier)
        collectionView.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        //collectionView.registerClass(NibCollectionViewCell.self, forCellWithReuseIdentifier: nibCellIdentifier)
        let cellNib = UINib(nibName: "NibCollectionViewCell", bundle: NSBundle.mainBundle())
        collectionView.registerNib(cellNib, forCellWithReuseIdentifier: nibCellIdentifier)
        
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: systemHeaderIdentifier)
        
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: systemFooterIdentifier)
        
        collectionView.registerClass(WisdomDefineResultNewCell.self, forCellWithReuseIdentifier: self.threeCircleDataViewId)
    }
    
    
// MARK: - UICollectionViewDataSource
    
    // required (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items
    }
    
    // required (ios 6.0, *) // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
//            let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(systemCellIdentifier, forIndexPath: indexPath)
            let cell: WisdomDefineResultNewCell = collectionView.dequeueReusableCellWithReuseIdentifier(self.threeCircleDataViewId, forIndexPath: indexPath) as! WisdomDefineResultNewCell
//            cell.backgroundColor = UIColor.greenColor()
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(customCellIdentifier, forIndexPath: indexPath)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(nibCellIdentifier, forIndexPath: indexPath) as! NibCollectionViewCell
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    
    // optional (ios 6.0, *)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections
    }
    
    
    // optional (ios 6.0, *) // The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let systemHeader:UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: systemHeaderIdentifier, forIndexPath: indexPath)
        systemHeader.backgroundColor = UIColor.yellowColor()
        
        let systemFooter:UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: systemFooterIdentifier, forIndexPath: indexPath)
        systemFooter.backgroundColor = UIColor.whiteColor()
        
        return systemHeader
    }
    
    
    // optional (ios 9.0, *)
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 9.0, *)
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
 
    
// MARK: - UICollectionViewDelegate
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *) // called when the user taps on an already-selected item in multi-select mode
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 8.0, *)
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 8.0, *)
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        
    }
    
    
// MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            if indexPath.row%3 == 0 {
                return CGSize(width: collectionView.bounds.width, height: 560+45-10)
            }
            else {
                return CGSize(width: 80, height: 90)
            }
        } else if indexPath.section == 1 {
            return CGSize(width: collectionView.bounds.width/2-30, height: 100)
        }
        else {
            return CGSize(width: 321, height: 100)
        }
        
        return CGSizeZero
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        return edgeInsets
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 80)
        return CGSizeZero
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: 100)
        return CGSizeZero
    }
    
    
// MARK :
// MARK :
// MARK : 语法测试
    
    func syntaxTast() -> Void {
        //singleValue();
        //streamControl();
        //functionAndCloser();
    }
    
// 简单值
    func singleValue() -> Void {
        // 变量测试
        var myVariable = 100;
        myVariable = 200;
        print("myVariable = \(myVariable)");
        
        
        // 常量测试
        let myConst = 300;
        //myConst = 100;   //报错
        print("myconst = \(myConst)");
        
        
        // 显式指定类型
        let myInteger:NSInteger = 100;
        //var myFloatInteger:NSInteger = 200.123;   //报错
        let myFloat:Float = 100.123;
        print("myInteger = \(myInteger) myFloat = \(myFloat)");
        
        
        // 显式类型转换
        let myStirng = "it is a stirng !";
        let myNumber = 123;
        let myNumToStr = myStirng + String(myNumber);
        //let myNumToStr = myStirng + myNumber;   //+ 运算符不能用于stirng 和 int类型之间
        print("myNumToStr = \(myNumToStr)");
        
        
        // 把值转换为字符串的简洁方法
        let num1 = 1;
        let num2 = 2;
        let words = "please calculate \(num1) + \(num2) = \(num1 + num2)";
        print(words);
        
        
        // 创建数组和字典
        var myArray = ["1", "2", "3",];
        myArray[0] = "123";
        //myArray[3] = "5";    //程序崩溃，访问下表越界
        //myArray[4] = 7;      //类型不符合数组元素类型
        print("myArray is : \(myArray)");
        
        var myDictionary = ["1":1, "2":2, "3":3];
        myDictionary["1"] = 123;
        //myDictionary[4] = 4;        //key 类型不符
        myDictionary["4"] = 4;
        //myDictionary["5"] = "5";    //value 类型不符
        print("myDictionary is : \(myDictionary)");
        
        
        // 创建空数组和字典
        var emptyArray = [String]();
        var emptyDictionary = [String:Float]();
        
        var emptyArray1 = [];        //可推断类型信息时候
        var emptyDictionary1 = [:];  //可推断类型信息时候
        
        print("\(emptyArray)\(emptyArray1)\(emptyDictionary)\(emptyDictionary1)")
    }

    
// 流控制
    func streamControl() -> Void {
        
        // 值缺失
        var optionalName:String? = "jec";
        print("optionalName = \(optionalName)");      //Optional("jec")
        //optionalName = nil;
        print("optionalName = \(optionalName)");      //nil
        
        
        // 处理值缺失的情况
        // if 和 let
        var greeting = "hello!";
        if let name = optionalName {
            //greeting = greeting + optionalName;  //optionalName 出错
            greeting = "hello \(name) !";          //optionalName 不为 nil , name 被赋值为 optionalName 的实际值
        }
        else {
            greeting = "sorry you have no name !"; //optionalName 为 nil
        }
        print("greeting : \(greeting)");
        
        // 使用 ?? 操作符提供默认值
        let nicName:String? = nil;//"abc";
        let fullName:String = "jec";
        let greetingInfo = "hello \(nicName ?? fullName)";
        print("greetInfo = \(greetingInfo)");
        
        
        // switch 语句 任意类型值的各种比较
        let variable = "red ";
        switch variable {
        case "red":
            print("red");
        case "blue", "green":
            print("blue or green");
        case let x where x.hasSuffix("red "):
            print(".......red.......");
        default: // 没有会报错 , case 后不需要 break
            print("default");
        }
        
        
        // for-in 遍历字典 和 数组
        let data = ["single":[1, 2, 3, 4, 5,],
                    "ten":[10, 20, 30, 40, 50,],
                    "hundred":[100, 200, 300, 400, 500]];
        var largest = 0;
        var largestType = "single";
    
        for (kind, numbers) in data {   //(kind, number) 用来标示每一个键值对
            for number in numbers {     //number 用来标示数组中的每一个值
                if number > largest {
                    largest = number;
                    largestType = kind;
                }
            }
        }
        print("largest number is \(largest) , type is \(largestType)");
        
        
        // while 循环
        var n = 0;
        while n < 100 {
            n += 1; // ++ 运算符现在不提倡使用，在swift3 以后会取消该运算符
        }
        print("in while n is : \(n)");
        
        
        // repeat-while 循环
        repeat {
            n -= 1; // n--;
        } while n > 0;
        print("in repeat-while n is : \(n)");
        
        
        // ..< 和 ... 表示范围
        var firstForLoop = 0;
        for i in 0..<10 {
            firstForLoop += i;
        }
        print("firstLoop is \(firstForLoop)");
        
        // 传统写法
        var secondLoop = 0;
        for var i = 0; i<10; i++ {
            secondLoop += i;
        }
        print("secondLoop is \(secondLoop)");
        
    }
    
    
// 函数和闭包
    func functionAndCloser() -> Void {
        
        print("greet is \(greet("jec", day: "Wednesday", food: "race"))");
        
        let statistics = calculateStatistics([70, 80, 90, 100, 90, 80, 70]);
        print("the max score is \(statistics.max)");
        print("the min score is \(statistics.0)");            //元组中的元素可以用名称或数字来表示和访问
        print("the sum of these scors is \(statistics.2)");
        
        print("average is \(averageOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0))");
        
    }
    
    // 一般函数
    func greet(name:String, day:String, food:String) -> String {
        return "hello \(name) , today is \(day), let us eat \(food) !";
    }
    
    // 元组返回多个值
    func calculateStatistics(scores:[Int]) -> (min:Int, max:Int, sum:Int) {
        var min = scores[0];
        var max = scores[0];
        var sum = 0;
        
        for score in scores {
            if score > max {
                max = score;
            }
            else if score < min {
                min = score;
            }
            sum += score;
        }
        return (min, max, sum);
    }
    
    // 可变个数参数函数
    func averageOf(numbers:Int...) -> Float {
        var sum = 0;
        var count = 0;
        for number in numbers {
            sum += number;
            count += 1;
        }
        return Float(sum/count);
    }
    
    
///////////////////////////////////
    
//////////////////////////////////
    
 
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




///////////////////////////////////

//////////////////////////////////

// 枚举
enum Rank: Int {            // 该枚举的原始类型是Int
    case Ace = 1;
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten;
    case Jack, Queen, King;
    func simpleDescription() -> String {
        switch self {
        case .Ace:          // .Ace
            return "Ace";
        case .Jack:
            return "Jack";
        case .Queen:
            return "Queen";
        case .King:
            return "King";
        default:
            return String(self.rawValue);
        }
    }
}
let ace = Rank.Ace;
let aceRawValue = ace.rawValue;

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    func simpleDescription() -> String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    } }
let hearts = Suit.Hearts
let heartsDescription = hearts.simpleDescription()


// 结构体
struct Card {
    var rank : Rank;
    var suit : Suit;
    func simpleDescription() -> String {
        return "the \(rank.simpleDescription()) of \(suit.simpleDescription())";
    }
}
let threeOfSpades = Card(rank : .Three, suit: .Spades);        // 注意结构体的初始化方式 Card(rank : .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription();


// 协议和扩展
protocol ExempleProtocol {
    var simpleDescription : String {get};
    mutating func adjust();
}

//enum SimpleEnum : ExempleProtocol {
//    case var simpleDescription: String = "a simple enum";
//    mutating func adjust() {
//        simpleDescription += "(adjusted)";
//    }
//}

