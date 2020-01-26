//
//  TabBarVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {

    // MARK: - IBOutlets
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = self
    }

    // MARK: - UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")
    }

}
