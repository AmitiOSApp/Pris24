//
//  ProfessionalSellerHistoyDiscountNotificationVC.swift
//  Repoush
//
//  Created by Apple on 07/11/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProfessionalSellerHistoyDiscountNotificationVC: UIViewController {
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblNoDataFound : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var viewBG : UIView!
    var imgString = ""
    var strName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.sd_setImage(with: URL(string:imgString), placeholderImage:#imageLiteral(resourceName: "gallery"))
        self.lblName.text = strName
        // Do any additional setup after loading the view.
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.lblTitleNav.text =  "Discount_Notifications".LocalizableString(localization: "en")
            self.lblNoDataFound.text =  "No_Record_Found".LocalizableString(localization: "en")
            self.btnCancel.setTitle("Report_Cancel".LocalizableString(localization: "en"), for: .normal)
            
        } else{
            self.lblTitleNav.text =  "Please Login Or Register To Continue".LocalizableString(localization: "da")
            self.lblNoDataFound.text =  "No_Record_Found".LocalizableString(localization: "da")
            self.btnCancel.setTitle("Report_Cancel".LocalizableString(localization: "da"), for: .normal)
        }
    }
    @IBAction func actionOnCancel(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
}
