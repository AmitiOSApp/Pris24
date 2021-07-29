//
//  DiscountNotificationWebpagePopUp.swift
//  Repoush
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import WebKit

protocol delegateOpenWebViewFromSendNotification {
    func GetdelegateOpenWebView()
}
class DiscountNotificationWebpagePopUp: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var lblTitleNav : UILabel!
    @IBOutlet weak var btnCancel : UIButton!
    @IBOutlet weak var btnShowNotification : UIButton!
    var delagate: delegateOpenWebViewFromSendNotification!
    var webUrl = ""
    var offerNotification = ""
    var userInfoDiscountNotification = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userInfoDiscountNotification)
        
        if offerNotification == "Offer Notification" {
            self.btnCancel.isHidden = true
            self.btnShowNotification.isHidden = true
        let firstName = LoggedInUser.shared.firstName as AnyObject
        let lastName = LoggedInUser.shared.lastName as AnyObject
        let fullName = "\(firstName) \(lastName)"
        
        
//        let stringUrl =         "\(getsentTNotificationTemplate)&buyer_name=\(fullName)&seller_name=\(seller_name)&discount_percantage=\(self.txtDiscountPercentage.text!)&item_name=\(self.txtItemName.text!)&store_address=\(self.txtStoreAddress.text!)&valid_until=\(self.txtvalidUnit.text!)&start_time=\(self.txtStartTime.text!)&end_time=\(self.txtEndTime.text!)"
//        let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//        
        
        }else{
            if  isConnectedToInternet() {
            
             self.title = "Privacy Policy"
             let request = URLRequest(url: URL(string: webUrl)!)
              print(request)
             webView.uiDelegate = self
             webView.navigationDelegate = self
             webView?.load(request)
                self.btnCancel.isHidden = false
                self.btnShowNotification.isHidden = false
             } else {
             self.showErrorPopup(message: internetConnetionError, title: alert)
             }
        }
        
        
        
        if (MyDefaults().language ?? "") as String ==  "en" {
            self.changeLanguage(strLanguage: "en")
        } else {
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
           
            self.lblTitleNav.text = "Discount_Notifications".LocalizableString(localization: strLanguage)
            self.btnCancel.setTitle("Edit".LocalizableString(localization: strLanguage), for: .normal)
            self.btnShowNotification.setTitle("Send_Notification".LocalizableString(localization: strLanguage), for: .normal)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func actionOnBack(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func actionOnEdit(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionSendNotification(_ sender:Any){
        if self.delagate != nil {
            self.delagate.GetdelegateOpenWebView()
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
