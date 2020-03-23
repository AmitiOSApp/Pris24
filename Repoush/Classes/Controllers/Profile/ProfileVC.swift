//
//  ProfileVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewRateReview: UIView!
    @IBOutlet weak var imgviewUserReview: UIImageView!
    @IBOutlet weak var lblReviewUsername: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var tblReview: UITableView!
    
    @IBOutlet weak var viewReviewHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    private var arrRatingList = NSMutableArray()

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblReview.rowHeight = UITableView.automaticDimension
        tblReview.estimatedRowHeight = 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Perform Get user detail API
        getUserDetailAPI_Call()
    }

    // MARK: - Action Methods
    @IBAction func btnEdit_Action(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "EditProfileVC", storyboardName: "Home") as? EditProfileVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            show(aVc, sender: nil)
        }
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
    private func setUserData() {
        lblFirstName.text = LoggedInUser.shared.firstName
        lblLastName.text = LoggedInUser.shared.lastName
        lblGender.text = LoggedInUser.shared.gender
        lblAge.text = LoggedInUser.shared.dob
        lblMobileNumber.text = LoggedInUser.shared.mobileNo
        lblEmailAddress.text = LoggedInUser.shared.email
        lblAddress.text = LoggedInUser.shared.address
        
        lblReviewUsername.text = "\(LoggedInUser.shared.firstName ?? "") \(LoggedInUser.shared.lastName ?? "")"
        lblReviewCount.text = "\(LoggedInUser.shared.reviewCount ?? "0.0") \("REVIEWS".localiz())"
        
        var rating = 0.0
        if let temp = Double("\(LoggedInUser.shared.rating ?? "0.0")") {
            rating = temp
        }
        rating = Double(rating).rounded(1)
        
        lblRatingValue.text = "\(rating)"
        lblRatingCount.text = "\(rating)"
        
        if Util.isValidString(LoggedInUser.shared.userImage!) {
            
            let url = URL.init(string: LoggedInUser.shared.userImage!)
            
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

    // MARK: - API Methods
    private func getUserDetailAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_Language   : UserLanguage.shared.languageCode as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getUserDetail(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if let userData = jsonObj["responseData"].dictionary {
                LoggedInUser.shared.initLoggedInUserFromResponse(userData as AnyObject)
                
                if let temp = userData["rating_list"]?.array {
                    self?.arrRatingList = NSMutableArray(array: temp)
                }
                
                var count = self?.arrRatingList.count
                
                if (self?.arrRatingList.count)! > 4 {
                    count = 4
                }
                self?.viewReviewHgtConst.constant = CGFloat((count! * 80) + 75)
                
                self?.tblReview.reloadData()
            }
            self?.setUserData()
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
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
