//
//  NavigationBar.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 07/12/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTabBar()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupTabBar()
    }
    
    private func setupTabBar() {
        self.navigationBar.barTintColor = Color.navBarColor
        if let font = UIFont(name: "\(Settings.fontName)-Bold", size: 20) {
            self.navigationBar.titleTextAttributes = [.foregroundColor: Color.navBarTitleColor, .font: font]
        }
        self.navigationBar.isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
