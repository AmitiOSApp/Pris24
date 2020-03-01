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

    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    // MARK: - Private Methods
    private func setUserData() {
        lblFirstName.text = LoggedInUser.shared.firstName
        lblLastName.text = LoggedInUser.shared.lastName
        lblGender.text = LoggedInUser.shared.gender
        lblAge.text = LoggedInUser.shared.dob
        lblMobileNumber.text = LoggedInUser.shared.mobileNo
        lblEmailAddress.text = LoggedInUser.shared.email
        lblAddress.text = LoggedInUser.shared.address
        
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
                kAPI_Language   : "en" as AnyObject,
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
            }
            self?.setUserData()
        }
    }

}
