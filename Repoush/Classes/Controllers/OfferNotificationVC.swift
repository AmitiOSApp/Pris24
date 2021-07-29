//
//  OfferNotificationVC.swift
//  Repoush
//
//  Created by Apple on 24/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
import WebKit


class OfferNotificationVC: UIViewController,WKNavigationDelegate,WKUIDelegate  {
    @IBOutlet weak var webView : WKWebView!
    @IBOutlet weak var lblTitleNav : UILabel!
    
    
    var webUrl = ""
    var offerNotification = ""
    var userInfoDiscountNotification = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(userInfoDiscountNotification)
        
        let firstName = LoggedInUser.shared.firstName as AnyObject
        let lastName = LoggedInUser.shared.lastName as AnyObject
        let fullName = "\(firstName) \(lastName)"
        
            let seller_name = userInfoDiscountNotification["seller_name"] as! String
            let discount_percantage = userInfoDiscountNotification["discount_percantage"] as! String
            let item_name = userInfoDiscountNotification["discount_percantage"] as! String
            let store_address = userInfoDiscountNotification["store_address"] as! String
            let valid_until = userInfoDiscountNotification["valid_until"] as! String
            let start_time = userInfoDiscountNotification["start_time"] as! String
            let end_time = userInfoDiscountNotification["end_time"] as! String
            
            
        let stringUrl =         "\(getsentTNotificationTemplate)&buyer_name=\(fullName)&seller_name=\(seller_name)&discount_percantage=\(discount_percantage)&item_name=\(item_name)&store_address=\(store_address)&valid_until=\(valid_until)&start_time=\(start_time)&end_time=\(end_time)"
        let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        if  isConnectedToInternet() {
            
            // self.title = "Privacy Policy"
                let request = URLRequest(url: URL(string: escapedString!)!)
              print(request)
             webView.uiDelegate = self
             webView.navigationDelegate = self
             webView?.load(request)
               
             } else {
             self.showErrorPopup(message: internetConnetionError, title: alert)
             }
        
        
        
        
        if (MyDefaults().language ?? "") as String ==  "en" {
            self.changeLanguage(strLanguage: "en")
        } else {
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
           
            self.lblTitleNav.text = "Discount_Notifications".LocalizableString(localization: strLanguage)
        
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func actionOnBack(_ sender:Any){
       // self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func actionOnEdit(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionSendNotification(_ sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
