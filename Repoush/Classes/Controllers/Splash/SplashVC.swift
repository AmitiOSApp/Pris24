//
//  SplashVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/22/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    // MARK: - IBOutlets
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if UserDefaults.standard.bool(forKey: Key_UD_IsUserLoggedIn) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { [weak self] in
                
                LoggedInUser.shared.initializeFromUserDefault()
                
                let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
                if let aVc = vc {
                    self?.present(aVc, animated: true, completion: nil)
                }
            })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { [weak self] in
                let objLogin = self?.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                self?.navigationController?.show(objLogin!, sender: nil)
            })
        }
    }

}
