//
//  AuctionCell.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/7/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AuctionCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var lblBitType: UILabel!
    @IBOutlet weak var lblLastBidAmount: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnShowAllBid: UIButton!
    @IBOutlet weak var viewTimer: UIView!

    @IBOutlet weak var btnDeleteWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btnEditWidthConst: NSLayoutConstraint!

    var editHandler: (() -> Void)?
    var deleteHandler: (() -> Void)?
    var allBidHandler: (() -> Void)?

    private var timer: Timer?
    private var timeCounter: Int = 0
    
    var timeIntervalInSecond: TimeInterval? {
        didSet {
            startTimer()
        }
    }

    // MARK: Action Methods
    @IBAction func btnEdit_Action(_ sender: UIButton) {
        if (editHandler != nil) {
            editHandler!()
        }
    }

    @IBAction func btnDelete_Action(_ sender: UIButton) {
        if (deleteHandler != nil) {
            deleteHandler!()
        }
    }
    
    @IBAction func btnShowAllBid_Action(_ sender: UIButton) {
        if (allBidHandler != nil) {
            allBidHandler!()
        }
    }
    
    // MARK: Public Methods
    func configureCell(_ dictProduct: NSDictionary, isSeller: Bool, isActiveAuction: Bool) {

        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        lblLastBidAmount.text = "$\(dictProduct["last_bid"] ?? "0.0")"
        lblDiscount.text = "\(dictProduct["discount"] ?? "0.0")% off"

        if isActiveAuction {
            viewTimer.isHidden = false

            let timeInSecond = dictProduct["time_left_in_second"] as? Int
            
            if timeInSecond != 0 {
                timer?.invalidate()
                timeIntervalInSecond = TimeInterval(timeInSecond!)
            }
        }
        else {
            viewTimer.isHidden = true
        }
        
        if isSeller {
            lblUsername.text = ""
            lblBitType.text = "Last bid"
            
            if isActiveAuction {
                lblProductName.text = dictProduct["selling"] as? String

                if dictProduct["is_accepted_bid"] as? Bool == true {
                    btnShowAllBid.setTitle("REVOKE", for: .normal)
                }
                else {
                    btnShowAllBid.setTitle("SHOW ALL BID", for: .normal)
                }
            }
            else {
                lblProductName.text = dictProduct["product_name"] as? String
                btnShowAllBid.setTitle("RATE BUYER", for: .normal)
            }
            if isActiveAuction {
                btnEditWidthConst.constant = 30.0
                btnDeleteWidthConst.constant = 30.0
            }
            else {
                btnEditWidthConst.constant = 0.0
                btnDeleteWidthConst.constant = 0.0
            }
        }
        else {
            lblLastBidAmount.text = "$\(dictProduct["bid_amount"] ?? "0.0")"
            lblProductName.text = dictProduct["product_name"] as? String
            lblBitType.text = "My bid"
            lblUsername.text = "By : \(Util.createUsername(dictProduct))"
            
            if isActiveAuction {
                if dictProduct["bid_status"] as? String == "2" {
                    btnShowAllBid.setTitle("MAKE PAYMENT", for: .normal)
                }
                else {
                    btnShowAllBid.setTitle("CANCEL BID", for: .normal)
                }
            }
            else {
                btnShowAllBid.setTitle("RATE SELLER", for: .normal)
            }
            btnEditWidthConst.constant = 0.0
            btnDeleteWidthConst.constant = 0.0
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
        
        lblTimeLeft.text = "\(temp)"
        
        timeCounter -= 1
    }

}
