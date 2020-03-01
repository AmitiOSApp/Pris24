//
//  ForgotPasswordVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txfEmail: CustomTextField!
    @IBOutlet weak var txfOTP: CustomTextField!
    @IBOutlet weak var viewOTP: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    // MARK: - Property initialization
    private var emailAddress = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNext_Action(_ sender: UIButton) {
        
        // Resign all active responder
        resignAllActiveResponder()
        
        if sender.titleLabel?.text == "SEND OTP" {
            if !Util.isValidString(txfEmail.text!) {
                Util.showAlertWithMessage("Please enter email address", title: Key_Alert); return
            }
            else if !Util.isValidEmail(txfEmail.text!) {
                Util.showAlertWithMessage("Please enter valid email address", title: Key_Alert); return
            }
            // Perform Send OTP API
            sendOTPAPI_Call()
        }
        else {
            if !Util.isValidString(txfOTP.text!) {
                Util.showAlertWithMessage("Please enter OTP", title: Key_Alert); return
            }
            // Perform Verify OTP API
            verifyOTPAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func resignAllActiveResponder() {
        if txfEmail.isFirstResponder {
            txfEmail.resignFirstResponder()
        }
        if txfOTP.isFirstResponder {
            txfOTP.resignFirstResponder()
        }
    }
    
    // MARK: - API Methods
    private func sendOTPAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Email : txfEmail.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.sendOTP(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: "")
                return
            }
            DLog(message: "\(result)")
            
            Util.showAlertWithMessage("OTP sent successfully on your registered email id", title: "")
            
            DispatchQueue.main.async { [weak self] in
                self?.emailAddress = (self?.txfEmail.text)!
                self?.viewOTP.isHidden = false
                self?.btnNext.setTitle("VERIFY OTP", for: .normal)
            }
        }
    }
    
    private func verifyOTPAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Email : txfEmail.text as AnyObject,
                kAPI_OTP   : txfOTP.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.verifyOTP(postParams), callerObj: self, showHud: true) { (response) -> () in
            
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
                let vc = Util.loadViewController(fromStoryboard: "NewPasswordVC", storyboardName: "Main") as? NewPasswordVC
                vc?.email = self!.emailAddress
                if let aVc = vc {
                    self?.navigationController?.show(aVc, sender: nil)
                }
            }
        }
    }
    
}
