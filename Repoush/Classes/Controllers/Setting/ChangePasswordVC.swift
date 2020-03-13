//
//  ChangePasswordVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txfOldPassword: UITextField!
    @IBOutlet weak var txfNewPassword: UITextField!
    @IBOutlet weak var txfConfirmNewPassword: UITextField!
    
    // MARK: - Property initialization
    
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
        if isRequiredFieldValid() {
            
            // Resign all active responder
            resignAllActiveResponder()
            
            // Perform Change password API
            changePasswordAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txfOldPassword.text!) {
            Util.showAlertWithMessage("Please enter old password", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfNewPassword.text!) {
            Util.showAlertWithMessage("Please enter new password", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfConfirmNewPassword.text!) {
            Util.showAlertWithMessage("Please enter confirm password", title: Key_Alert); return false
        }
        else if Util.isPwdLenth(password: txfNewPassword.text!, confirmPassword: txfConfirmNewPassword.text!) {
            Util.showAlertWithMessage("New password and confirm password length should be greater than or equal to 6 digits", title: Key_Alert); return false
        }
        else if !Util.isPasswordSame(password: txfNewPassword.text!, confirmPassword: txfConfirmNewPassword.text!) {
            Util.showAlertWithMessage("New password and confirm password should be same", title: Key_Alert); return false
        }
        else if txfOldPassword.text == txfNewPassword.text {
            Util.showAlertWithMessage("Old password and new password should not be same", title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfOldPassword.isFirstResponder {
            txfOldPassword.resignFirstResponder()
        }
        else if txfNewPassword.isFirstResponder {
            txfNewPassword.resignFirstResponder()
        }
        else if txfConfirmNewPassword.isFirstResponder {
            txfConfirmNewPassword.resignFirstResponder()
        }
    }
    
    // MARK: - API Methods
    private func changePasswordAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId             : LoggedInUser.shared.id as AnyObject,
                kAPI_OldPassword        : txfOldPassword.text as AnyObject,
                kAPI_NewPassword        : txfNewPassword.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.changePassword(postParams), callerObj: self, showHud:true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: Key_Alert)
                return
            }
            
            let alertController = UIAlertController(title: Key_Alert, message: jsonObj[Key_Message].stringValue , preferredStyle:UIAlertController.Style.alert)
            self?.present(alertController, animated: true, completion: nil)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self?.navigationController?.popViewController(animated: true)
            }))
        }
    }
    
}
