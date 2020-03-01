//
//  MyAuctionVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/25/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class MyAuctionVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewAuction: UICollectionView!
    @IBOutlet weak var btnSeller: UIButton!
    @IBOutlet weak var btnBuyer: UIButton!
    @IBOutlet weak var viewSellerSeparater: UIView!
    @IBOutlet weak var viewBuyerSeparater: UIView!
    @IBOutlet weak var btnActiveAuction: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var imgviewTab: UIImageView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewRate: UIView!

    // MARK: - Property initialization
    private var userType = 200
    private var arrProduct = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Perform Get user product API
        getUserProductAPI_Call("seller")
    }

    // MARK: - Action Methods
    @IBAction func btnProfileType_Action(_ sender: UIButton) {
        
        viewSellerSeparater.backgroundColor = sender.tag == 200 ? colorAppTheme : colorLightGray
        viewBuyerSeparater.backgroundColor = sender.tag == 200 ? colorLightGray : colorAppTheme
        
        userType = sender.tag
        
        if sender.tag == 200 {
            btnSeller.setTitleColor(colorAppTheme, for: .normal)
            btnBuyer.setTitleColor(colorLight, for: .normal)
            
            // Perform Get user product API
            getUserProductAPI_Call("seller")
        }
        else {
            btnBuyer.setTitleColor(colorAppTheme, for: .normal)
            btnSeller.setTitleColor(colorLight, for: .normal)
            
            // Perform Get user product API
            getUserProductAPI_Call("buyer")
        }
        
        imgviewTab.image = UIImage(named: "tab")
        btnActiveAuction.setTitleColor(.white, for: .normal)
        btnHistory.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func productType_Action(_ sender: UIButton) {
        if sender.tag == 300 {
            imgviewTab.image = UIImage(named: "tab")

            btnActiveAuction.setTitleColor(.white, for: .normal)
            btnHistory.setTitleColor(.black, for: .normal)

            if userType == 200 {
                // Perform Get user product API
                getUserProductAPI_Call("seller")
            }
            else {
                // Perform Get user product API
                getUserProductAPI_Call("buyer")
            }
        }
        else {
            imgviewTab.image = UIImage(named: "tab2")

            btnActiveAuction.setTitleColor(.black, for: .normal)
            btnHistory.setTitleColor(.white, for: .normal)

            if userType == 200 {
                // Perform Get user product history API
                getProductHistoryAPI_Call("seller")
            }
            else {
                // Perform Get user product history API
                getProductHistoryAPI_Call("buyer")
            }
        }
    }

    // MARK: - API Methods
    private func getUserProductAPI_Call(_ type: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_Type       : type as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getAllUserProducts(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["responseData"].arrayObject != nil {
                let arrTemp = jsonObj["responseData"].arrayObject! as NSArray
                self?.arrProduct = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewAuction.reloadData()
            }
        }
    }

    private func getProductHistoryAPI_Call(_ type: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_Type       : type as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getUserHistoryProduct(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["responseData"].arrayObject != nil {
                let arrTemp = jsonObj["responseData"].arrayObject! as NSArray
                self?.arrProduct = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewAuction.reloadData()
            }
        }
    }

    private func cancelBidAPI_Call(_ bidId: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_BidId : bidId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.bidCancel(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["responseData"].arrayObject != nil {
                let arrTemp = jsonObj["responseData"].arrayObject! as NSArray
                self?.arrProduct = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewAuction.reloadData()
            }
        }
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension MyAuctionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionCell", for: indexPath) as? AuctionCell
        
        let dictProduct = arrProduct[indexPath.item] as? NSDictionary
        
        let isSeller = userType == 200 ? true : false
        cell?.configureCell(dictProduct!, isSeller: isSeller)
        
        cell?.deleteHandler = {
            
        }
        
        cell?.editHandler = {
            
        }
        
        cell?.allBidHandler = {
            
            let dictProduct = self.arrProduct[indexPath.item] as? NSDictionary

            if self.userType == 200 {
                let vc = Util.loadViewController(fromStoryboard: "AllBidVC", storyboardName: "Home") as? AllBidVC
                if let aVc = vc {
                    aVc.hidesBottomBarWhenPushed = true
                    aVc.productId = dictProduct!["id"] as! String
                    self.show(aVc, sender: nil)
                }
            }
            else {
                
            }
        }
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
