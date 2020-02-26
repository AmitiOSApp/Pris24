//
//  SignUpVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/23/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var txfMobileNumber: UITextField!
    @IBOutlet weak var txfVerifyOtp: UITextField!
    @IBOutlet weak var txfPassword: UITextField!
    @IBOutlet weak var txfConfirmPassword: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnTermsCondition: UIButton!
    @IBOutlet weak var viewExtraDetail: UIView!

    @IBOutlet weak var viewVerifyOtpHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    private enum ActionType: Int {
        case sendOtp = 100, verifyOtp, address, termsCondition, signUp
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action Methods
    @IBAction func btnUser_Action(_ sender: UIButton) {

        // Resign all active responder
        resignAllActiveResponder()

        if sender.tag == ActionType.sendOtp.rawValue {
            if !Util.isValidString(txfMobileNumber.text!) {
                Util.showAlertWithMessage("Please enter mobile number", title: Key_Alert); return
            }
            // Perform Send OTP API
            sendOTPAPI_Call()
        }
        else if sender.tag == ActionType.verifyOtp.rawValue {
            if !Util.isValidString(txfVerifyOtp.text!) {
                Util.showAlertWithMessage("Please enter OTP", title: Key_Alert); return
            }
            // Perform verify OTP API
            verifyOTPAPI_Call()
        }
        else if sender.tag == ActionType.address.rawValue {
            let acController = GMSAutocompleteViewController()
            acController.delegate = self
            present(acController, animated: true, completion: nil)
        }
        else if sender.tag == ActionType.termsCondition.rawValue {
            sender.isSelected = !sender.isSelected
        }
        else if sender.tag == ActionType.signUp.rawValue {
            // Check required field validation
            if isRequiredFieldValid() {
                // Perform User registration API
                userRegistrationAPI_Call()
            }
        }
    }
    
    // MARK: - Private Methods
    private func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txfFirstName.text!) {
            Util.showAlertWithMessage("Please enter first name", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfLastName.text!) {
            Util.showAlertWithMessage("Please enter last name", title: Key_Alert); return false
        }
        else if lblAddress.text!.isEmpty || lblAddress.text == "Address" {
            Util.showAlertWithMessage("Please select address", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfPassword.text!) {
            Util.showAlertWithMessage("Please enter password", title: Key_Alert); return false
        }
        else if (txfPassword.text?.count)! < 6 {
            Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfConfirmPassword.text!) {
            Util.showAlertWithMessage("Please enter confirm new password", title: Key_Alert); return false
        }
        else if (txfConfirmPassword.text?.count)! < 6 {
            Util.showAlertWithMessage("Confirm password length should be greater than or equal to 6 digits", title: Key_Alert); return false
        }
        else if !Util.isPasswordSame(password: txfPassword.text!, confirmPassword: txfConfirmPassword.text!) {
            Util.showAlertWithMessage("Password and confirm password should be same", title: Key_Alert); return false
        }
        else if !btnTermsCondition.isSelected {
            Util.showAlertWithMessage("Please accept terms of use", title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfFirstName.isFirstResponder {
            txfFirstName.resignFirstResponder()
        }
        else if txfLastName.isFirstResponder {
            txfLastName.resignFirstResponder()
        }
        else if txfMobileNumber.isFirstResponder {
            txfMobileNumber.resignFirstResponder()
        }
        else if txfVerifyOtp.isFirstResponder {
            txfVerifyOtp.resignFirstResponder()
        }
        else if txfPassword.isFirstResponder {
            txfPassword.resignFirstResponder()
        }
        else if txfConfirmPassword.isFirstResponder {
            txfConfirmPassword.resignFirstResponder()
        }
    }

    // MARK: - API Methods
    private func sendOTPAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_MobileNumber : txfMobileNumber.text as AnyObject,
                kAPI_Language     : "en" as AnyObject,
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
            
            Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: "")
        }
    }

    private func verifyOTPAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_MobileNumber : txfMobileNumber.text as AnyObject,
                kAPI_Language     : "en" as AnyObject,
                kAPI_OTP          : txfVerifyOtp.text as AnyObject,
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
            
            Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: "")
        }
    }

    private func userRegistrationAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_FirstName       : txfFirstName.text as AnyObject,
                kAPI_LastName        : txfLastName.text as AnyObject,
                kAPI_MobileNumber    : txfMobileNumber.text as AnyObject,
                kAPI_Password        : txfPassword.text as AnyObject,
                kAPI_DeviceType      : "ios" as AnyObject,
                kAPI_DeviceToken     : Util.getValidString((UserDefaults.standard.object(forKey: kAPI_DeviceToken) as? String)) as AnyObject,
                kAPI_CertificateType : appDelegate.certificateType as AnyObject,
                kAPI_Latitude        : appDelegate.latitude as AnyObject,
                kAPI_Longitude       : appDelegate.longitude as AnyObject,
                kAPI_Address         : lblAddress.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.userRegistration(postParams), callerObj: self, showHud:true) { (response) -> () in
            
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
                let uiAlert = UIAlertController(title: Key_Alert, message: jsonObj[Key_Message].stringValue, preferredStyle:UIAlertController.Style.alert)
                self?.present(uiAlert, animated: true, completion: nil)
                
                uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
                    let vc = Util.loadViewController(fromStoryboard: "LoginVC", storyboardName: "Main") as? LoginVC
                    if let aVc = vc {
                        self?.show(aVc, sender: nil)
                    }
                }))
            }
        }
    }

}

// MARK: - GMSAutocompleteViewControllerDelegate
extension SignUpVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        
        forwardGeocoding(address: place.formattedAddress!)
        
        self.lblAddress.text = place.formattedAddress!
        self.lblAddress.textColor = .black
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            let placemarkCount = placemarks?.count
            
            if placemarkCount! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                appDelegate.latitude = coordinate!.latitude
                appDelegate.longitude = coordinate!.longitude
            }
        })
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
}
