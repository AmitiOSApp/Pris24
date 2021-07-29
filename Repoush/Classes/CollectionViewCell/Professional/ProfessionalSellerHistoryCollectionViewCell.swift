//
//  ProfessionalSellerHistoryCollectionViewCell.swift
//  Repoush
//
//  Created by Apple on 07/11/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class ProfessionalSellerHistoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgBuyer : UIImageView!
       
      
       @IBOutlet weak var lblTitle : UILabel!
       @IBOutlet weak var lblOriginalPrice : UILabel!
       @IBOutlet weak var lblOfferPrice : UILabel!
       @IBOutlet weak var lblDiscount : UILabel!
       @IBOutlet weak var lblBidPrice : UILabel!
    @IBOutlet weak var originalPriceLoc : UILabel!
    @IBOutlet weak var OfferPriceLoc : UILabel!
    @IBOutlet weak var lblComplted : UILabel!
   
      
//       @IBOutlet weak var btnRateBuyer : UIButton!
//       @IBOutlet weak var btnRateBuyerwidthConstraints : NSLayoutConstraint!
//       @IBOutlet weak var btnRePost : UIButton!
//       @IBOutlet weak var btnRepostwidthConstraints : NSLayoutConstraint!
//       @IBOutlet weak var lblDealCompleted : UILabel!
    @IBOutlet weak var btnRepost : UIButton!
    @IBOutlet weak var btnSendOffer : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
