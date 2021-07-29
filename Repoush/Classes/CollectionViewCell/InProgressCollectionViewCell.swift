//
//  InProgressCollectionViewCell.swift
//  Repoush
//
//  Created by mac  on 21/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class InProgressCollectionViewCell: UICollectionViewCell {
        @IBOutlet weak var imgBuyer : UIImageView!
       @IBOutlet weak var imgGallery : UIImageView!
      @IBOutlet weak var lblName : UILabel!
       @IBOutlet weak var lblTitle : UILabel!
       @IBOutlet weak var lblOriginalPrice : UILabel!
       @IBOutlet weak var lblOfferPrice : UILabel!
       @IBOutlet weak var lblDiscount : UILabel!
    @IBOutlet weak var lblMyBid : UILabel!
      @IBOutlet weak var lblTimeLeft : UILabel!
    @IBOutlet weak var btnProductReceived : UIButton!
    @IBOutlet weak var btnProfile : UIButton!
    
    @IBOutlet weak var originalPriceLoc : UILabel!
    @IBOutlet weak var OfferPriceLoc : UILabel!
    @IBOutlet weak var timeLeftLoc : UILabel!
       var countdownTimer: Timer!
       var totalTime = 0

   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    @objc func updateTime() {
        self.lblTimeLeft.text = "\(timeFormatted(totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }

    func endTimer() {
        countdownTimer.invalidate()
        self.lblTimeLeft.text = "Time Invalid"
    }

    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d:%02d",hours, minutes, seconds)
    }
    
}
