//
//  SettingVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import MessageUI

class SettingVC: UIViewController, MFMailComposeViewControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tblSetting: UITableView!
    
    // MARK: - Property initialization
    private var arrTitle = ["Notification", "Privacy", "Change Password", "Change Language", "Terms of use", "Report a problem", "Online / Offline", "Logout"]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - API Methods
    private func logoutAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId : LoggedInUser.shared.id as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.logout(postParams), callerObj: self, showHud: false) { (response) -> () in
            
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
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId        : LoggedInUser.shared.id as AnyObject,
                kAPI_AccountStatus : accountStatus as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.accountStatus(postParams), callerObj: self, showHud: true) { (response) -> () in
            
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

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension SettingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell
        cell?.selectionStyle = .none
        
        cell?.lblTitle.text = arrTitle[indexPath.row]
        
        cell?.imgviewSetting.image = UIImage(named: "setting_icon\(indexPath.row + 1)")
        
        if indexPath.row == 6 {
            cell?.switchStatus.isHidden = false
            cell?.switchStatus.isOn = LoggedInUser.shared.accountStatus == "1" ? true : false
        }
        else {
            cell?.switchStatus.isHidden = true
        }
        
        cell?.statusHandler = {
            // Perform Account status API
            self.accountStatusAPI_Call((cell?.switchStatus.isOn)!)
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = Util.loadViewController(fromStoryboard: "NotificationVC", storyboardName: "Home") as? NotificationVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 1 {
            let vc = Util.loadViewController(fromStoryboard: "TermsPrivacyVC", storyboardName: "Home") as? TermsPrivacyVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 2 {
            let vc = Util.loadViewController(fromStoryboard: "ChangePasswordVC", storyboardName: "Home") as? ChangePasswordVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 4 {
            let vc = Util.loadViewController(fromStoryboard: "TermsPrivacyVC", storyboardName: "Home") as? TermsPrivacyVC
            vc?.isPrivacy = false
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
                show(aVc, sender: nil)
            }
        }
        else if indexPath.row == 5 {
            let uiAlert = UIAlertController(title: "Report a problem to admin", message: "Please send email to the admin from below button to report your problem.", preferredStyle:UIAlertController.Style.alert)
            present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
            
            uiAlert.addAction(UIAlertAction(title: "Send email", style: .default, handler: { [weak self] action in
                
                if !MFMailComposeViewController.canSendMail() {
                    Util.showAlertWithMessage("Mail services are not available", title: "")
                    return
                }
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.setToRecipients(["repoush@email.com"])
                composeVC.setSubject("Message Subject")
                composeVC.setMessageBody("Message content.", isHTML: false)
                
                // Present the view controller modally.
                self?.present(composeVC, animated: true, completion: nil)
            }))
        }
        else if indexPath.row == 7 {
            let uiAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle:UIAlertController.Style.alert)
            present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Stay In", style: .default, handler: { action in }))
            
            uiAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { [weak self] action in
                
                LoggedInUser.shared.clearUserData()
                
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
    
}
