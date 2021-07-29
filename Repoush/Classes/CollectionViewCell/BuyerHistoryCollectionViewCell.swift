//
//  BuyerHistoryCollectionViewCell.swift
//  Repoush
//
//  Created by mac  on 21/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class BuyerHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgBuyer : UIImageView!
     @IBOutlet weak var imgGallery : UIImageView!
     @IBOutlet weak var lblName : UILabel!
    
     @IBOutlet weak var lblTitle : UILabel!
     @IBOutlet weak var lblOriginalPrice : UILabel!
     @IBOutlet weak var lblOfferPrice : UILabel!
     @IBOutlet weak var lblDiscount : UILabel!
     @IBOutlet weak var lblBidPrice : UILabel!
    @IBOutlet weak var lblDealStatus : UILabel!
     @IBOutlet weak var btnRateSellerWidthConstant : NSLayoutConstraint!
    @IBOutlet weak var btnRateSeller : UIButton!
    @IBOutlet weak var btnbuyerProfile : UIButton!
    @IBOutlet weak var originalPriceLoc : UILabel!
    @IBOutlet weak var OfferPriceLoc : UILabel!
   
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
