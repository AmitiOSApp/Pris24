//
//  NewPasswordVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class NewPasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txfNewPassword: CustomTextField!
    @IBOutlet weak var txfConfirmNewPassword: CustomTextField!
    
    // MARK: - Property initialization
    var mobileNumber = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Action(_ sender: UIButton) {
        // Check required field validation
        if isRequiredFieldValid() {
            
            // Resign all active responder
            resignAllActiveResponder()
            
            // Perform New password API
            setNewPasswordAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txfNewPassword.text!) {
            Util.showAlertWithMessage("Please enter new password".localiz(), title: ""); return false
        }
        else if !Util.isValidString(txfConfirmNewPassword.text!) {
            Util.showAlertWithMessage("Please enter confirm password".localiz(), title: ""); return false
        }
        else if (txfNewPassword.text?.count)! < 6 || (txfConfirmNewPassword.text?.count)! < 6 {
            Util.showAlertWithMessage("New password and confirm password length should be greater than or equal to 6 digits".localiz(), title: ""); return false
        }
        else if !Util.isPasswordSame(password: txfNewPassword.text!, confirmPassword: txfConfirmNewPassword.text!) {
            Util.showAlertWithMessage("New password and confirm password should be same".localiz(), title: ""); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfNewPassword.isFirstResponder {
            txfNewPassword.resignFirstResponder()
        }
        if txfConfirmNewPassword.isFirstResponder {
            txfConfirmNewPassword.resignFirstResponder()
        }
    }
    
    // MARK: - API Methods
    private func setNewPasswordAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_MobileNumber   : mobileNumber as AnyObject,
                kAPI_NewPassword    : txfNewPassword.text as AnyObject
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.setNewPassword(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: "")
                return
            }
            DLog(message: "\(result)")
            
            DispatchQueue.main.async { [weak self] in
                let uiAlert = UIAlertController(title: "", message: jsonObj[Key_Message].stringValue, preferredStyle:UIAlertController.Style.alert)
                self?.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
                    
                    let controllers = self?.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is LoginVC {
                            self?.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }))
            }
        }
    }
    
}
