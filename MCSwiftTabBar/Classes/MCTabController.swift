//
//  MCTabController.swift
//  MCSwiftTabBar
//
//  Created by machao on 2019/10/17.
//

import Foundation
import UIKit

open class MCtabController: UITabBarController,MainTabBarDelegate {
    
    private var mainTabBarView: MainTabBarView!
    open var tabBarControolers:[UIViewController]?
    open var tabBarNormalImages:[String]?
    open var tabBarSelectImages:[String]?
    open var tabBarTitles:[String]?
    open var tabBarInitSelectIndex:NSInteger = 0
    open var tabBarBigIndex:NSInteger = -1
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tabBar.isTranslucent = false

        
        if let arr = self.tabBarControolers {
            self.viewControllers = arr
            
            for vc in arr{
                let vcNav:UINavigationController! = vc as? UINavigationController
                let vcMC = vcNav.viewControllers.first as! MCBaseController
                vcMC.hidesBarWhenPushed = false
            }
            
            var tarbarConfigArr:Array<Dictionary<String,String>> = []
            for i in 0..<arr.count {
                
                var dic:Dictionary<String, String> = [:]
                if let arrNormal = self.tabBarNormalImages   {
                    let normal:String = arrNormal[i]
                    dic.updateValue(normal, forKey: "NormalImg")
                }
                
                if let arrSelect = self.tabBarSelectImages  {
                    let select = arrSelect[i]
                    dic.updateValue(select, forKey: "SelectedImg")
                }
                
                if let arrTitle = self.tabBarTitles  {
                    let title = arrTitle[i]
                    dic.updateValue(title, forKey: "Title")
                }
                tarbarConfigArr.append(dic)
            }
            
            
            var bottomFloat:CGFloat = 0.0
            if UIDevice.current.isiPhoneXMore() {
//                print("留海屏幕")
                bottomFloat = 34
            }
            
            var tabBarRect = self.tabBar.frame;
            tabBarRect.origin.y = tabBarRect.origin.y-bottomFloat
            tabBarRect.size.height = tabBarRect.size.height+bottomFloat
            
            
            
            mainTabBarView = MainTabBarView(frame: tabBarRect,tabbarConfigArr:tarbarConfigArr,IndexBig: self.tabBarBigIndex,InitSelectIndex: tabBarInitSelectIndex);
            mainTabBarView.delegate = self
            
            self.view.addSubview(mainTabBarView)
            
        }

        
    }
   
    func showTabBarAction() {

        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.mainTabBarView.frame
            frame.origin.x = 0
            self.mainTabBarView.frame = frame
        }) { (make) -> Void in
        }
    }
    
    func hiddenTabBarAction() {
        UIView.animate(withDuration: 0.3, animations: {
            var frame = self.mainTabBarView.frame
            frame.origin.x = 0 - self.mainTabBarView.bounds.size.width
            self.mainTabBarView.frame = frame
        }) { (make) -> Void in
        }
    }
    
    
    func didChooseItem(itemIndex: Int) {
        self.selectedIndex = itemIndex
        print("点击",itemIndex)
    }
    
}


extension UIDevice {
    public func isiPhoneXMore() -> Bool {
        let screenHeight = UIScreen.main.nativeBounds.size.height;
        if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
            return true
        }
        return false
    }
}

 //自定义标签栏代理协议
protocol MainTabBarDelegate {
    func didChooseItem(itemIndex:Int)
}

class MainTabBarView: UIView {
    var delegate:MainTabBarDelegate?    //代理,点击item
    var itemArray:[MainTabBarItem] = [] //标签Item数组
    var tabBarBigIndex:NSInteger!
    var tabBarItemCount:NSInteger!

    init(frame: CGRect,tabbarConfigArr:[Dictionary<String,String>],IndexBig:Int,InitSelectIndex:Int) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let screenW = UIScreen.main.bounds.size.width
        let itemWidth = screenW / CGFloat(tabbarConfigArr.count)
        self.tabBarBigIndex = IndexBig
        self.tabBarItemCount = tabbarConfigArr.count
        for i in 0..<tabbarConfigArr.count{
            let itemDic = tabbarConfigArr[i];
            
            var bottomFloat:CGFloat = 0.0
            if UIDevice.current.isiPhoneXMore() {
                bottomFloat = 34
            }
            
            let itemFrame = CGRect(x: itemWidth * CGFloat(i) , y: 0, width: itemWidth, height: frame.size.height-bottomFloat)
            //创建Item视图
            let itemView = MainTabBarItem(frame: itemFrame, itemDic:itemDic, itemIndex: i ,indexBig: IndexBig)
            self.addSubview(itemView)
            self.itemArray.append(itemView)
            //添加事件点击处理
            itemView.tag = i
            itemView.addTarget(self, action:#selector(self.didItemClick(item:))  , for: UIControl.Event.touchUpInside)
            //默认点击第一个,即首页
            if i == InitSelectIndex {
                self.didItemClick(item: itemView)
            }
        }
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //点击单个标签视图，通过currentSelectState的属性观察器更新标签item的显示
    //并且通过代理方法切换标签控制器的当前视图控制器
    @objc func didItemClick(item:MainTabBarItem){
        for i in 0..<itemArray.count{
            let tempItem = itemArray[i]
            if i == item.tag{
                tempItem.currentSelectState = true
            }else{
                tempItem.currentSelectState = false
            }
        }
        //执行代理方法
        self.delegate?.didChooseItem(itemIndex: item.tag)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        let top:CGFloat = -20.0
        
        let itemWidth = UIScreen.main.bounds.size.width/CGFloat(self.tabBarItemCount)
        
        if point.y > top && point.y < 0 && point.x > itemWidth*CGFloat(self.tabBarBigIndex) && point.x < itemWidth*CGFloat(self.tabBarBigIndex+1) {
                let pointChange:CGPoint = CGPoint.init(x: point.x, y: 0)
                return super.hitTest(pointChange, with: event)
            }else{
                return super.hitTest(point, with: event)
            }
    }
}

class MainTabBarItem: UIControl {
    var itemDic:Dictionary<String, String>
    let imgView: UIImageView
    let titleLabel: UILabel
    let indexTAG: NSInteger
    
    //属性观察器
    var currentSelectState = false {
        didSet{
            if currentSelectState {
                //被选中
                imgView.image = UIImage(named:itemDic["SelectedImg"]!)
                titleLabel.textColor = UIColor.red
            }else{
                //没被选中
                imgView.image = UIImage(named: itemDic["NormalImg"]!)
                titleLabel.textColor = UIColor.lightGray
            }
        }
    }
   
    init(frame:CGRect, itemDic:Dictionary<String, String>, itemIndex:Int ,indexBig:Int) {
        self.itemDic = itemDic
       
        //布局使用的参数
        let defaulutLabelH:CGFloat = 20.0 //文字的高度
        var imgTop:CGFloat = 3
        var imgWidth:CGFloat = 25
        //中间的按钮的布局参数做特殊处理
        if itemIndex == indexBig{
            imgTop = -20
            imgWidth = 50
        }
        self.indexTAG = itemIndex
        let imgLeft:CGFloat = (frame.size.width - imgWidth)/2
        let imgHeight:CGFloat  = frame.size.height - defaulutLabelH - imgTop
        //图片
        imgView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width:imgWidth, height:imgHeight))
        imgView.image = UIImage(named: itemDic["NormalImg"]!)
        imgView.contentMode = UIView.ContentMode.scaleAspectFit
        //title
        titleLabel = UILabel(frame:CGRect(x: 0, y: frame.height - defaulutLabelH, width: frame.size.width, height: defaulutLabelH))
        titleLabel.text = itemDic["Title"]!
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.textColor = UIColor.lightGray
       
        super.init(frame: frame)
        self.addSubview(imgView)
        self.addSubview(titleLabel)
        
       
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}


