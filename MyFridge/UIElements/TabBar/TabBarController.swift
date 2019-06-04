//
//  PMTabBarController.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 18/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBar()
    }
    
    private func setupViewControllers() {
        viewControllers = TabBar.viewControllers
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.tintColor = UIColor.barButtonSelected
        tabBar.unselectedItemTintColor = UIColor.barButtonUnselected
    }

}
