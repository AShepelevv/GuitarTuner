//
//  TabBarController.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 09/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.tabBar.unselectedItemTintColor = Color.white
        self.tabBar.tintColor = Color.orange
        self.tabBar.barTintColor = Color.graphite
        self.tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Courier", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Courier", size: 10)!], for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
