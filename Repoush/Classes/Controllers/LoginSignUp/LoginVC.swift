//
//  LoginVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/23/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
protocol gestuserLogin {
    func getDelegateGuestUserLogin(index:Int,isPlaceBid:Bool)
}
class LoginVC: UIViewController {
    var delagate: gestuserLogin!
    // MARK: - IBOutlets
    @IBOutlet weak var txfMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txfPassword: ACFloatingTextfield!
    @IBOutlet weak var lblNotRegistered: UILabel!
    @IBOutlet weak var lblLoginLoc: UILabel!
    @IBOutlet weak var lblSignUpLoc: UILabel!
    @IBOutlet weak var lblOrLoc: UILabel!
    @IBOutlet weak var btnLoginLoc: UIButton!
    @IBOutlet weak var btnSkipToHomeLoc: UIButton!
    @IBOutlet weak var btnForgotPasswordLoc: UIButton!
    
   
    var index : Int = 0
    // MARK: - Property initialization
    var isGuestUserLogin = false
    var isUserLogin = false
    var isPlaceBid = false
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     //   self.txfPassword.text = "123456"
     //  self.txfMobileNumber.text = "max@mailinator.com"
      //  self.txfMobileNumber.text = "maxpro@mailinator.com"
       //   self.txfPassword.text = "123456"
         // self.txfMobileNumber.text = "maxpro@mailinator.com"
          
//        self.txfPassword.text = "123456"
//       self.txfMobileNumber.text = "Pozedk@gmail.com"
        
        
     //   self.txfPassword.text = "123456"
    //   self.txfMobileNumber.text = "amit@mailinator.com"
        
//        self.txfPassword.text = "123456"
//        self.txfMobileNumber.text = "applepars@mailinator.com"
        
//               self.txfPassword.text = "123456"
//             self.txfMobileNumber.text = "applepro@mailinator.com"
        
//        self.txfPassword.text = "123456"
//        self.txfMobileNumber.text = "Farzaneh.heidari121@gmail.com"
        
     //   self.txfPassword.text = "12345678"
     //   self.txfMobileNumber.text = "professional@mailinator.com"
        
        
//        self.txfPassword.text = "123456789"
//        self.txfMobileNumber.text = "janet.aboudaher@gmail.com"
        
        

        
        self.txfMobileNumber.text = "test@mailinator.com"
        self.txfPassword.text = "123456789"
        
        
//            self.txfPassword.text = "123456"
//               self.txfMobileNumber.text = "test123@mailinator.com"
        
        
//                        self.txfPassword.text = "123456"
//                        self.txfMobileNumber.text = "amit@mailinator.com"
        
        self.txfPassword.text = "123456"
        self.txfMobileNumber.text = "ios@mailinator.com"
        
        if (MyDefaults().language ?? "") as String ==  "en"{
             self.changeLanguage(strLanguage: "en")
            } else{
            self.changeLanguage(strLanguage: "da")
        }
//        if isGuestUserLogin {
//            self.btnSkipToHomeLoc.isEnabled = false
//        } else{
//            self.btnSkipToHomeLoc.isEnabled = true
//        }
       // self.txfMobileNumber.text = "maxpro@mailinator.com"
      //  lblNotRegistered.font = UIFont(name: "Montserrat-Regular", size: 16)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
 
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//                case .notDetermined, .restricted, .denied:
//                    print("No access")
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("Access")
//                @unknown default:
//                break
//            }
//            } else {
//                print("Location services are not enabled")
//                
//                if (MyDefaults().language ?? "") as String ==  "en"{
//                    self.permissionGranted(title: "Location Permission Required", message: "Please enable location permissions in settings.", okay: "ok")
//                } else{
//                    self.permissionGranted(title: "Location Permission Required", message: "Please enable location permissions in settings.", okay: "ok")
//                }
//            }
    }
    func permissionGranted(title: String, message: String,okay:String)  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
           }
            alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
    }
    func changeLanguage(strLanguage:String) {
            self.lblOrLoc.text = "OR".LocalizableString(localization: strLanguage)
            self.lblNotRegistered.text = "NotregisterdYet".LocalizableString(localization: strLanguage)
            self.lblLoginLoc.text = "login".LocalizableString(localization: strLanguage)
            self.lblSignUpLoc.text = "SignUp".LocalizableString(localization: strLanguage)
            self.txfMobileNumber.placeholder = "Email_Address".LocalizableString(localization: strLanguage)
            self.txfPassword.placeholder = "Password".LocalizableString(localization: strLanguage)
            self.btnLoginLoc.setTitle("login".LocalizableString(localization: strLanguage), for: .normal)
            self.btnSkipToHomeLoc.setTitle("SkipToHome".LocalizableString(localization: strLanguage), for: .normal)
            self.btnForgotPasswordLoc.setTitle("ForgotPassword".LocalizableString(localization: strLanguage), for: .normal)
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
    @IBAction func btnSkipTo_Home(_ sender: UIButton) {
        
        if isUserLogin {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            DispatchQueue.main.async { [weak self] in
                           let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
                print(LoggedInUser.shared.id)
                
                if let aVc = vc {
                              // self?.present(aVc, animated: true)
                               self?.navigationController?.pushViewController(aVc, animated: true)
                           }
                       }
        }
        
      }
    
    // MARK: - Private Methods
    func isRequiredFieldValid() -> Bool {
        if !Util.isValidEmail(txfMobileNumber.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "en"), title: Key_Alert); return false
            } else{
                Util.showAlertWithMessage("Please_enter_email_address".LocalizableString(localization: "da"), title: Key_Alert); return false
            }
        }
        else if !Util.isValidString(txfPassword.text!) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "en"), title: Key_Alert); return false
            } else{
                Util.showAlertWithMessage("Please_enter_password".LocalizableString(localization: "da"), title: Key_Alert); return false
            }
            
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
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
                
        let postParams: [String: AnyObject] =
            [
                kAPI_Email    : txfMobileNumber.text as AnyObject,
                kAPI_Password        : txfPassword.text as AnyObject,
                kAPI_DeviceType      : "ios" as AnyObject,
                kAPI_DeviceToken     : Util.getValidString((UserDefaults.standard.object(forKey: kAPI_DeviceToken) as? String)) as AnyObject,
                kAPI_CertificateType : appDelegate.certificateType as AnyObject,
                kAPI_Language        : MyDefaults().language as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.userLogin(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
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
               // MyDefaults().isUserlogin = true
                MyDefaults().notificationStatus = userData["account_status"]?.string
                MyDefaults().userNotificationStatus = userData["notification_status"]?.string
                print(MyDefaults().notificationStatus!)
                
            }
            
            DispatchQueue.main.async { [weak self] in
                if !(self?.isGuestUserLogin ?? false) {
                    if MyDefaults().isClickOnHome == true {
                     let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
                        if let aVc = vc {
                            self?.navigationController?.pushViewController(aVc, animated: true)
                        }
                    
                    } else {
                        let vc = Util.loadViewController(fromStoryboard: "IntroductionVC", storyboardName: "Main") as? IntroductionVC
                        if let aVc = vc {
                            // self?.present(aVc, animated: true)
                            self?.navigationController?.pushViewController(aVc, animated: true)
                        }
                    }
                    
                
                } else{
                    if self?.delagate != nil {
                        self?.delagate.getDelegateGuestUserLogin(index: self?.index ?? 0, isPlaceBid: self?.isPlaceBid ?? false)
                    }
                }
                
            }
        }
    }
    @IBAction func actionOnSignUp(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "SignUpVC", storyboardName: "Main") as? SignUpVC
        //vc?.productDetailId = dictProduct["id"] as! String
     if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            self.show(aVc, sender: nil)
    }
    }
    @IBAction func actionOnForgotPassword(_ sender: UIButton) {
    
        let vc = Util.loadViewController(fromStoryboard: "ForgotPasswordPriseVC", storyboardName: "Main") as? ForgotPasswordPriseVC
        //vc?.productDetailId = dictProduct["id"] as! String
     if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            self.show(aVc, sender: nil)
    }
    }

}
