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
    @IBOutlet weak var txfSearch: UITextField!
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
    private var locManager = CLLocationManager()
    private var search: String = ""
    private var offerPrice = 0
    private var lastBidAmount = 0
    private var timer: Timer?
    private var timeCounter: Int = 0
    
    var timeIntervalInSecond: TimeInterval? {
        didSet {
            startTimer()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // For use in foreground
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        
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
        
        txfSearch.resignFirstResponder()
        
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
        let vc = Util.loadViewController(fromStoryboard: "FilterVC", storyboardName: "Home") as? FilterVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            show(aVc, sender: nil)
        }
    }
    
    @IBAction func btnPlaceBid_Action(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "CANCEL".localiz() {
            viewBG.isHidden = true
            viewPlaceBid.isHidden = true
        }
        else {
            txfBidAmount.resignFirstResponder()
            
            if !Util.isValidString(txfBidAmount.text!) {
                Util.showAlertWithMessage("Please enter bid amount", title: ""); return
            }
            let bidAmount = Int(txfBidAmount.text ?? "") ?? 0

            if bidAmount == 0 || bidAmount <= offerPrice {
                Util.showAlertWithMessage("Bid amount should be greater than offer price", title: ""); return
            }

            if bidAmount < lastBidAmount {
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
    
    private func startTimer() {
        if let interval = timeIntervalInSecond {
            timeCounter = Int(interval)
            
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateCounter() {
        guard timeCounter >= 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let hours = timeCounter / 3600
        let minutes = timeCounter / 60 % 60
        let seconds = timeCounter % 60
        let temp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
        lblTime.text = "\(temp)"
        
        timeCounter -= 1
    }

    // MARK: - API Methods
    private func getProductAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        var latitude = LoggedInUser.shared.latitude
        var longitude = LoggedInUser.shared.longitude
        
        if appDelegate.currentLocation != nil {
            latitude = "\(appDelegate.currentLocation?.coordinate.latitude ?? 0.0)"
            longitude = "\(appDelegate.currentLocation?.coordinate.longitude ?? 0.0)"
        }

        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_CategoryId : categoryId as AnyObject,
                kAPI_Latitude   : latitude as AnyObject,
                kAPI_Longitude  : longitude as AnyObject,
                kAPI_Language   : "en" as AnyObject,
                "search"        : search as AnyObject,
                "distance"      : appDelegate.distance as AnyObject,
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
                
                let timeInSecond = jsonObj["time_left_in_second"].int
                
                if timeInSecond != 0 {
                    self.timer?.invalidate()
                    self.timeIntervalInSecond = TimeInterval(timeInSecond!)
                }
                self.lblOfferPrice.text = "$\(jsonObj["offer_price"].stringValue)"
                self.lblLastBidAmount.text = "$\(jsonObj["last_bid_amount"].stringValue)"
                self.lblTotalBid.text = jsonObj["total_bid"].stringValue

                self.offerPrice = jsonObj["offer_price"].intValue
                self.lastBidAmount = jsonObj["last_bid_amount"].intValue

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

// MARK: CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        appDelegate.currentLocation = locations.last! as CLLocation
        locManager.stopUpdatingLocation()
    }
    
}

// MARK: UITextFieldDelegate
extension HomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txfSearch {
            if string.isEmpty {
                search = String(search.dropLast())
            }
            else {
                search = textField.text! + string
            }
            // Perform Search Product API
            getProductAPI_Call()
        }
        return true
    }
    
}
