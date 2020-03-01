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
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var btnPlaceBid: UIButton!

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
        btnDistance.setTitle("\(dictProduct["distance"] ?? "0.0") km", for: .normal)
        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        lblDiscount.text = "\(dictProduct["discount"] ?? "0.0")% off"
        
        if dictProduct["user_id"] as? String == LoggedInUser.shared.id {
            btnPlaceBid.isHidden = true
        }
        else {
            btnPlaceBid.isHidden = false
        }
        
        let timeInSecond = dictProduct["time_left_in_second"] as? Int
        
        if timeInSecond == 0 {
            
        }
        else {
            
            if timeInSecond != nil {
                let hours = timeInSecond! / 3600
                let minutes = timeInSecond! / 60 % 60
                let seconds = timeInSecond! % 60
                let temp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
                
                lblTimeLeft.text = "\(temp)"
                
                // var helloWorldTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLeft), userInfo: nil, repeats: true)
            }
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
    }
    
    @objc func setTimeLeft() {

    }
}
