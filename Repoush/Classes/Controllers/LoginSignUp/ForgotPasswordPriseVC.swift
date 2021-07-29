//
//  ForgotPasswordPriseVC.swift
//  Repoush
//
//  Created by Apple on 16/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ForgotPasswordPriseVC: UIViewController {
    @IBOutlet weak var lblForgotpasswordLoc : UILabel!
    @IBOutlet weak var lblEnterEmaildLoc : UILabel!
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var txtEmailAddress : UITextField!
    @IBOutlet weak var btnSendOtp : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    @IBAction func actionSendOtp(_ Sender:Any){
        if !isRequiredFieldValid() {
            if  isConnectedToInternet() {
                self.callServiceForgotPassword()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    
    func isRequiredFieldValid() -> Bool {
        if (MyDefaults().language ?? "") as String ==  "en"{
            guard let password = txtEmailAddress.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please_enter_email_address".LocalizableString(localization: "en"))
                return true}
        } else{
            guard let password = txtEmailAddress.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please_enter_email_address".LocalizableString(localization: "da"))
                return true}
        }
        return false
    }
    
    func changeLanguage(strLanguage:String) {
        
            self.lblTitleNav.text = "ForgotPassword".LocalizableString(localization: strLanguage)
            self.lblForgotpasswordLoc.text = "ForgotPassword".LocalizableString(localization: strLanguage)
            self.lblEnterEmaildLoc.text = "Please_enter_your_email_address_and_we_will_send_you_a_OTP".LocalizableString(localization: strLanguage)
            self.txtEmailAddress.placeholder = "EmailAddress".LocalizableString(localization: strLanguage)
            self.btnSendOtp.setTitle("send_otp".LocalizableString(localization: strLanguage), for: .normal)
        }
    
    @IBAction func actionback(_ Sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    func callServiceForgotPassword() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["email":self.txtEmailAddress.text!]
   
           print(parameter)
        HTTPService.callForPostApi(url:forgotPasswordAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                            let vc = Util.loadViewController(fromStoryboard: "VerificationCodeVC", storyboardName: "Main") as? VerificationCodeVC
                            //vc?.productDetailId = dictProduct["id"] as! String
                            vc?.email = self.txtEmailAddress.text!
                         if let aVc = vc {
                                aVc.hidesBottomBarWhenPushed = true
                            
                            self.show(aVc, sender: nil)
                        }
                            
                           } else if status == 500 {
                                  //self.NORECORDFOUND.isHidden = false
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
          
       }
}
