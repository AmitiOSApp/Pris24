//
//  PersonalCollectionViewCell.swift
//  Repoush
//
//  Created by mac  on 22/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class PersonalCollectionViewCell: UICollectionViewCell {
        @IBOutlet weak var imgPersonal : UIImageView!
       @IBOutlet weak var imgUserProfile : UIImageView!
       @IBOutlet weak var lblName : UILabel!
       @IBOutlet weak var lblTitle : UILabel!
       @IBOutlet weak var lblOriginalPrice : UILabel!
       @IBOutlet weak var lblOfferPrice : UILabel!
       @IBOutlet weak var lblDiscount : UILabel!
       @IBOutlet weak var lblOnlineDot : UILabel!
       @IBOutlet weak var lblOnline : UILabel!
       @IBOutlet weak var lblTimeLeft : UILabel!
       @IBOutlet weak var lblDistance : UILabel!
       @IBOutlet weak var btnPersonalProfile : UIButton!
    @IBOutlet weak var btnOnimage : UIButton!
       @IBOutlet weak var btnPlaceBid : UIButton!
    @IBOutlet weak var lblPlace : UILabel!
    @IBOutlet weak var originalPriceLoc : UILabel!
    @IBOutlet weak var offLoc : UILabel!
    @IBOutlet weak var OfferPriceLoc : UILabel!
    @IBOutlet weak var timeLeftLoc : UILabel!
    @IBOutlet weak var onlineLoc : UILabel!
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
