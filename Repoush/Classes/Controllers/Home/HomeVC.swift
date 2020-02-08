//
//  HomeVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewPost: UICollectionView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewLookAt: UIView!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnKids: UIButton!
    @IBOutlet weak var viewWomenSeparater: UIView!
    @IBOutlet weak var viewKidsSeparater: UIView!

    // MARK: - Property initialization
    private var isWomen = false
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Methods
    @IBAction func btnLookAt_Action(_ sender: UIButton) {
        
        isWomen = sender.tag == 100 ? true : false
        
        viewBG.isHidden = true
        viewLookAt.isHidden = true
    }
    
    @IBAction func btnPostType_Action(_ sender: UIButton) {
        
        viewWomenSeparater.backgroundColor = sender.tag == 200 ? colorAppTheme : colorLightGray
        viewKidsSeparater.backgroundColor = sender.tag == 200 ? colorLightGray : colorAppTheme
        
        if sender.tag == 200 {
            btnWomen.setTitleColor(colorAppTheme, for: .normal)
            btnKids.setTitleColor(colorLight, for: .normal)
        }
        else {
            btnKids.setTitleColor(colorAppTheme, for: .normal)
            btnWomen.setTitleColor(colorLight, for: .normal)
        }
    }
    
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width / 2) - 4, height: (collectionView.frame.size.width / 2) + 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
}
