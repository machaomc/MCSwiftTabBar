//
//  DemotabController.swift
//  MCSwiftTabBar_Example
//
//  Created by machao on 2019/10/17.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
@_exported import MCSwiftTabBar


class DemotabController: MCtabController {

    override func viewDidLoad() {

        self.tabBarNormalImages = ["tabbarOne_normal","tabbarTwo_normal","tabbarThree_normal"]
        self.tabBarSelectImages = ["tabbarOne_selected","tabbarTwo_selected","tabbarThree_selected"]
        self.tabBarTitles = ["首页","发现","个人中心"]
        self.tabBarBigIndex = 1
        self.tabBarControolers = [UINavigationController.init(rootViewController:ViewController() ),UINavigationController.init(rootViewController:ViewController()),UINavigationController.init(rootViewController:ViewController())]
        
        super.viewDidLoad()
    }

}
