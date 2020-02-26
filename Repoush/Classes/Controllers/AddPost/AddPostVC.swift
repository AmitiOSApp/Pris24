//
//  AddPostVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/25/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewPostImage: UICollectionView!
    @IBOutlet weak var collectionViewCategory: UICollectionView!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnKids: UIButton!
    @IBOutlet weak var txfSelling: UITextField!
    @IBOutlet weak var btnSize: UIButton!
    @IBOutlet weak var btnGender: UIButton!
    @IBOutlet weak var txfCondition: UITextField!
    @IBOutlet weak var txfOriginalPrice: UITextField!
    @IBOutlet weak var txfOfferPrice: UITextField!
    @IBOutlet weak var txfDiscountPercent: UITextField!
    @IBOutlet weak var txfBrand: UITextField!
    @IBOutlet weak var txvDescription: CustomTextview!
    @IBOutlet weak var btnRegisteredAddress: UIButton!
    @IBOutlet weak var btnNewAddress: UIButton!

    // MARK: - Property initialization
    private enum ActionType: Int {
        case women = 100, kids, size, gender, registeredAddress, newAddress, postNow
    }
    private var categoryId = 1
    private var arrSubcategory = NSMutableArray()
    private var selectedIndex = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Perform Get subcategory API
        getSubcategoryAPI_Call()
    }
    
    // MARK: - Action Methods
    @IBAction func btnUser_Action(_ sender: UIButton) {
        if sender.tag == ActionType.women.rawValue {
            btnWomen.isSelected = true
            btnKids.isSelected = false
            
            categoryId = 1
            
            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
        else if sender.tag == ActionType.kids.rawValue {
            btnWomen.isSelected = false
            btnKids.isSelected = true
            
            categoryId = 2

            // Perform Get subcategory API
            getSubcategoryAPI_Call()
        }
    }

    // MARK: - API Methods
    private func getSubcategoryAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_CategoryId : categoryId as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getSubCategory(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["subcategory_data"].arrayObject != nil {
                let arrTemp = jsonObj["subcategory_data"].arrayObject! as NSArray
                self?.arrSubcategory = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewCategory.reloadData()
            }
        }
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AddPostVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory {
            return arrSubcategory.count
        }
        else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
            
            let dictSubcategory = arrSubcategory[indexPath.item] as? NSDictionary
            
            cell?.lblSubcategoryName.text = dictSubcategory!["subcategory_name"] as? String
            
            if indexPath.item == selectedIndex {
                cell?.imgviewSubcategory.layer.borderColor = UIColor.green.cgColor
                cell?.imgviewSubcategory.layer.borderWidth = 2.0
            }
            else {
                cell?.imgviewSubcategory.layer.borderColor = UIColor.clear.cgColor
                cell?.imgviewSubcategory.layer.borderWidth = 0.0
            }
            
            if Util.isValidString(dictSubcategory!["subcategory_image"] as! String) {
                
                let imageUrl = dictSubcategory!["subcategory_image"] as! String
                
                let url = URL.init(string: imageUrl)!
                
                cell?.imgviewSubcategory.kf.indicatorType = .activity
                cell?.imgviewSubcategory.kf.indicator?.startAnimatingView()
                
                let resource = ImageResource(downloadURL: url)
                
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        cell?.imgviewSubcategory.image = value.image
                    case .failure( _):
                        cell?.imgviewSubcategory.image = UIImage(named: "product1")
                    }
                    cell?.imgviewSubcategory.kf.indicator?.stopAnimatingView()
                }
            }
            else {
                cell?.imgviewSubcategory.image = UIImage(named: "product1")
            }
            return cell!
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell
            
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCategory {
            selectedIndex = indexPath.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
