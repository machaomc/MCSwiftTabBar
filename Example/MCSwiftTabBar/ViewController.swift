//
//  ViewController.swift
//  MCSwiftTabBar
//
//  Created by 马超 on 10/17/2019.
//  Copyright (c) 2019 马超. All rights reserved.
//

import UIKit

class ViewController: MCBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 300, width: 200, height: 30)
        button.addTarget(self, action: #selector(actionbutton), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func actionbutton(sender:UIButton){
            print("点击按键",sender)

//            let na = UINavigationController.init(rootViewController: ViewController())
//            na.modalPresentationStyle = UIModalPresentationStyle.fullScreen
//        self.navigationController?.present(na, animated: true, completion: nil)
        
        let vc = ViewController()
        self.navigationController?.pushViewController(vc, animated: true)

        }

}

