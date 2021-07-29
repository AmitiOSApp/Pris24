//
//  SharePopUpVC.swift
//  Repoush
//
//  Created by Apple on 01/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol getShare {
    func delegatShare(shareLink:String)
    func delegatShareCancel()
}
class SharePopUpVC: UIViewController {
var delagate: getShare!
    var shareLink = ""
    @IBOutlet weak var lblYourActionislive:UILabel!
    @IBOutlet weak var lblYourActionSellerFaster:UILabel!
    @IBOutlet weak var lblShareandreachmorepeaople:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnShare:UIButton!
    @IBOutlet weak var btnClose:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(shareLink)
        
        // Do any additional setup after loading the view.
    
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    
    }
    func changeLanguage(strLanguage:String) {
            self.lblYourActionislive.text = "You_Auction_is_live".LocalizableString(localization: strLanguage)
            self.lblYourActionSellerFaster.text = "Sell_faster".LocalizableString(localization: strLanguage)
            self.lblShareandreachmorepeaople.text = "Share_and_reach_more_people".LocalizableString(localization: strLanguage)
            self.lblTitle.text = "Auction_is_live".LocalizableString(localization: strLanguage)
            self.btnShare.setTitle("Share".LocalizableString(localization: strLanguage), for: .normal)
            self.btnClose.setTitle("Close".LocalizableString(localization: strLanguage), for: .normal)
           
}
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Hide the navigation bar on the this view controller
           self.navigationController?.setNavigationBarHidden(true, animated: animated)
           
       }
    @IBAction func actionOnShare(_ sender: Any){
        if self.delagate != nil {
            self.dismiss(animated: true, completion: nil)
            self.delagate.delegatShare(shareLink: shareLink)
        }
    }
    @IBAction func actionOnCancel(_ sender: Any){
       if self.delagate != nil {
            self.dismiss(animated: true, completion: nil)
            self.delagate.delegatShareCancel()
        }
    }
}
