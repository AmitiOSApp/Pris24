//
//  ChangeEmailVC.swift
//  Repoush
//
//  Created by Apple on 06/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift

protocol delegateChangeEmail {
    func delegatChangeEmail(email:String)
}
class ChangeEmailVC: UIViewController {
    @IBOutlet weak var txtEmail : ACFloatingTextfield!
    @IBOutlet weak var txtEnterOTP : ACFloatingTextfield!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var btnCross : UIButton!
    @IBOutlet weak var btnVerify : UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnCrosWidthConstraints : NSLayoutConstraint!
    @IBOutlet weak var viewVeryFy : UIView!
    @IBOutlet weak var viewVeryFyConstraint : NSLayoutConstraint!
    var delagate: delegateChangeEmail!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.viewVeryFy.isHidden = true
        self.viewVeryFyConstraint.constant = 0
        self.btnCross.isHidden = true
        self.btnCrosWidthConstraints.constant = 0
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func actionOnBack(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionOnCross(_ sender:Any){
        self.viewVeryFy.isHidden = true
        self.viewVeryFyConstraint.constant = 0
        self.btnCross.isHidden = true
        self.btnCrosWidthConstraints.constant = 0
    }
    @IBAction func actionOnSendOTP(_ sender:UIButton){
       if let buttonTitle = sender.title(for: .normal) {
            if buttonTitle == "Send" {
                if  isConnectedToInternet() {
                     if isRequiredEmailFieldValid(){
                         self.callServiceChangeEmailAPI()
                     }
                } else {
                        self.showErrorPopup(message: internetConnetionError, title: alert)
                }
            }else{
                if  isConnectedToInternet() {
                        self.callServiceResendAPI()
                } else {
                        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
 }
    }
    @IBAction func actionOnVeryfy(_ sender:UIButton){
        if  isConnectedToInternet() {
                self.callServiceVeryOTPAPI()
        } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    private func isRequiredEmailFieldValid() -> Bool {
           if !Util.isValidString(txtEmail.text!) {
                   Util.showAlertWithMessage("Please enter valid email".localiz(), title: Key_Alert)
               return false
               }
           return true
       }
    func callServiceChangeEmailAPI() {
        var loading = ""
      if (MyDefaults().language ?? "") as String ==  "en"{
          loading = "Loading".LocalizableString(localization: "en")
      } else{
          loading = "Loading".LocalizableString(localization: "da")
      }
        
        let parameter: [String: Any] = [ "language": MyDefaults().language ?? AnyObject.self,
                                         "email":self.txtEmail.text!,
                                         "user_id":LoggedInUser.shared.id!]
                print(parameter)
        HTTPService.callForPostApi(url:getChangeEmailAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                              debugPrint(response)
                            //  HideHud()
                              if response.count != nil {
                                  let status = response["responseCode"] as! Int
                                  let message = response["message"] as! String
                                  if status == 200  {
                                    self.btnSend.setTitle("Resend", for: .normal)
                                    self.viewVeryFy.isHidden = false
                                    self.viewVeryFyConstraint.constant = 120
                                    self.btnCross.isHidden = false
                                    self.btnCrosWidthConstraints.constant = 18
                                    
                                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                  } else if status == 500 {
                                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                  }
                                  }else{
                                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                              }
                  }
    }
    func callServiceResendAPI() {
        var loading = ""
      if (MyDefaults().language ?? "") as String ==  "en"{
          loading = "Loading".LocalizableString(localization: "en")
      } else{
          loading = "Loading".LocalizableString(localization: "da")
      }
        let parameter: [String: Any] = [ "language": MyDefaults().language ?? AnyObject.self,
                                         "email":self.txtEmail.text!,
                                         "user_id":LoggedInUser.shared.id!]
                    print(parameter)
        HTTPService.callForPostApi(url:getChangeEmailAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                              debugPrint(response)
                            //  HideHud()
                              if response.count != nil {
                                  let status = response["responseCode"] as! Int
                                  let message = response["message"] as! String
                                  if status == 200  {
                                    self.btnSend.setTitle("Resend", for: .normal)
                                    self.viewVeryFy.isHidden = false
                                    self.viewVeryFyConstraint.constant = 120
                                    self.btnCross.isHidden = false
                                    self.btnCrosWidthConstraints.constant = 18
                                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                    if (MyDefaults().language ?? "") as String ==  "en"{
                                        self.changeLanguage(strLanguage: "en")
                                    } else{
                                        self.changeLanguage(strLanguage: "da")
                                    }
                                  } else if status == 500 {
                                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                    self.viewVeryFy.isHidden = true
                                    self.viewVeryFyConstraint.constant = 0
                                    self.btnCross.isHidden = true
                                    self.btnCrosWidthConstraints.constant = 0
                                  }
                                  }else{
                                  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                              }
                  }
        }
    func callServiceVeryOTPAPI() {
        var loading = ""
      if (MyDefaults().language ?? "") as String ==  "en"{
          loading = "Loading".LocalizableString(localization: "en")
      } else{
          loading = "Loading".LocalizableString(localization: "da")
      }
        
        let parameter: [String: Any] = [ "language": MyDefaults().language ?? AnyObject.self,
                                         "email":self.txtEmail.text!,
                                         "otp":self.txtEnterOTP.text!,
                                         "user_id":LoggedInUser.shared.id!]
                    print(parameter)
        HTTPService.callForPostApi(url:getUserChangeEmailVeryfyOtpAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                              debugPrint(response)
                            //  HideHud()
                              if response.count != nil {
                                  let status = response["responseCode"] as! Int
                                  let message = response["message"] as! String
                                  if status == 200  {
                                    if self.delagate != nil{
                                        self.delagate.delegatChangeEmail(email: self.txtEmail.text!)
                                    }
                                  
                                  } else if status == 500 {
                                    self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                  }
                                  }else{
                                  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                              }
                  }
        }
    func changeLanguage(strLanguage:String) {
       
        self.txtEmail.placeholder = "EmailAddress".LocalizableString(localization: strLanguage)
        self.txtEnterOTP.placeholder = "enter_otp".LocalizableString(localization: strLanguage)
        self.btnVerify.setTitle("Verify".LocalizableString(localization: strLanguage), for: .normal)
        self.lblTitle.text = "Change Email".LocalizableString(localization: strLanguage)
        
        if let buttonTitle = self.btnSend.title(for: .normal) {
            if buttonTitle == "Resend" {
                self.btnSend.setTitle("Resend".LocalizableString(localization: strLanguage), for: .normal)
            }else{
                self.btnSend.setTitle("SendOtp".LocalizableString(localization: strLanguage), for: .normal)
            }
          }
       
    }
}

