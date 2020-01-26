//
//  HomeVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class HomeVC: UITabBarController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewPost: UICollectionView!
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Methods
    @IBAction func btnPostType_Action(_ sender: UIButton) {
        
    }
    
}
