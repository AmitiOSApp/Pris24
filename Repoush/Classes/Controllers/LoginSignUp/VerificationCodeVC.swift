//
//  VerificationCodeVC.swift
//  Repoush
//
//  Created by Apple on 16/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class VerificationCodeVC: UIViewController {
    @IBOutlet weak var lblVerificationLoc : UILabel!
    @IBOutlet weak var lblMessageLoc : UILabel!
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var txtVerification : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    @IBOutlet weak var btnResend : UIButton!
    var email = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    @IBAction func actionSubmitOtp(_ Sender:Any){
        if !isRequiredFieldValid() {
            if  isConnectedToInternet() {
                self.callServiceSubmitOtp()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @IBAction func actionResend(_ Sender:Any){
        
        if  isConnectedToInternet() {
            self.callServiceResendOtp()
        } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        
    }
    func isRequiredFieldValid() -> Bool {
        if (MyDefaults().language ?? "") as String ==  "en"{
            guard let password = txtVerification.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please_enter_otp".LocalizableString(localization: "en"))
                return true}
        } else{
            guard let password = txtVerification.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please_enter_otp".LocalizableString(localization: "da"))
                return true}
        }
        return false
    }
    
    
    func changeLanguage(strLanguage:String) {
        
            self.lblTitleNav.text = "verification".LocalizableString(localization: strLanguage)
            self.lblVerificationLoc.text = "verification".LocalizableString(localization: strLanguage)
            self.lblMessageLoc.text = "Please_enter_your_code_receive_on_your_registeres_email_address".LocalizableString(localization: strLanguage)
            self.txtVerification.placeholder = "EnterOTP".LocalizableString(localization: strLanguage)
            self.btnSubmit.setTitle("Received".LocalizableString(localization: strLanguage), for: .normal)
            self.btnResend.setTitle("Resend".LocalizableString(localization: strLanguage), for: .normal)
        }
    
    @IBAction func actionback(_ Sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    func callServiceSubmitOtp() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["email":email,
                                        "otp":self.txtVerification.text!]
   
           print(parameter)
        HTTPService.callForPostApi(url:getVerifiOtpAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                            let vc = Util.loadViewController(fromStoryboard: "CreatePasswordVC", storyboardName: "Main") as? CreatePasswordVC
                            vc?.email = self.email
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
    func callServiceResendOtp() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["email":self.email]
   
           print(parameter)
        HTTPService.callForPostApi(url:getResendAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                            
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
