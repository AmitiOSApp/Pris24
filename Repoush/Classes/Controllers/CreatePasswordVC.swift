//
//  CreatePasswordVC.swift
//  Repoush
//
//  Created by Apple on 06/11/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class CreatePasswordVC: UIViewController {
    @IBOutlet weak var lblVerificationLoc : UILabel!
    @IBOutlet weak var lblCreatePassword : UILabel!
    @IBOutlet weak var lblYourPasswordMustHavemorethan6digit : UILabel!
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtConfirmPassword : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    
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
            guard let password = txtPassword.text , password != ""else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: ALERTMESSAGE, message: "Please_enter_password".LocalizableString(localization: "en"))
                } else {
                    showAlert(title: ALERTMESSAGE, message: "Please_enter_password".LocalizableString(localization: "da"))
                }
                return true}
            guard let Confirmpassword = txtPassword.text , Confirmpassword != "" ,isValidatePasswordLength(password: txtPassword.text) else {showAlert(title: ALERTMESSAGE, message: "")
                return true}
        } else{
            guard let password = txtConfirmPassword.text , password != ""else {
                
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: ALERTMESSAGE, message: "Please enter confirm new password".LocalizableString(localization: "da"))
                } else {
                    showAlert(title: ALERTMESSAGE, message: "Please enter confirm new password".LocalizableString(localization: "da"))
                }
                return true}
        }
        guard let Confirmpassword = txtConfirmPassword.text , Confirmpassword != "" ,isValidatePasswordLength(password: txtConfirmPassword.text) else {showAlert(title: "Alert", message: "Please enter confirm password")
            return true}
        
        return false
    }
    func isValidatePasswordLength(password:String?)-> Bool
    {
        if (password?.count)!   >= 6{
            return true
        }
        else{
            if (MyDefaults().language ?? "") as String ==  "en"{
                showAlert(title: ALERTMESSAGE, message: "Password_must_be_at_least_6_digits_long".LocalizableString(localization: "en"))
            } else {
                
                showAlert(title: ALERTMESSAGE, message: "Password_must_be_at_least_6_digits_long".LocalizableString(localization: "da"))
            }
            
            return false
        }
    }
    
    func changeLanguage(strLanguage:String) {
        
            self.lblYourPasswordMustHavemorethan6digit.text = "Your_password_must".LocalizableString(localization: strLanguage)
            self.lblCreatePassword.text = "CreatePassword".LocalizableString(localization: strLanguage)
            self.btnSubmit.setTitle("Received".LocalizableString(localization: strLanguage), for: .normal)
            self.txtPassword.placeholder = "Password".LocalizableString(localization: strLanguage)
            self.txtConfirmPassword.placeholder = "Confirm Password".LocalizableString(localization: strLanguage)
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
                                        "new_password":self.txtPassword.text!,
                                        "language":MyDefaults().language ?? AnyObject.self,
                                        ]
   
           print(parameter)
        HTTPService.callForPostApi(url:SetNewPasswordPassword , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              
                            let vc = Util.loadViewController(fromStoryboard: "LoginVC", storyboardName: "Main") as? LoginVC
                           
                            if let aVc = vc {
                               // aVc.hidesBottomBarWhenPushed = true
                            self.show(aVc, sender: nil)
                        }
                            
                           // self.navigationController?.popToRootViewController(animated: true)
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
                                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   }
          
       }
}
