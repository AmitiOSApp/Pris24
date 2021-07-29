//
//  EditReplyPopUpVC.swift
//  Repoush
//
//  Created by Apple on 15/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit

import Foundation
protocol delegateEditReplyToBuyer {
    func getEditReplyToBuyer(index:Int)
}

class EditReplyPopUpVC: UIViewController {
    @IBOutlet weak var lblReplyToBuyer : UILabel!
    @IBOutlet weak var txtView : UITextView!
    @IBOutlet weak var btnSubmit : UIButton!
    @IBOutlet weak var btnCancel : UIButton!
    var Index : Int = 0
    var delegate: delegateEditReplyToBuyer!
    var productId = ""
    var editText = ""
    var commnetId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
        self.txtView.text = editText
        print(editText)
        print(self.txtView.text)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func actionOnSubmit(_ sender:Any){
        if !isRequiredFieldValid() {
            if  isConnectedToInternet() {
                self.callServiceSendAskQuestion()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    func isRequiredFieldValid() -> Bool {
      guard let password = txtView.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please write comments.")
            return true}
        
        return false
    }
    @IBAction func actionOnCancel(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionOnCross(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
    func changeLanguage(strLanguage:String) {
        self.txtView.placeholder = "Reply_To".LocalizableString(localization: strLanguage)
        self.lblReplyToBuyer.text = "Reply_To_Buyer".LocalizableString(localization: strLanguage)
       // self.lblTitle.text = "Discount Notification".LocalizableString(localization: strLanguage)
        self.btnSubmit.setTitle("SUBMIT".LocalizableString(localization: strLanguage), for: .normal)
        self.btnCancel.setTitle("Report_Cancel".LocalizableString(localization: strLanguage), for: .normal)
        
    }
    func callServiceSendAskQuestion() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
       let parameter: [String: Any] = ["product_id":productId,
                                       "language":MyDefaults().language ?? AnyObject.self,
                                       "user_id":LoggedInUser.shared.id as AnyObject,
                                       "comment_id":commnetId,
                                       "message":self.txtView.text!]
   
           print(parameter)
        HTTPService.callForPostApi(url:AskQuedtionCommnetUpdate , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                              
//                            if response.responseData.count > 0{
//                                self.showBid = response.responseData
//                                self.tblView.isHidden = false
//                                self.tblView.reloadData()
//
//                            }else{
//                                self.tblView.isHidden = true
//                            }
                          
                            if self.delegate != nil {
                                self.delegate.getEditReplyToBuyer(index:self.Index)
                            }
                           
                           } else if status == 500 {
                                  
                                  //self.NORECORDFOUND.isHidden = false
                                self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
          
       }
}
