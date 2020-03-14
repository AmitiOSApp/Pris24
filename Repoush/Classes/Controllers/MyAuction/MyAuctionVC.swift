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
    @IBOutlet weak var viewRateReview: UIView!
    @IBOutlet weak var imgviewUserReview: UIImageView!
    @IBOutlet weak var lblReviewUsername: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var ratingBar: AARatingBar!
    @IBOutlet weak var txvReview: CustomTextview!
    @IBOutlet weak var lblRate: UILabel!

    // MARK: - Property initialization
    private var userType = 200
    private var type = "1"
    private var productType = "1"
    private var isActiveAuction = true
    private var arrProduct = NSMutableArray()
    private var dictProduct = NSDictionary()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        txvReview.placeholder = "Add your feedback".localiz()
        
        if UserDefaults.standard.string(forKey: "language_code") == "fa" {
            imgviewTab.image = UIImage(named: "tab2")
        }
        else {
            imgviewTab.image = UIImage(named: "tab")
        }
        
        ratingBar.ratingDidChange = { ratingValue in
            self.lblRate.text = "\(ratingValue)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isActiveAuction {
            // Perform Get user product API
            getUserProductAPI_Call(type)
        }
        else {
            // Perform Get user product history API
            getProductHistoryAPI_Call(productType)
        }
    }

    // MARK: - Action Methods
    @IBAction func btnProfileType_Action(_ sender: UIButton) {
        
        viewSellerSeparater.backgroundColor = sender.tag == 200 ? colorAppTheme : colorLightGray
        viewBuyerSeparater.backgroundColor = sender.tag == 200 ? colorLightGray : colorAppTheme
        
        userType = sender.tag
        isActiveAuction = true
        
        if sender.tag == 200 {
            btnSeller.setTitleColor(colorAppTheme, for: .normal)
            btnBuyer.setTitleColor(colorLight, for: .normal)
            
            type = "1"
            
            // Perform Get user product API
            getUserProductAPI_Call(type)
        }
        else {
            btnBuyer.setTitleColor(colorAppTheme, for: .normal)
            btnSeller.setTitleColor(colorLight, for: .normal)
            
            type = "2"

            // Perform Get user product API
            getUserProductAPI_Call(type)
        }
        
        if UserDefaults.standard.string(forKey: "language_code") == "fa" {
            imgviewTab.image = UIImage(named: "tab2")
        }
        else {
            imgviewTab.image = UIImage(named: "tab")
        }
        btnActiveAuction.setTitleColor(.white, for: .normal)
        btnHistory.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func productType_Action(_ sender: UIButton) {

        isActiveAuction = sender.tag == 300 ? true : false
        
        if sender.tag == 300 {
            if UserDefaults.standard.string(forKey: "language_code") == "fa" {
                imgviewTab.image = UIImage(named: "tab2")
            }
            else {
                imgviewTab.image = UIImage(named: "tab")
            }
            btnActiveAuction.setTitleColor(.white, for: .normal)
            btnHistory.setTitleColor(.black, for: .normal)

            if userType == 200 {
                
                type = "1"

                // Perform Get user product API
                getUserProductAPI_Call(type)
            }
            else {
                
                type = "2"

                // Perform Get user product API
                getUserProductAPI_Call(type)
            }
        }
        else {
            if UserDefaults.standard.string(forKey: "language_code") == "fa" {
                imgviewTab.image = UIImage(named: "tab")
            }
            else {
                imgviewTab.image = UIImage(named: "tab2")
            }

            btnActiveAuction.setTitleColor(.black, for: .normal)
            btnHistory.setTitleColor(.white, for: .normal)

            if userType == 200 {
                
                productType = "1"

                // Perform Get user product history API
                getProductHistoryAPI_Call(productType)
            }
            else {
                
                productType = "2"

                // Perform Get user product history API
                getProductHistoryAPI_Call(productType)
            }
        }
    }
    
    @IBAction func btnCross_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewRateReview.isHidden = true
    }
    
    @IBAction func btnSubmitReview_Action(_ sender: UIButton) {
        if !Util.isValidString(txvReview.text) {
            Util.showAlertWithMessage("Please enter your feedback", title: ""); return
        }
        // Perform Submit Feedback API
        submitFeedbackAPI_Call()
    }
    
    // MARK: - Private Methods
    private func showFeedbackDetail() {
        
        if userType == 200 {
            lblReviewUsername.text = dictProduct["buyer_name"] as? String
        }
        else {
            lblReviewUsername.text = Util.createUsername(dictProduct)
        }
        
        lblRatingCount.text = "\(dictProduct["rating"] ?? "0")"

        if Util.isValidString(dictProduct["user_image"] as? String ?? "") {
            
            let imageUrl = dictProduct["user_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            imgviewUserReview.kf.indicatorType = .activity
            imgviewUserReview.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgviewUserReview.image = value.image
                case .failure( _):
                    self.imgviewUserReview.image = UIImage(named: "dummy_user")
                }
                self.imgviewUserReview.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            imgviewUserReview.image = UIImage(named: "dummy_user")
        }
    }

    // MARK: - API Methods
    private func getUserProductAPI_Call(_ type: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_Type       : type as AnyObject,
                kAPI_Language   : UserLanguage.shared.languageCode as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getAllUserProducts(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                self?.arrProduct.removeAllObjects()
                self?.collectionViewAuction.reloadData()
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
                kAPI_Language   : UserLanguage.shared.languageCode as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getUserHistoryProduct(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                self?.arrProduct.removeAllObjects()
                self?.collectionViewAuction.reloadData()
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

    private func deleteProductAPI_Call(_ productId: String, selectedIndex: Int) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ProductId : productId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.deleteProduct(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self?.arrProduct.removeObject(at: selectedIndex)
                self?.collectionViewAuction.reloadData()
            }
        }
    }

    private func cancelBidAPI_Call(_ selectedIndex: Int, bidId: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_BidId : bidId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.bidCancel(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.arrProduct.removeObject(at: selectedIndex)
                self.collectionViewAuction.reloadData()
            }
        }
    }

    private func checkoutAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_ProductId  : dictProduct["product_id"] as AnyObject,
                kAPI_BasePrice  : dictProduct["base_price"] as AnyObject,
                kAPI_OfferPrice : dictProduct["offer_price"] as AnyObject,
                kAPI_Discount   : dictProduct["discount"] as AnyObject,
                kAPI_DeviceType : "ios" as AnyObject,
                kAPI_SellerId   : dictProduct["seller_id"] as AnyObject,
                kAPI_DealPrice  : dictProduct["bid_amount"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.checkout(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if self.isActiveAuction {
                // Perform Get user product API
                self.getUserProductAPI_Call(self.type)
            }
            else {
                // Perform Get user product history API
                self.getProductHistoryAPI_Call(self.productType)
            }
        }
    }

    private func submitFeedbackAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let rating = lblRate.text?.replacingOccurrences(of: ".0", with: "")
        var ratingFor = ""
        
        if productType == "1" {
            ratingFor = (dictProduct["buyer_id"] as? String)!
        }
        else {
            ratingFor = (dictProduct["seller_id"] as? String)!
        }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId           : LoggedInUser.shared.id as AnyObject,
                kAPI_Rating           : rating as AnyObject,
                kAPI_ProductId        : dictProduct["product_id"] as AnyObject,
                kAPI_FeedbackMessage  : txvReview.text as AnyObject,
                kAPI_RatingFor        : ratingFor as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.feedbackSeller(postParams), callerObj: self, showHud: true) { (response) -> () in
            
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
                self.viewRateReview.isHidden = true
                
                self.txvReview.text = ""
                self.ratingBar.value = 1.0
            }
            
            if self.isActiveAuction {
                // Perform Get user product API
                self.getUserProductAPI_Call(self.type)
            }
            else {
                // Perform Get user product history API
                self.getProductHistoryAPI_Call(self.productType)
            }
        }
    }

    private func repostProductAPI_Call(_ productId: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId    : LoggedInUser.shared.id as AnyObject,
                kAPI_ProductId : productId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.repostProduct(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
        }
    }

    private func updateBidStatusAPI_Call(_ productId: String, userId: String, bidId: String) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : userId as AnyObject,
                kAPI_ProductId  : productId as AnyObject,
                kAPI_BidStatus  : "3" as AnyObject,
                kAPI_BidId      : bidId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.updateBidStatus(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if self.isActiveAuction {
                // Perform Get user product API
                self.getUserProductAPI_Call(self.type)
            }
            else {
                // Perform Get user product history API
                self.getProductHistoryAPI_Call(self.productType)
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
        cell?.configureCell(dictProduct!, isSeller: isSeller, isActiveAuction: isActiveAuction)
        
        cell?.deleteHandler = {
            let dictProduct = self.arrProduct[indexPath.item] as? NSDictionary

            // Perform Delete product API
            self.deleteProductAPI_Call(dictProduct!["id"] as! String, selectedIndex: indexPath.item)
        }
        
        cell?.editHandler = {
            
            let dictProduct = self.arrProduct[indexPath.item] as? NSDictionary

            let vc = Util.loadViewController(fromStoryboard: "AddPostVC", storyboardName: "Home") as? AddPostVC
            if let aVc = vc {
                aVc.isEdit = true
                aVc.hidesBottomBarWhenPushed = true
                aVc.dictProduct = dictProduct!
                self.show(aVc, sender: nil)
            }
        }
        
        cell?.allBidHandler = {
            
            if cell?.btnShowAllBid.titleLabel?.text == "SHOW ALL BID".localiz() {
                let dictTemp = self.arrProduct[indexPath.item] as? NSDictionary

                let vc = Util.loadViewController(fromStoryboard: "AllBidVC", storyboardName: "Home") as? AllBidVC
                if let aVc = vc {
                    aVc.hidesBottomBarWhenPushed = true
                    aVc.dictProduct = dictTemp!
                    self.show(aVc, sender: nil)
                }
            }
            else if cell?.btnShowAllBid.titleLabel?.text == "CANCEL BID".localiz() {
                let dictTemp = self.arrProduct[indexPath.item] as? NSDictionary
                self.cancelBidAPI_Call(indexPath.row, bidId: dictTemp!["id"] as! String)
            }
            else if cell?.btnShowAllBid.titleLabel?.text == "REVOKE".localiz() {
                let dictTemp = self.arrProduct[indexPath.item] as? NSDictionary
                self.updateBidStatusAPI_Call(dictTemp!["id"] as! String, userId: dictTemp!["user_id"] as! String, bidId: dictTemp!["id"] as! String)
            }
            else if cell?.btnShowAllBid.titleLabel?.text == "MAKE PAYMENT".localiz() {
                self.dictProduct = (self.arrProduct[indexPath.item] as? NSDictionary)!
                self.checkoutAPI_Call()
            }
            else if cell?.btnShowAllBid.titleLabel?.text == "RATE BUYER".localiz() {
                self.dictProduct = (self.arrProduct[indexPath.item] as? NSDictionary)!
                self.showFeedbackDetail()
                
                self.viewBG.isHidden = false
                self.viewRateReview.isHidden = false
            }
            else if cell?.btnShowAllBid.titleLabel?.text == "RATE SELLER".localiz() {
                self.dictProduct = (self.arrProduct[indexPath.item] as? NSDictionary)!
                self.showFeedbackDetail()
                
                self.viewBG.isHidden = false
                self.viewRateReview.isHidden = false
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
