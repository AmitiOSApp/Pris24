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
    @IBOutlet weak var viewPlaceBid: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblLastBidAmount: UILabel!
    @IBOutlet weak var lblTotalBid: UILabel!
    @IBOutlet weak var txfBidAmount: UITextField!

    // MARK: - Property initialization
    private var categoryId = 0
    private var arrProduct = NSMutableArray()
    private var dictProduct = NSDictionary()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if categoryId != 0 {
            getProductAPI_Call()
        }
    }

    // MARK: - Action Methods
    @IBAction func btnLookAt_Action(_ sender: UIButton) {
        
        categoryId = sender.tag == 100 ? 1 : 2
        
        viewWomenSeparater.backgroundColor = sender.tag == 100 ? colorAppTheme : colorLightGray
        viewKidsSeparater.backgroundColor = sender.tag == 100 ? colorLightGray : colorAppTheme

        if sender.tag == 100 {
            btnWomen.setTitleColor(colorAppTheme, for: .normal)
            btnKids.setTitleColor(colorLight, for: .normal)
        }
        else {
            btnKids.setTitleColor(colorAppTheme, for: .normal)
            btnWomen.setTitleColor(colorLight, for: .normal)
        }

        viewBG.isHidden = true
        viewLookAt.isHidden = true
        
        getProductAPI_Call()
    }
    
    @IBAction func btnPostType_Action(_ sender: UIButton) {
        
        viewWomenSeparater.backgroundColor = sender.tag == 200 ? colorAppTheme : colorLightGray
        viewKidsSeparater.backgroundColor = sender.tag == 200 ? colorLightGray : colorAppTheme
        
        categoryId = sender.tag == 200 ? 1 : 2

        if sender.tag == 200 {
            btnWomen.setTitleColor(colorAppTheme, for: .normal)
            btnKids.setTitleColor(colorLight, for: .normal)
        }
        else {
            btnKids.setTitleColor(colorAppTheme, for: .normal)
            btnWomen.setTitleColor(colorLight, for: .normal)
        }
        getProductAPI_Call()
    }
    
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        
    }
    
    @IBAction func btnPlaceBid_Action(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "CANCEL" {
            viewBG.isHidden = true
            viewPlaceBid.isHidden = true
        }
        else {
            if !Util.isValidString(txfBidAmount.text!) {
                Util.showAlertWithMessage("Please enter bid amount", title: ""); return
            }
            let lastBiAmount = Int(lblLastBidAmount.text ?? "") ?? 0
            let bidAmount = Int(txfBidAmount.text ?? "") ?? 0

            if bidAmount < lastBiAmount {
                Util.showAlertWithMessage("Bid amount can not be less than to last bid amount", title: ""); return
            }
            
            // Perform Place bid API
            placeBidAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func getProductData() {
        // Perform Get product API
        getProductAPI_Call()
    }
    
    // MARK: - API Methods
    private func getProductAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_CategoryId : categoryId as AnyObject,
                kAPI_Latitude   : LoggedInUser.shared.latitude as AnyObject,
                kAPI_Longitude  : LoggedInUser.shared.longitude as AnyObject,
                kAPI_Language   : "en" as AnyObject,
                "search"        : "" as AnyObject,
                "distance"      : "" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getAllProduct(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                self?.arrProduct.removeAllObjects()
                self?.collectionViewPost.reloadData()
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["responseData"].arrayObject != nil {
                let arrTemp = jsonObj["responseData"].arrayObject! as NSArray
                self?.arrProduct = NSMutableArray(array: arrTemp.reversed())
            }
            
            DispatchQueue.main.async {
                self?.collectionViewPost.reloadData()
            }
        }
    }

    private func placeBidAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
                kAPI_BidAmount  : txfBidAmount.text as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.placeBid(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.viewBG.isHidden = true
                self.viewPlaceBid.isHidden = true
            }
        }
    }

    private func getProductBidDetailAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
                kAPI_Language   : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getProductBidDetail(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.lblTime.text = jsonObj["time_left"].stringValue
                self.lblOfferPrice.text = "$\(jsonObj["offer_price"].stringValue)"
                self.lblLastBidAmount.text = "$\(jsonObj["last_bid_amount"].stringValue)"
                self.lblTotalBid.text = jsonObj["total_bid"].stringValue
                
                self.viewBG.isHidden = false
                self.viewPlaceBid.isHidden = false
                self.txfBidAmount.text = ""
            }
        }
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell
        
        let dictProduct = arrProduct[indexPath.item] as! NSDictionary
        
        cell?.configureCell(dictProduct)
        
        cell?.userProfileHandler = {
            let dictProduct = self.arrProduct[indexPath.item] as! NSDictionary

            let vc = Util.loadViewController(fromStoryboard: "SellerProfileVC", storyboardName: "Home") as? SellerProfileVC
            vc?.dictProduct = dictProduct
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                self.show(aVc, sender: nil)
            }
        }
        
        cell?.placeBidHandler = {
            self.dictProduct = self.arrProduct[indexPath.item] as! NSDictionary
            self.getProductBidDetailAPI_Call()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dictProduct = arrProduct[indexPath.item] as! NSDictionary
        
        let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as? ProductDetailVC
        vc?.dictProduct = dictProduct
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            show(aVc, sender: nil)
        }
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
