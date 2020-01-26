//
//  LoginVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/23/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - IBOutlets
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    @IBAction func btnLogin_Action(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
        if let aVc = vc {
            present(aVc, animated: true)
        }
    }

}
