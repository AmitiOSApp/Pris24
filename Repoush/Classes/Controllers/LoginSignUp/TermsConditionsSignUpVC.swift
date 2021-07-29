//
//  TermsConditionsSignUpVC.swift
//  Repoush
//
//  Created by Apple on 21/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
import WebKit

class TermsConditionsSignUpVC: UIViewController,WKNavigationDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - Property initialization
   // private let webView = WKWebView(frame: .zero)
    @IBOutlet weak var webView: WKWebView!
    var isPrivacy = true
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            webView.navigationDelegate = self
        if LoggedInUser.shared.UserRole == "1" {
            if (MyDefaults().language ?? "") as String ==  "en"{
                let request = URLRequest(url: URL(string: getTermsConditionsEnglishAPI)!)
                self.changeLanguage(strLanguage: "en")
                webView.load(request)
            } else {
                let request = URLRequest(url: URL(string: getTermsConditionsDanishAPI)!)
                self.changeLanguage(strLanguage: "da")
                webView.load(request)
            }
            
        } else{
           
            if (MyDefaults().language ?? "") as String ==  "en"{
                let request = URLRequest(url: URL(string: getTermsConditionsProfessionalEnglishAPI)!)
                self.changeLanguage(strLanguage: "en")
                webView.load(request)
            } else {
                let request = URLRequest(url: URL(string: getTermsConditionsProfessionalDanishAPI)!)
                self.changeLanguage(strLanguage: "da")
                webView.load(request)
            }
            
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    func changeLanguage(strLanguage:String) {
       
        self.lblTitle.text = "Terms & Condition".LocalizableString(localization: strLanguage)
    }
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
       // navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
