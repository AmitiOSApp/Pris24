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
    
    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setSellerDetail()
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    private func setSellerDetail() {
        
        lblUsername.text = Util.createUsername(dictProduct)

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
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            self.imgviewUser.image = UIImage(named: "dummy_user")
        }
    }
 
}
