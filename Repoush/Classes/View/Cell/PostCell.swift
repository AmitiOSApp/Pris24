//
//  PostCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var btnPlaceBid: UIButton!

    private var timer: Timer?
    private var timeCounter: Int = 0
    
    var timeIntervalInSecond: TimeInterval? {
        didSet {
            startTimer()
        }
    }
    
    var userProfileHandler: (() -> Void)?
    var placeBidHandler: (() -> Void)?

    // MARK: Action Methods
    @IBAction func btnUserProfile_Action(_ sender: UIButton) {
        if (userProfileHandler != nil) {
            userProfileHandler!()
        }
    }
    
    @IBAction func btnPlaceBid_Action(_ sender: UIButton) {
        if (placeBidHandler != nil) {
            placeBidHandler!()
        }
    }
    
    // MARK: Public Methods
    func configureCell(_ dictProduct: NSDictionary) {
        lblUsername.text = "By : \(Util.createUsername(dictProduct))"
        lblProductName.text = dictProduct["selling"] as? String
        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        lblDiscount.text = "\(dictProduct["discount"] ?? "0.0")% off"
        
        let accountStatus = dictProduct["account_status"] as? String
        
        btnOnline.isSelected = accountStatus == "1" ? false : true

        if dictProduct["user_id"] as? String == LoggedInUser.shared.id {
            btnPlaceBid.isHidden = true
        }
        else {
            btnPlaceBid.isHidden = false
        }
        
        var distance = 0.0
        if let temp = Double("\(dictProduct["distance"] ?? 0.0)") {
            distance = temp
        }
        distance = Double(distance).rounded(2)
        btnDistance.setTitle("\(distance) km", for: .normal)
        
        let timeInSecond = dictProduct["time_left_in_second"] as? Int
        
        if timeInSecond != 0 {
            timer?.invalidate()
            timeIntervalInSecond = TimeInterval(timeInSecond!)
        }
        
        var arrProductImage = NSMutableArray()
        
        if let arrTemp = dictProduct["product_image"] as? NSArray {
            arrProductImage = NSMutableArray(array: arrTemp)
        }
        
        if arrProductImage.count > 0 {
            let dictProductImage = arrProductImage[0] as? NSDictionary
            
            if Util.isValidString(dictProductImage!["product_image"] as! String) {
                
                let imageUrl = dictProductImage!["product_image"] as! String
                
                let url = URL.init(string: imageUrl)
                
                imgviewProduct.kf.indicatorType = .activity
                imgviewProduct.kf.indicator?.startAnimatingView()
                
                let resource = ImageResource(downloadURL: url!)
                
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        self.imgviewProduct.image = value.image
                    case .failure( _):
                        self.imgviewProduct.image = UIImage(named: "dummy_post")
                    }
                    self.imgviewProduct.kf.indicator?.stopAnimatingView()
                }
            }
            else {
                imgviewProduct.image = UIImage(named: "dummy_post")
            }
        }
        
        if Util.isValidString(dictProduct["user_image"] as! String) {
            
            let imageUrl = dictProduct["user_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            imgviewUser.kf.indicatorType = .activity
            imgviewUser.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgviewUser.image = value.image
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            imgviewUser.image = UIImage(named: "dummy_user")
        }

    }
    
    private func startTimer() {
        if let interval = timeIntervalInSecond {
            timeCounter = Int(interval)

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)

//            timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
//                guard let strongSelf = self else {
//                    return
//                }
//                strongSelf.onComplete()
//            })
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
        
        lblTimeLeft.text = "\(temp)"
        
        timeCounter -= 1
    }
    
//    @objc func onComplete() {
//        guard timeCounter >= 0 else {
//            timer?.invalidate()
//            timer = nil
//            return
//        }
//
//        let hours = timeCounter / 3600
//        let minutes = timeCounter / 60 % 60
//        let seconds = timeCounter % 60
//        let temp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
//
//        lblTimeLeft.text = "\(temp)"
//
//        timeCounter -= 1
//    }
    
}
