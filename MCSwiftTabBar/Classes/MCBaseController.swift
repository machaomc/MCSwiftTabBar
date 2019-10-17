//
//  MCBaseController.swift
//  MCSwiftTabBar
//
//  Created by machao on 2019/10/17.
//

import Foundation

open class MCBaseController: UIViewController {
    
    var hidesBarWhenPushed:Bool = true
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarhidden()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    func tabBarhidden() {
        if hidesBarWhenPushed  {
//            print("隐藏")
            
            if let tabBar = self.tabBarController  {
                let tabVC:MCtabController = tabBar as! MCtabController
                tabVC.hiddenTabBarAction()
            }else{
                let window = UIApplication.shared.windows[0]
                let tabVC:MCtabController = window.rootViewController as! MCtabController
                tabVC.hiddenTabBarAction()
            }
            
        }else{
//            print("出现")
            
            if let tabBar = self.tabBarController {
                self.tabBarController?.tabBar.isHidden = true
                let tabVC:MCtabController = tabBar as! MCtabController
                tabVC.showTabBarAction()
            }else{
                let window = UIApplication.shared.windows[0]
                let tabVC:MCtabController = window.rootViewController as! MCtabController
                tabVC.tabBar.isHidden = true
                tabVC.showTabBarAction()
            }
            
            
        }
    }
    
}


