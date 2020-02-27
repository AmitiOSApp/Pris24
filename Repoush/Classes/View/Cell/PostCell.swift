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
        btnDistance.setTitle("\(dictProduct["distance"] ?? "0.0")", for: .normal)
        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        
        if dictProduct["offer_price"] as? String == LoggedInUser.shared.id {
            btnPlaceBid.isHidden = true
        }
        else {
            btnPlaceBid.isHidden = false
        }
    }
    
}
