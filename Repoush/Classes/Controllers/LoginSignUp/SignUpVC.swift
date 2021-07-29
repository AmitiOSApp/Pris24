//
//  SignUpVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/23/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
class SignUpVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txfFirstName: ACFloatingTextfield!
    @IBOutlet weak var txfLastName: ACFloatingTextfield!
    @IBOutlet weak var txfindustryName: ACFloatingTextfield!
    @IBOutlet weak var txfEmail: ACFloatingTextfield!
    @IBOutlet weak var txfVerifyOtp: ACFloatingTextfield!
    @IBOutlet weak var txfPassword: ACFloatingTextfield!
    @IBOutlet weak var txfConfirmPassword: ACFloatingTextfield!
    @IBOutlet weak var txfEnterCVR: ACFloatingTextfield!
    @IBOutlet weak var txfCompanyName: ACFloatingTextfield!
    @IBOutlet weak var txfCity: ACFloatingTextfield!
    @IBOutlet weak var txfZipCode: ACFloatingTextfield!
    @IBOutlet weak var txfAddress: ACFloatingTextfield!
    @IBOutlet weak var txtUseName: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnTermsCondition: UIButton!
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var btnSendOtp: UIButton!
     @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var viewEnterOtp: UIView!
    @IBOutlet weak var viewPersonal: UIView!
    @IBOutlet weak var viewViewDetail: UIView!
    @IBOutlet weak var viewProfessional: UIView!
    @IBOutlet weak var viewVerifyOtp: UIView!
    @IBOutlet weak var viewPromoCode: UIView!
    @IBOutlet weak var viewAgreeTerms: UIView!
    @IBOutlet weak var viewGender: UIView!
    @IBOutlet weak var viewGenderHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewAgreeTermsHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewViewpromoCodeHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewPersonalHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewViewDetailHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewProfessionalHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var viewEnterOtpHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var imgViewPersonal: UIImageView!
    @IBOutlet weak var imgViewProfessional: UIImageView!
    
    @IBOutlet weak var lblSignUPLoc: UILabel!
    @IBOutlet weak var lblAlreadyhaveanaccountLoc: UILabel!
    @IBOutlet weak var lblLoginLoc: UILabel!
    @IBOutlet weak var lblYourPasswordHavemust: UILabel!
   
    @IBOutlet weak var lblAgreeToTheFollowing: UILabel!
    @IBOutlet weak var imgTermsConditions: UIImageView!
    @IBOutlet weak var imgverify: UIImageView!
    @IBOutlet weak var imgverifyConstant: NSLayoutConstraint!
    
    @IBOutlet weak var imgPromoCode: UIImageView!
    @IBOutlet weak var imgGenderMale: UIImageView!
    @IBOutlet weak var imgGenderFeMale: UIImageView!
    @IBOutlet weak var imgPromoCodeConstant: NSLayoutConstraint!
    @IBOutlet weak var txtPromoCode: UITextField!
    @IBOutlet weak var lblTermsConditions: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var lblPersonal: UILabel!
    @IBOutlet weak var lblProfessional: UILabel!
    
    @IBOutlet weak var btnCrossPromoCode: UIButton!
    @IBOutlet weak var btnVeryfyOtpPromoCode: UIButton!
    
    var isTemsCondions = false
    var isOtpVeryFound = false
    var isPersonal = true
    var userType = ""
    var genderType = "1"
   // @IBOutlet weak var viewVerifyOtpHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    private enum ActionType: Int {
        case sendOtp = 100, verifyOtp, address, termsCondition, signUp
    }
    private var latitude = 0.0
    private var longitude = 0.0

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
        self.imgGenderMale.image = #imageLiteral(resourceName: "radio_active")
        self.imgGenderFeMale.image = #imageLiteral(resourceName: "radio")
        genderType = "1"
        self.imgverifyConstant.constant = 0
        self.imgverify.isHidden = true
        userType = "1"
        self.imgViewPersonal.image = #imageLiteral(resourceName: "radio_active")
        self.imgViewProfessional.image = #imageLiteral(resourceName: "radio")
        self.clearTextaBottomLine()
        self.hideEnterOtpView()
        self.btnTermsCondition.isSelected = false
    }
    func clearTextaBottomLine(){
        
        self.txfFirstName.lineColor = .clear
        self.txfLastName.lineColor = .clear
        self.txfEmail.lineColor = .clear
        self.txfVerifyOtp.lineColor = .clear
        self.txfPassword.lineColor = .clear
        self.txfConfirmPassword.lineColor = .clear
        self.txfEnterCVR.lineColor = .clear
        self.txfCompanyName.lineColor = .clear
        self.txfZipCode.lineColor = .clear
        self.txfAddress.lineColor = .clear
        self.txfCity.lineColor = .clear
        self.txfindustryName.lineColor = .clear
        self.viewViewDetailHeightConstant.constant = 0
        self.viewProfessionalHeightConstant.constant = 0
        self.viewViewpromoCodeHeightConstant.constant = 0
        self.viewAgreeTermsHeightConstant.constant = 0
        self.viewAgreeTerms.isHidden = true
        self.viewPromoCode.isHidden = true
        self.btnPersonal.isSelected = true
        self.viewViewDetail.isHidden = true
        self.viewProfessional.isHidden = true
        //self.btnSignUp.backgroundColor = colorLightGray
        
        
    }
    func changeLanguage(strLanguage:String) {
        
        self.lblSignUPLoc.text = "SignUp".LocalizableString(localization: strLanguage)
        self.lblAlreadyhaveanaccountLoc.text = "Already_have_an_account".LocalizableString(localization: strLanguage)
        self.lblLoginLoc.text = "login".LocalizableString(localization: strLanguage)
        self.lblYourPasswordHavemust.text = "YourPasswordmusthavemorethan6digits".LocalizableString(localization: strLanguage)
        self.lblAgreeToTheFollowing.text = "IAgreeetothefollowing".LocalizableString(localization: strLanguage)
        self.lblTermsConditions.text = "Terms_Conditon".LocalizableString(localization: strLanguage)
        self.txfFirstName.placeholder = "FirstName".LocalizableString(localization: strLanguage)
        self.txfLastName.placeholder = "LastName".LocalizableString(localization: strLanguage)
        self.txfindustryName.placeholder = "Industry_Name".LocalizableString(localization: strLanguage)
        self.txfVerifyOtp.placeholder = "EnterOTP".LocalizableString(localization: strLanguage)
        self.txfPassword.placeholder = "Password".LocalizableString(localization: strLanguage)
        self.txfConfirmPassword.placeholder = "Confirm Password".LocalizableString(localization: strLanguage)
        self.txfEnterCVR.placeholder = "Enter_CVR".LocalizableString(localization: strLanguage)
        self.txfCompanyName.placeholder = "CompanyName".LocalizableString(localization: strLanguage)
        self.txfCity.placeholder = "City".LocalizableString(localization: strLanguage)
        self.txfZipCode.placeholder = "Zip_Code".LocalizableString(localization: strLanguage)
        self.txfAddress.placeholder = "Address".LocalizableString(localization: strLanguage)
        self.txtPromoCode.placeholder = "PromoCode".LocalizableString(localization: strLanguage)
        self.btnSendOtp.setTitle("send_otp".LocalizableString(localization: strLanguage), for: .normal)
        self.btnVerify.setTitle("Verify".LocalizableString(localization: strLanguage), for: .normal)
        self.btnVeryfyOtpPromoCode.setTitle("Verify".LocalizableString(localization: strLanguage), for: .normal)
        self.btnSignUp.setTitle("SignUp".LocalizableString(localization: strLanguage), for: .normal)
       // self.btnPersonal.setTitle("Personal".LocalizableString(localization: strLanguage), for: .normal)
         self.lblPersonal.text = "Personal".LocalizableString(localization: strLanguage)
        self.lblProfessional.text = "Professional".LocalizableString(localization: strLanguage)
        self.lblGender.text = "Gender".LocalizableString(localization: strLanguage)
        self.txtUseName.placeholder = "UserName".LocalizableString(localization: strLanguage)
     
        }
    // MARK: - Action Methods
    @IBAction func actionOnCross(_ sender: UIButton) {
        self.viewEnterOtpHeightConstant.constant = 64
        self.viewVerifyOtp.isHidden = true
        self.viewAgreeTerms.isHidden = true
        self.viewAgreeTermsHeightConstant.constant = 0
        self.imgverifyConstant.constant = 0
        self.imgverify.isHidden = true
        self.viewViewDetailHeightConstant.constant = 0
        self.viewViewDetail.isHidden = true
        self.viewViewpromoCodeHeightConstant.constant = 0
        self.viewViewDetail.isHidden = true
        self.viewEnterOtpHeightConstant.constant = 0
        self.viewEnterOtp.isHidden = true
    }
     @IBAction func actionOnAddres(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @IBAction func actionOnEmailAddress(_ sender: UIButton) {
       self.hideEnterOtpView()
    }
    @IBAction func actionOnGenderMale(_ sender: UIButton) {
        self.imgGenderMale.image = #imageLiteral(resourceName: "radio_active")
        self.imgGenderFeMale.image = #imageLiteral(resourceName: "radio")
        genderType = "1"
    }
    @IBAction func actionOnGenderFeMale(_ sender: UIButton) {
        genderType = "2"
        self.imgGenderMale.image = #imageLiteral(resourceName: "radio")
        self.imgGenderFeMale.image = #imageLiteral(resourceName: "radio_active")
    }
    @IBAction func actionOnPromoCodeCross(_ sender: UIButton) {
        self.txtPromoCode.text = ""
        self.btnVeryfyOtpPromoCode.isHidden =  false
         self.btnCrossPromoCode.isHidden =  true
        
        self.imgPromoCodeConstant.constant = 0
        self.imgPromoCode.isHidden = true
        
    }
    @IBAction func actionOnPromoCodeVeryFy(_ sender: UIButton) {
       if isRequiredPromoCode() {
           // Resign all active responder
            if  isConnectedToInternet() {
                callServiceVeryFyPromoCode()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
        
    }
    private func isRequiredPromoCode() -> Bool {
    if !Util.isValidString(txtPromoCode.text!) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("promo_code_blank_error".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("promo_code_blank_error".LocalizableString(localization: "da"), title: ""); return false
        }
       
    }
         return true
    }
    func callServiceVeryFyPromoCode() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["promo_code": self.txtPromoCode.text!]
           print(parameter)
        HTTPService.callForPostApi(url:checkPromocodeAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                                    let response = ModelCategory.init(fromDictionary: response as! [String : Any])
                            self.btnVeryfyOtpPromoCode.isHidden = true
                            self.btnCrossPromoCode.isHidden = false
                            self.imgPromoCode.isHidden = false
                           } else if status == 500 {
                                   
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
       }
    func hideEnterOtpView() {
        self.viewPersonalHeightConstant.constant = 136
        self.viewEnterOtpHeightConstant.constant = 54
        self.viewEnterOtp.isHidden = false
        self.viewVerifyOtp.isHidden = true
        self.btnVerify.isHidden = true
        self.btnCross.isHidden = true
        self.viewGender.isHidden = true
        self.viewGenderHeightConstant.constant = 0
    }
    
    @IBAction func actionOnProfessional(_ sender: UIButton) {
//        if !self.btnProfessional.isSelected {
        self.txtUseName.text = ""
        self.isPersonal = false
        userType = "2"
        self.showProfessionalView()
        self.imgViewPersonal.image = #imageLiteral(resourceName: "radio")
        self.imgViewProfessional.image = #imageLiteral(resourceName: "radio_active")
       // self.viewAgreeTermsHeightConstant.constant = 0
       // self.viewAgreeTerms.isHidden = true
        
        self.viewPersonalHeightConstant.constant = 66
        self.viewPersonal.isHidden = false
        self.viewProfessionalHeightConstant.constant = 324
        self.viewProfessional.isHidden = false
        self.viewViewDetailHeightConstant.constant = 0
        self.viewViewDetail.isHidden = true
        self.viewAgreeTermsHeightConstant.constant = 0
        self.viewAgreeTerms.isHidden = true
        self.viewViewpromoCodeHeightConstant.constant = 0
        self.viewPromoCode.isHidden = true
        self.viewViewpromoCodeHeightConstant.constant = 0
        self.viewPromoCode.isHidden = true
        self.viewEnterOtpHeightConstant.constant = 54
        self.viewGender.isHidden = true
        self.viewGenderHeightConstant.constant = 0
        self.viewEnterOtp.isHidden = false
        self.viewVerifyOtp.isHidden = true
        self.btnVerify.isHidden = true
        self.btnCross.isHidden = true
        imgPromoCode.isHidden = true
        self.txfEmail.text = ""
        self.txfEnterCVR.text = ""
        self.txfCompanyName.text = ""
        self.txfindustryName.text = ""
        self.txfCity.text = ""
        self.txfZipCode.text = ""
        
    }
    @IBAction func actionOnPersonal(_ sender: UIButton) {
        self.txfFirstName.text = ""
        self.txfLastName.text = ""
        self.isPersonal = true
        userType = "1"
        self.imgViewPersonal.image =  #imageLiteral(resourceName: "radio_active")
        self.imgViewProfessional.image = #imageLiteral(resourceName: "radio")
        self.imgverify.isHidden = true
        self.showPersonalView()
    }
    @IBAction func actionOnSendOtp(_ sender: UIButton) {
        if self.isPersonal {
            if isRequiredFieldValid() {
                // Perform User registration API
                sendOTPAPI_Call()
            }
        }
        else{
            if isRequiredProfessionalFieldValid() {
                // Perform User registration API
                sendOTPAPI_Call()
            }
            
            
        }
    }
    @IBAction func actionOnVeriFy(_ sender: UIButton) {
       if isRequiredVeryFyOtpFieldValid() {
            // Perform User registration API
            verifyOTPAPI_Call()
        }
    }
    @IBAction func actionOnIAgree(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            self.isTemsCondions = true
             self.imgTermsConditions.image = UIImage.init(named: "radio_active")
            }
        else {
            sender.isSelected = false
           self.isTemsCondions = false
             self.imgTermsConditions.image = UIImage.init(named: "radio")
            }
    }
    @IBAction func actionOnTermsCondittions(_ sender: UIButton) {
        self.termsCondtions()
    }
    func termsCondtions()  {
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : TermsConditionsSignUpVC = pop.instantiateViewController(withIdentifier: "TermsConditionsSignUpVC") as! TermsConditionsSignUpVC
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    @IBAction func actionOnSignUp(_ sender: UIButton) {
    
        if !self.isPersonal {
           if isRequiredProfessionalFieldValid() {
            if isRequiredPersnolvalidation(){
                    userRegistrationAPI_Call()
                }
    }
        }else{
            if isRequiredPersnolvalidation() {
            userRegistrationAPI_Call()
            }
        }
      
    }
    func showProfessionalView() {
       
        if !isOtpVeryFound {
            self.viewPersonalHeightConstant.constant = 0
            self.viewPersonal.isHidden = true
            self.viewProfessionalHeightConstant.constant = 324
            self.viewProfessional.isHidden = false
            self.viewViewDetailHeightConstant.constant = 0
            self.viewViewDetail.isHidden = true
            
        }else{
            self.viewPersonalHeightConstant.constant = 0
            self.viewPersonal.isHidden = true
            self.viewProfessionalHeightConstant.constant = 324
            self.viewProfessional.isHidden = false
            self.viewViewDetailHeightConstant.constant = 270
            self.viewViewDetail.isHidden = false
        }
    }
    func showPersonalView() {
        if !isOtpVeryFound {
            self.viewPersonalHeightConstant.constant = 136
            self.viewPersonal.isHidden = false
            self.viewProfessionalHeightConstant.constant = 0
            self.viewProfessional.isHidden = true
            self.viewViewDetailHeightConstant.constant = 0
            self.viewViewDetail.isHidden = true
            self.viewGender.isHidden = true
            self.viewGenderHeightConstant.constant = 0
        }else{
            self.viewPersonalHeightConstant.constant = 138
            self.viewPersonal.isHidden = false
            self.viewProfessionalHeightConstant.constant = 0
            self.viewProfessional.isHidden = true
            self.viewViewDetailHeightConstant.constant = 0
            self.viewViewDetail.isHidden = true
            self.viewViewpromoCodeHeightConstant.constant = 0
            self.viewPromoCode.isHidden = true
            self.viewPromoCode.isHidden = false
            self.viewViewpromoCodeHeightConstant.constant = 0
            self.viewPromoCode.isHidden = true
            self.viewGender.isHidden = true
            self.viewGenderHeightConstant.constant = 0
            self.viewAgreeTerms.isHidden = true
            self.viewAgreeTermsHeightConstant.constant = 0
            self.viewEnterOtpHeightConstant.constant = 0
            self.viewEnterOtp.isHidden = true
            self.txfEmail.text = ""
            self.txfVerifyOtp.text = ""
        }
    }
    // MARK: - Private Methods
    private func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txtUseName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_user_name".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_user_name".LocalizableString(localization: "da"), title: ""); return false
            }
        }
        else if !Util.isValidString(txfFirstName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("first_name_blank_error".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("first_name_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
        }
        else if !Util.isValidString(txfLastName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("last_name_blank_error".LocalizableString(localization: "en"), title: ""); return false
            }else{
                Util.showAlertWithMessage("last_name_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
            
        }else if !Util.isValidEmail(txfEmail.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "en"), title: ""); return false
            }else{
                Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "da"), title: ""); return false
            }
            
        }
        return true
    }
    private func isRequiredProfessionalFieldValid() -> Bool {
        if !Util.isValidString(txtUseName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_user_name".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_user_name".LocalizableString(localization: "da"), title: ""); return false
            }
        }
        else  if !Util.isValidString(txfEnterCVR.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("CVR_number_blank_error".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("CVR_number_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
            
           }else if !Util.isValidString(txfCompanyName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("company_name_blank_error".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("company_name_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
            
           }else if !Util.isValidString(txfindustryName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_industry_name".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_industry_name".LocalizableString(localization: "da"), title: ""); return false
            }
            
           }else if !Util.isValidString(txfCity.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("city_blank_error".LocalizableString(localization: "en"), title: ""); return false
            } else {
                Util.showAlertWithMessage("city_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
           
           }else if !Util.isValidString(txfZipCode.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("zipCode_blank_error".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("zipCode_blank_error".LocalizableString(localization: "da"), title: ""); return false
            }
        }
           else if !Util.isValidEmail(txfEmail.text!) {
               if (MyDefaults().language ?? "") as String ==  "en"{
                   Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "en"), title: ""); return false
               }else{
                   Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "da"), title: ""); return false
               }
           }
           return true
       }
    private func isRequiredVeryFyOtpFieldValid() -> Bool {
           if !Util.isValidString(txfVerifyOtp.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_OTP_Verification_code".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_OTP_Verification_code".LocalizableString(localization: "da"), title: ""); return false
            }
          //  Util.showAlertWithMessage("Please enter OTP Verification code".localiz(), title: Key_Alert); return false
           }
          return true
       }
       
    private func resignAllActiveResponder() {
//        if txfFirstName.isFirstResponder {
//            txfFirstName.resignFirstResponder()
//        }
//        else if txfLastName.isFirstResponder {
//            txfLastName.resignFirstResponder()
//        }
//        else if txfMobileNumber.isFirstResponder {
//            txfMobileNumber.resignFirstResponder()
//        }
//        else if txfVerifyOtp.isFirstResponder {
//            txfVerifyOtp.resignFirstResponder()
//        }
//        else if txfPassword.isFirstResponder {
//            txfPassword.resignFirstResponder()
//        }
//        else if txfConfirmPassword.isFirstResponder {
//            txfConfirmPassword.resignFirstResponder()
//        }
    }
    private func isRequiredPersnolvalidation() -> Bool {
        if isPersonal  {
            if !Util.isValidString(txfAddress.text!) {
                     if (MyDefaults().language ?? "") as String ==  "en"{
                         Util.showAlertWithMessage("Please_enter_address".LocalizableString(localization: "en"), title: ""); return false
                     } else{
                         Util.showAlertWithMessage("Please_enter_address".LocalizableString(localization: "da"), title: ""); return false
                     }
                 }
            
                 else if !Util.isValidString(txfPassword.text!) {
                     if (MyDefaults().language ?? "") as String ==  "en"{
                         Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "en"), title: ""); return false
                     } else{
                         Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "da"), title: ""); return false
                     }
                    
             }
             else if (txfPassword.text?.count)! < 6 {
                 if (MyDefaults().language ?? "") as String ==  "en"{
                    
                     Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "en"), title: ""); return false
                 } else{
                     Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "da"), title: ""); return false
                 }
                 }
             else if !Util.isValidString(txfConfirmPassword.text!) {
                 if (MyDefaults().language ?? "") as String ==  "en"{
                     Util.showAlertWithMessage("Please enter confirm  password".LocalizableString(localization: "en"), title: ""); return false
                 } else{
                     Util.showAlertWithMessage("Please enter confirm  password".LocalizableString(localization: "da"), title: ""); return false
                     
                 }
                
             }
             else if (txfConfirmPassword.text?.count)! < 6 {
                 if (MyDefaults().language ?? "") as String ==  "en"{
                     Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "en"), title: ""); return false
                 } else{
                     Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "da"), title: ""); return false
                 }
                 
             }
             else if !Util.isPasswordSame(password: txfPassword.text!, confirmPassword: txfConfirmPassword.text!) {
                 if (MyDefaults().language ?? "") as String ==  "en"{
                     Util.showAlertWithMessage("Password and confirm password should be same".LocalizableString(localization: "en"), title: ""); return false
                 } else{
                     Util.showAlertWithMessage("Password and confirm password should be same".LocalizableString(localization: "da"), title: ""); return false
                 }
             }
             else if self.isTemsCondions == false {
                 if (MyDefaults().language ?? "") as String ==  "en"{
                     Util.showAlertWithMessage("Please accept terms of use".LocalizableString(localization: "en"), title: ""); return false
                 } else{
                     Util.showAlertWithMessage("Please accept terms of use".LocalizableString(localization: "da"), title: ""); return false
                 }
                 }
        } else {
       
        if !Util.isValidString(txfAddress.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_address".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_address".LocalizableString(localization: "da"), title: ""); return false
            }
        }
   
        else if !Util.isValidString(txfPassword.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "en"), title: ""); return false
            } else{
                Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "da"), title: ""); return false
            }
           
    }
    else if (txfPassword.text?.count)! < 6 {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "en"), title: ""); return
              false
        } else{
            Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "da"), title: ""); return
              false
        }
        }
    else if !Util.isValidString(txfConfirmPassword.text!) {
        
        if (MyDefaults().language ?? "") as String ==  "en"{
             Util.showAlertWithMessage("Please enter confirm  password".LocalizableString(localization: "en"), title: ""); return false
        } else{
             Util.showAlertWithMessage("Please enter confirm  password".LocalizableString(localization: "da"), title: ""); return false
        }
    }
    
    else if (txfConfirmPassword.text?.count)! < 6 {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("Password length should be greater than or equal to 6 digits".LocalizableString(localization: "da"), title: ""); return false
        }
        
    }
    else if !Util.isPasswordSame(password: txfPassword.text!, confirmPassword: txfConfirmPassword.text!) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Password and confirm password should be same".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("Password and confirm password should be same".LocalizableString(localization: "da"), title: ""); return false
        }
    }  else if !Util.isValidString(txtMobileNumber.text!) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Please enter mobile number".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("Please enter mobile number".LocalizableString(localization: "da"), title: ""); return false
            
        }
    }else if !Util.isValidString(txtPromoCode.text!) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("promo_code_blank_error".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("promo_code_blank_error".LocalizableString(localization: "da"), title: ""); return false
            
        }
       
    }
    else if self.isTemsCondions == false {
        if (MyDefaults().language ?? "") as String ==  "en"{
            Util.showAlertWithMessage("Please accept terms of use".LocalizableString(localization: "en"), title: ""); return false
        } else{
            Util.showAlertWithMessage("Please accept terms of use".LocalizableString(localization: "da"), title: ""); return false
        }
        }
        }
    return true
    
    }
    // MARK: - API Methods
    private func sendOTPAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Email : txfEmail.text as AnyObject,
                kAPI_Language     : MyDefaults().language as AnyObject,
                kAPI_UserType : userType as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.sendOTP(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            print(postParams)
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
            
            DispatchQueue.main.async { [weak self] in
               // self?.viewVerifyOtpHgtConst.constant = 45.0
              
                if  self?.isPersonal == true {
                    self?.viewPersonalHeightConstant.constant = 136
                    self?.viewPersonal.isHidden = false
                    self?.viewEnterOtpHeightConstant.constant = 54
                    self?.viewEnterOtp.isHidden = false
                    self?.viewVerifyOtp.isHidden = false
                    self?.btnVerify.isHidden = false
//                    self?.btnCross.isHidden = false
//                    self?.isOtpVeryFound = true
                    //self?.viewGender.isHidden = false
                    //self?.viewGenderHeightConstant.constant = 40
                } else{
                    self?.txfVerifyOtp.text = ""
                    self?.viewPersonalHeightConstant.constant = 66
                    self?.viewPersonal.isHidden = false

                    self?.viewEnterOtpHeightConstant.constant = 54
                    self?.viewEnterOtp.isHidden = false
                    self?.viewVerifyOtp.isHidden = false
                    self?.isOtpVeryFound = true
                    self?.imgverify.isHidden = true
                    self?.btnVerify.isHidden = false
                    self?.btnCross.isHidden = false
                    self?.viewGender.isHidden = true
                    self?.viewGenderHeightConstant.constant = 0
                    }
                }
        }
    }

    private func verifyOTPAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Email : txfEmail.text as AnyObject,
                kAPI_Language     : MyDefaults().language as AnyObject,
                kAPI_OTP          : txfVerifyOtp.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.verifyOTP(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
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
            
            DispatchQueue.main.async { [weak self] in
                    
                if  self?.isPersonal == true {
                        self?.viewViewDetail.isHidden = false
                        self?.viewViewDetailHeightConstant.constant = 270
                        self?.viewAgreeTerms.isHidden = false
                        self?.viewAgreeTermsHeightConstant.constant = 74
                        self?.imgverifyConstant.constant = 17
                        self?.imgverify.isHidden = false
                        self?.viewGender.isHidden = false
                        self?.viewGenderHeightConstant.constant = 40
                } else{
                    
                    self?.viewViewDetailHeightConstant.constant = 270
                    self?.viewViewDetail.isHidden = false
                     self?.imgverify.isHidden = false
                    self?.viewViewpromoCodeHeightConstant.constant = 52
                    self?.viewPromoCode.isHidden = false
                    self?.viewAgreeTermsHeightConstant.constant = 74
                    self?.viewAgreeTerms.isHidden = false
                    self?.btnCrossPromoCode.isHidden = true
                    self?.viewGender.isHidden = true
                    self?.viewGenderHeightConstant.constant = 0
                }
                
                   
            }
        }
    }
    
    private func userRegistrationAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_FirstName       : txfFirstName.text as AnyObject,
                kAPI_LastName        : txfLastName.text as AnyObject,
                kAPI_Email    : txfEmail.text as AnyObject,
                kAPI_Password        : txfPassword.text as AnyObject,
                kAPI_DeviceType      : "ios" as AnyObject,
                kAPI_DeviceToken     : Util.getValidString((UserDefaults.standard.object(forKey: kAPI_DeviceToken) as? String)) as AnyObject,
                kAPI_CertificateType : appDelegate.certificateType as AnyObject,
                kAPI_Latitude        : latitude as AnyObject,
                kAPI_Longitude       : longitude as AnyObject,
                kAPI_Address         : txfAddress.text as AnyObject,
                kAPI_EnterCVR        : txfEnterCVR.text as AnyObject,
                kAPI_CompanyName        : txfCompanyName.text as AnyObject,
                kAPI_IndustyName        : txfindustryName.text as AnyObject,
                kAPI_City        : txfCity.text as AnyObject,
                kAPI_ZipCode        : txfZipCode.text as AnyObject,
                "promo_code": txtPromoCode.text as AnyObject,
                "username": txtUseName.text as AnyObject,
                "gender": genderType as AnyObject,
                "mobile_number":self.txtMobileNumber.text as AnyObject,
                kAPI_Language     : MyDefaults().language as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
       
        Networking.performApiCall(Networking.Router.userRegistration(postParams), callerObj: self, showHud:true, text: loading) { (response) -> () in
            
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
        MyDefaults().myDefaultAddress = place.name
        forwardGeocoding(address: place.formattedAddress!)
        
        self.txfAddress.text = place.formattedAddress!
        
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
                
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
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

// MARK: - UITextFieldDelegate Methods
extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.txtMobileNumber == textField {
            let maxLength = 8
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else  if self.txfZipCode == textField {
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    return true
}
    
}
