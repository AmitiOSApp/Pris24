//
//  PriviewPageVC.swift
//  Repoush
//
//  Created by Apple on 11/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import WebKit


class PriviewPageVC: UIViewController,WKNavigationDelegate {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var webView:WKWebView?
    var webUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()

            let url = URL (string: webUrl)
               let requestObj = URLRequest(url: url!)
        webView?.load(requestObj)
    }
    @IBAction func actionOnback(_ sender: Any){
     self.navigationController?.popViewController(animated: true)
 }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
       
        self.lblTitle.text = "Preview".LocalizableString(localization: strLanguage)
    }
}
