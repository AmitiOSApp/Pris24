//
//  ChangeLanguageVCPopUp.swift
//  Repoush
//
//  Created by Apple on 13/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol delegateChangeLanguage {
    func getChangeLanguage(language:String,index:Int)
}
class ChangeLanguageVCPopUp: UIViewController {
    var delagate: delegateChangeLanguage!
    //var languageDefault = ""
    @IBOutlet weak var lblEnglish : UILabel!
    @IBOutlet weak var lblDanish : UILabel!
   // @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblChangePassword:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if (MyDefaults().language ?? "") as String ==  "en"{
                    self.changeLanguage(strLanguage: "en")
                } else{
                    self.changeLanguage(strLanguage: "da")
                }

        if MyDefaults().language ?? "" ==  "en"{
            self.lblEnglish.textColor = UIColor.hexStringToUIColor(hex: "#F65125")
            self.lblDanish.textColor = UIColor.hexStringToUIColor(hex: "#357C91")
        } else{
            self.lblEnglish.textColor = UIColor.hexStringToUIColor(hex: "#357C91")
            self.lblDanish.textColor = UIColor.hexStringToUIColor(hex: "#F65125")
        }
    }
    func changeLanguage(strLanguage:String) {
           self.lblChangePassword.text = "Change Language".LocalizableString(localization: strLanguage)
        }
    @IBAction func actionOnEnglish(_ Sender : Any){
        self.lblEnglish.textColor = UIColor.hexStringToUIColor(hex: "#F65125")
        self.lblDanish.textColor = UIColor.hexStringToUIColor(hex: "#357C91")
        if self.delagate != nil {
            self.delagate.getChangeLanguage(language: "en", index: 100)
        }
        
    }
    @IBAction func actionOnDanish(_ Sender : Any){
        self.lblEnglish.textColor = UIColor.hexStringToUIColor(hex: "#357C91")
        self.lblDanish.textColor = UIColor.hexStringToUIColor(hex: "#F65125")
        if self.delagate != nil {
            self.delagate.getChangeLanguage(language: "da", index: 100)
        }
    }
    @IBAction func actionOnCross(_ Sender : Any){
        //self.dismiss(animated: true, completion: nil)
        if self.delagate != nil {
           if MyDefaults().language ?? "" ==  "en"{
            self.delagate.getChangeLanguage(language: "en", index: 0)
            } else{
                self.delagate.getChangeLanguage(language: "da", index: 0)
            }
        }
    }
}
