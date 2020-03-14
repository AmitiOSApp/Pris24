//
//  TermsPrivacyVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import WebKit

class TermsPrivacyVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - Property initialization
    private let webView = WKWebView(frame: .zero)
    var isPrivacy = true
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        webView.frame  = CGRect(x: 0, y: Util.getHeaderHeight(self), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - Util.getHeaderHeight(self))
        view.addSubview(webView)
        var strUrl = "http://24x7webtesting.com/repoush/home/privacy_policy_en"
        if !isPrivacy {
            lblTitle.text = "Terms of use".localiz()
            strUrl = "http://24x7webtesting.com/repoush/home/terms_conditions_en"
        }
        let request = URLRequest(url: URL(string: strUrl)!)
        webView.load(request)
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
