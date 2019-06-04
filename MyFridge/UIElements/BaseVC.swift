//
//  BaseVC.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 17/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var navigationIsHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarSetHidden(navigationIsHidden)
    }
    
    public func navigationBarSetHidden(_ isHidden: Bool) {
        if isHidden {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
        
        navigationController?.setNavigationBarHidden(isHidden, animated: true)
    }

}
