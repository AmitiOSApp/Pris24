//
//  TermsPrivacyVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import WebKit

class TermsPrivacyVC: UIViewController,WKNavigationDelegate {
    
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
        if !isPrivacy {
           // lblTitle.text = "Terms of use".localiz()
        
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
        
        } else{
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
        }
        
        
//        webView.frame  = CGRect(x: 0, y: Util.getHeaderHeight(self), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - Util.getHeaderHeight(self))
//        view.addSubview(webView)
        
        var strUrl = ""
       
        
        if (MyDefaults().language ?? "") as String  == "en" {
            strUrl = getPrivacyEnglishAPI
            if !isPrivacy {
                strUrl = getPrivacyDanishAPI
            }
        }
        else {
           strUrl = getProfessionalDanishAPI
            if !isPrivacy {
                strUrl = getProfessionalDanishAPI
            }
        }
        let request = URLRequest(url: URL(string: strUrl)!)
        webView.load(request)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        
    }
    func changeLanguage(strLanguage:String) {
       
        if isPrivacy {
            self.lblTitle.text = "Privacy".LocalizableString(localization: strLanguage)
        }else{
            self.lblTitle.text = "Terms of use".LocalizableString(localization: strLanguage)
        }
    }
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
