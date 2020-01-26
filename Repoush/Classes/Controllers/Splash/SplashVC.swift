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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: { [weak self] in
            let objWelcome = self?.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC")
            self?.navigationController?.show(objWelcome!, sender: nil)
        })
    }

}
