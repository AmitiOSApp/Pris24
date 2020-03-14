//
//  LoginVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/23/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txfMobileNumber: UITextField!
    @IBOutlet weak var txfPassword: UITextField!

    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    @IBAction func btnLogin_Action(_ sender: UIButton) {
        // Check required field validation
        if isRequiredFieldValid() {
            // Resign all active responder
            resignAllActiveResponder()
            
            // Perform User Login API
            userLoginAPI_Call()
        }
    }

    // MARK: - Private Methods
    func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txfMobileNumber.text!) {
            Util.showAlertWithMessage("Please enter valid mobile number".localiz(), title: Key_Alert); return false
        }
        else if !Util.isValidString(txfPassword.text!) {
            Util.showAlertWithMessage("Please enter password".localiz(), title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfMobileNumber.isFirstResponder {
            txfMobileNumber.resignFirstResponder()
        }
        else if txfPassword.isFirstResponder {
            txfPassword.resignFirstResponder()
        }
    }

    // MARK: - API Methods
    private func userLoginAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
                
        let postParams: [String: AnyObject] =
            [
                kAPI_MobileNumber    : txfMobileNumber.text as AnyObject,
                kAPI_Password        : txfPassword.text as AnyObject,
                kAPI_DeviceType      : "ios" as AnyObject,
                kAPI_DeviceToken     : Util.getValidString((UserDefaults.standard.object(forKey: kAPI_DeviceToken) as? String)) as AnyObject,
                kAPI_CertificateType : appDelegate.certificateType as AnyObject,
                kAPI_Language        : UserLanguage.shared.languageCode as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.userLogin(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: "")
                return
            }
            DLog(message: "\(result)")
            
            if let userData = jsonObj[kAPI_UserData].dictionary {
                LoggedInUser.shared.initLoggedInUserFromResponse(userData as AnyObject)
            }
            
            DispatchQueue.main.async { [weak self] in
                let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
                if let aVc = vc {
                    self?.present(aVc, animated: true)
                }
            }
        }
    }

}
