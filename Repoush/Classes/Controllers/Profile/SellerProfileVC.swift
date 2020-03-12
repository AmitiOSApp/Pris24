//
//  SellerProfileVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/26/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class SellerProfileVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var ratingBar: AARatingBar!

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewRateReview: UIView!
    @IBOutlet weak var imgviewUserReview: UIImageView!
    @IBOutlet weak var lblReviewUsername: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var tblReview: UITableView!

    @IBOutlet weak var viewReviewHgtConst: NSLayoutConstraint!
    
    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    private var arrRatingList = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblReview.rowHeight = UITableView.automaticDimension
        tblReview.estimatedRowHeight = 80
        
        setSellerDetail()
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRateReview_Action(_ sender: UIButton) {
        viewBG.isHidden = false
        viewRateReview.isHidden = false
    }
    
    @IBAction func btnCross_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewRateReview.isHidden = true
    }

    // MARK: - Private Methods
    private func setSellerDetail() {
        
        lblUsername.text = Util.createUsername(dictProduct)
        lblReviewUsername.text = Util.createUsername(dictProduct)

        lblReviewCount.text = "\(dictProduct["review"] ?? "0.0") REVIEWS"
        lblRatingValue.text = "\(dictProduct["rating"] ?? "0")"
        lblRatingCount.text = "\(dictProduct["rating"] ?? "0")"
        
        if let temp = dictProduct["rating"] as? Int {
            ratingBar.value = CGFloat(temp)
        }

        let mobileNumber = dictProduct["user_phone"] as? String

        if dictProduct["is_alloted"] as? Bool == true {
            lblMobileNumber.text = mobileNumber
            lblEmailAddress.text = dictProduct["user_email"] as? String
            lblAddress.text = dictProduct["address"] as? String
        }
        else {
            if mobileNumber!.count > 2 {
                let last2 = mobileNumber!.suffix(2)
                lblMobileNumber.text = "********\(last2)"
            }
            lblAddress.text = "********************"
            lblEmailAddress.text = "********@xyz.com"
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
                    self.imgviewUserReview.image = value.image
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                    self.imgviewUserReview.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            imgviewUser.image = UIImage(named: "dummy_user")
            imgviewUserReview.image = UIImage(named: "dummy_user")
        }
        
        ratingBar.value = 0.0
        if let temp = dictProduct["rating"] as? String {
            if Util.isValidString(temp) {
                ratingBar.value = CGFloat(Double(temp)!)
            }
        }
        
        lblRatingCount.text = dictProduct["rating"] as? String
        
        if let temp = dictProduct["rating_list"] as? NSArray {
            arrRatingList = NSMutableArray(array: temp)
        }
        
        var count = arrRatingList.count
        
        if arrRatingList.count > 4 {
            count = 4
        }
        viewReviewHgtConst.constant = CGFloat((count * 80) + 75)
        
        tblReview.reloadData()
    }
 
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SellerProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRatingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        cell?.selectionStyle = .none
        
        let dictReview = arrRatingList[indexPath.row] as? NSDictionary
        
        cell?.lblUsername.text = Util.createUsername(dictReview!)
        cell?.lblReview.text = dictReview!["feedback_message"] as? String
        
        cell?.ratingBar.value = 0.0
        if let temp = dictReview!["rating"] as? String {
            if Util.isValidString(temp) {
                cell?.ratingBar.value = CGFloat(Double(temp)!)
            }
        }

        var feedbackDate = ""
        
        if let temp = dictReview!["feedback_date"] as? String {
            let tempDate = Util.getDateFromString(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "yyyy-MM-dd HH:mm:ss.SSS")
            
            feedbackDate = Util.relativeDateStringForDate(tempDate)
            
            if feedbackDate != "Just now" {
                feedbackDate = "\(feedbackDate) ago"
            }
        }
        cell?.lblDate.text = feedbackDate

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
