//
//  SettingVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import MessageUI

class SettingVC: UIViewController, MFMailComposeViewControllerDelegate,UITabBarControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tblSetting: UITableView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewChangeLanguage: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblSettings: UILabel!

    // MARK: - Property initialization
   // private var arrTitle = ["Discount Notification", "Notification", "Privacy", "Change Password", "Change Language", "Terms of use", "Report a problem...", "Online / Offline", "Logout"]
    
    private var arrTitle = [["title":"Discount Notification","image":"setting_icon1"],
                            ["title":"Notification","image":"setting_icon1"],
                            ["title":"Notification_Updates","image":"setting_icon1"],
                            ["title":"Privacy","image":"setting_icon2"],
                            ["title":"Change Password","image":"setting_icon3"],
                            ["title":"Change Language","image":"setting_icon5"],
                            ["title":"Terms of use","image":"setting_icon5"],
                            ["title":"Report a problem...","image":"setting_icon6"],
                            ["title":"Offline / Online","image":"setting_icon7"],
                            ["title":"Logout","image":"setting_icon8"]]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.hexStringToUIColor(hex: "#02BBCA"), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:tabBar.frame.height), lineHeight: 2.0)
        self.txtSearch.text = ""
        self.txtSearch.addTarget(self, action: #selector(setDiscount), for: .editingChanged)
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    @objc func setDiscount(textField: UITextField) {
        self.tabBarController?.selectedIndex = 0
    }
    func changeLanguage(strLanguage:String) {
       self.txtSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.lblSettings.text = "SETTINGS".LocalizableString(localization: "en")
        } else{
            self.lblSettings.text = "SETTINGS".LocalizableString(localization: "da")
        }
    }
    // MARK: - Action Methods
    @IBAction func btnChangeLanguage_Action(_ sender: UIButton) {
        
//        let selectedLanguage: Languages = sender.tag == 100 ? .en : .fa
//        
//        let languageCode = sender.tag == 100 ? "en" : "fa"
//         
//        LanguageManger.shared.currentLanguage = selectedLanguage
//        LanguageManger.shared.defaultLanguage = selectedLanguage
//        LanguageManger.shared.setLanguage(language: selectedLanguage)
//        
//        UserLanguage.shared.languageCode = languageCode == "en" ? "en" : "pe"
//        
//        UserDefaults.standard.set(languageCode, forKey: "language_code")
//
//        let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
//        if let aVc = vc {
//            present(aVc, animated: true)
//        }
    }
    
    @IBAction func btnCross_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewChangeLanguage.isHidden = true
    }

    // MARK: - API Methods
    private func logoutAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId : LoggedInUser.shared.id as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.logout(postParams), callerObj: self, showHud: false, text: loading) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
        }
    }

    private func accountStatusAPI_Call(_ accountStatus: Bool) {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId        : LoggedInUser.shared.id as AnyObject,
                kAPI_AccountStatus : accountStatus as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.accountStatus(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        self.popUpFilter(isAnimated: true)
    }
    func popUpFilter(isAnimated:Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SettingVC: UITableViewDataSource, UITableViewDelegate,getSelectMapCoordinate,delegateChangeLanguage {
    func getChangeLanguage(language:String,index:Int) {
        self.tabBarController?.tabBar.isHidden = false
//        let selectedLanguage: Languages = index == 100 ? .en : .fa
//        LanguageManger.shared.currentLanguage = selectedLanguage
//        LanguageManger.shared.defaultLanguage = selectedLanguage
//        LanguageManger.shared.setLanguage(language: selectedLanguage)
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.lblSettings.text = "SETTINGS".LocalizableString(localization: "en")
            self.txtSearch.placeholder = "Search".LocalizableString(localization: "en")
        } else{
            self.lblSettings.text = "SETTINGS".LocalizableString(localization: "da")
            self.txtSearch.placeholder = "Search".LocalizableString(localization: "da")
        }
        
        MyDefaults().language = language
        self.tabBarController?.delegate = self
        UserLanguage.shared.languageCode = language
        UserDefaults.standard.set(language, forKey: "language_code")
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        print(language)
        print(UserLanguage.shared.languageCode!)
        self.tblSetting.reloadData()
    
    }
    func delegatSelectCodinateofMap(latitude: String, longitude: String, distance: String, isMapSelected: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell
        cell?.selectionStyle = .none
        let dict = arrTitle[indexPath.row]
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            cell?.lblTitle.text = dict["title"]?.LocalizableString(localization: "en")
        } else{
            cell?.lblTitle.text = dict["title"]?.LocalizableString(localization: "da")
        }
            cell?.imgviewSetting.image = UIImage.init(named: dict["image"] ?? "")
        
            if indexPath.row == 5 {
                   cell?.imgviewLanguage.isHidden = false
                if (MyDefaults().language ?? "") as String ==  "en"{
                    cell?.imgviewLanguage.image = #imageLiteral(resourceName: "englishflag.png")
                } else{
                    cell?.imgviewLanguage.image = #imageLiteral(resourceName: "danishflag.png")
                }
                
               }
               else {
                   cell?.imgviewLanguage.isHidden = true
               }
            if indexPath.row == 8  || indexPath.row == 2 {
            
                if indexPath.row == 8  {
                    if MyDefaults().notificationStatus ?? "" == "1" {
                        cell?.switchStatus.isOn = true
                    } else{
                        cell?.switchStatus.isOn = false
                    }
                } else if indexPath.row == 2 {
                    
                    if MyDefaults().userNotificationStatus ?? "" == "1" {
                        cell?.switchStatus.isOn = true
                    } else{
                        cell?.switchStatus.isOn = false
                    }
                
                
                }
               
                cell?.switchStatus.tag = indexPath.row
                cell?.switchStatus.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            }
                else {
                    cell?.switchStatus.isHidden = true
                }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if LoggedInUser.shared.UserRole == "1" {
            let vc = Util.loadViewController(fromStoryboard: "DiscountNotifiationVC", storyboardName: "Home") as? DiscountNotifiationVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
        show(aVc, sender: nil)
                       }
        } else {
            let vc = Util.loadViewController(fromStoryboard: "ProfessionalDiscountNotificationVC", storyboardName: "Home") as? ProfessionalDiscountNotificationVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
            show(aVc, sender: nil)
                           }
        
    }
        }
        if indexPath.row == 1 {
            let vc = Util.loadViewController(fromStoryboard: "NotificationVC", storyboardName: "Home") as? NotificationVC
                if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 2 {
//            let vc = Util.loadViewController(fromStoryboard: "TermsPrivacyVC", storyboardName: "Home") as? TermsPrivacyVC
//            if let aVc = vc {
//                aVc.hidesBottomBarWhenPushed = true
//                show(aVc, sender: nil)
//            }
        }
        else if indexPath.row == 3 {
            let vc = Util.loadViewController(fromStoryboard: "TermsPrivacyVC", storyboardName: "Home") as? TermsPrivacyVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 4 {
            let vc = Util.loadViewController(fromStoryboard: "ChangePasswordVC", storyboardName: "Home") as? ChangePasswordVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 5 {
            //viewBG.isHidden = false
            //viewChangeLanguage.isHidden = false
            
            self.popUpChangeLanguage(isAnimated: true)
        }
        else if indexPath.row == 6 {
            let vc = Util.loadViewController(fromStoryboard: "TermsOfUseVC", storyboardName: "Home") as? TermsOfUseVC
            vc?.isPrivacy = false
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 7 {
           
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguageAlertMessage(strLanguage: "en", Index: indexPath.row)
            } else{
                self.changeLanguageAlertMessage(strLanguage: "da", Index: indexPath.row)
            }
        }  else if indexPath.row == 8 {
            print("onn/off")
            
        }
        else if indexPath.row == 9 {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguageLogOut(strLanguage: "en", Index: indexPath.row)
            } else{
                self.changeLanguageLogOut(strLanguage: "da", Index: indexPath.row)
            }
        }
    }
    func popUpChangeLanguage(isAnimated:Bool) {
         let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : ChangeLanguageVCPopUp = pop.instantiateViewController(withIdentifier: "ChangeLanguageVCPopUp") as! ChangeLanguageVCPopUp
        // popup.data = response
         // popup.isCategory = true
         popup.delagate = self
        self.tabBarController?.tabBar.isHidden = true
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
    @objc func switchChanged(sender: UISwitch) {
        
//        if sender.isOn == false {
//            print("False")
//
//        } else if sender.isOn == true {
//            print("true")
//
//        }
        
        print(sender.tag)
        
   print(sender.isOn)
        
        if sender.tag == 8 {
            if sender.isOn {
                self.callServicegetNotificationStatus(state: "1")
                } else {
                    self.callServicegetNotificationStatus(state: "0")
                }
        } else {
            if sender.isOn {
                self.callServiceNotificationDisabled(state: "1")
                } else {
                    self.callServiceNotificationDisabled(state: "2")
                }
        }
    }
    func callServicegetNotificationStatus(state:String) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["language": MyDefaults().language ?? "",
                                        "user_id":LoggedInUser.shared.id ?? "",
                                        "account_status":state]
           print(parameter)
        
        HTTPService.callForPostApi(url:NotificationStatusAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                          
                            print(state)
                            MyDefaults().notificationStatus = state
                            self.tblSetting.reloadData()
                           } else if status == 500 {
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                }
       }
    func callServiceNotificationDisabled(state:String) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["language": MyDefaults().language ?? "",
                                        "user_id":LoggedInUser.shared.id ?? "",
                                        "notification_status":state]
           print(parameter)
        
        HTTPService.callForPostApi(url:userNotificationStatusAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                          
                            print(state)
                            if state == "1" {
                                MyDefaults().userNotificationStatus = "1"
                            } else{
                                MyDefaults().userNotificationStatus = "2"
                            }
                            self.tblSetting.reloadData()
                           } else if status == 500 {
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                }
       }
    
    func changeLanguageAlertMessage(strLanguage:String,Index:Int) {
       self.txtSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
        
        let uiAlert = UIAlertController(title: "Report_a_problem_to_admin".LocalizableString(localization: strLanguage), message: "Please_send_email_to_the_admin_from_below_button_to_report_your_problem".LocalizableString(localization: strLanguage), preferredStyle:UIAlertController.Style.alert)
        present(uiAlert, animated: true, completion: nil)
        uiAlert.addAction(UIAlertAction(title: "Report_Cancel".LocalizableString(localization: strLanguage), style: .default, handler: { action in }))
        uiAlert.addAction(UIAlertAction(title: "Report_SendEmail".LocalizableString(localization: strLanguage), style: .default, handler: { [weak self] action in
            
            if !MFMailComposeViewController.canSendMail() {
                Util.showAlertWithMessage("Mail services are not available", title: "")
                return
            }
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@pris24.com"])
            composeVC.setSubject("Message Subject")
            composeVC.setMessageBody("Message content.", isHTML: false)
            
            // Present the view controller modally.
            self?.present(composeVC, animated: true, completion: nil)
        }))
        
    }
    func changeLanguageLogOut(strLanguage:String,Index:Int) {
            let uiAlert = UIAlertController(title: "", message: "are_you_sure_you_want_to_log_out".LocalizableString(localization: strLanguage), preferredStyle:UIAlertController.Style.alert)
            present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Report_Cancel".LocalizableString(localization: strLanguage), style: .default, handler: { action in }))
            
            uiAlert.addAction(UIAlertAction(title: "Report_Yes".LocalizableString(localization: strLanguage), style: .default, handler: { [weak self] action in
                
                LoggedInUser.shared.clearUserData()
                UserDefaults.standard.set(nil, forKey: kAPI_Id)
              //  UserDefaults.standard.set(nil, forKey: kAPI_Id)
                LoggedInUser.shared.id = nil
                // Perform Logout API
                self?.logoutAPI_Call()
                
                let vc = Util.loadViewController(fromStoryboard: "LoginVC", storyboardName: "Main") as? LoginVC
                if let aVc = vc {
                    aVc.hidesBottomBarWhenPushed = true
                    self?.show(aVc, sender: nil)
                }
            }))
        }
}
