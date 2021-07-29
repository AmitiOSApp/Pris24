//
//  RateNowPopUpVC.swift
//  Repoush
//
//  Created by mac  on 28/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

protocol getSelectRateNowDelegate {
    func delegatRateNot()
    func delegatCancelRateView()
}
class RateNowPopUpVC: UIViewController {
@IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var txtMessage: UITextView!
    @IBOutlet var lblRatings: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTitleNav: UILabel!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var imgUser: UIImageView!
    var delagate: getSelectRateNowDelegate!
    var rating = ""
    var productId = ""
    var sellerId = ""
    var name = ""
    var strUserImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        // Do any additional setup after loading the view.
        self.lblName.text = name
        self.imgUser.sd_setImage(with: URL(string:self.strUserImg), placeholderImage:#imageLiteral(resourceName: "gallery"))
        if (MyDefaults().language ?? "") as String ==  "en" {
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
    
            //self.lblNotRegistered.text = "NotregisterdYet".LocalizableString(localization: strLanguage)
        self.txtMessage.placeholder = "Reply_To".LocalizableString(localization: strLanguage)
        self.btnSubmit.setTitle("SUBMIT".LocalizableString(localization: strLanguage), for: .normal)
            self.btnCancel.setTitle("Report_Cancel".LocalizableString(localization: strLanguage), for: .normal)
            self.lblTitleNav.text = "Rate_Now".LocalizableString(localization: strLanguage)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func actionOnSubmit(_ Sender:Any){
        if !checkSignUpValidationOnLRating() {
            if  isConnectedToInternet() {
                CallServiceFeedbackAPI()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @IBAction func actionOnCross(_ Sender:Any){
           
        if self.delagate != nil {
            self.delagate.delegatCancelRateView()
        }
       }
    @IBAction func actionOnCancel(_ Sender:Any){
        if self.delagate != nil {
            self.delagate.delegatCancelRateView()
        }
       }
    func checkSignUpValidationOnLRating() -> Bool {
           
            guard  self.rating.count > 0 , self.rating != "" else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: "Pris24", message: "Please_enter_reviews".LocalizableString(localization: "en"))
                } else{
                    showAlert(title: "Pris24", message: "Please_enter_reviews".LocalizableString(localization: "da"))
                }
                
            return true}
            guard let reviews = txtMessage.text , reviews != "" else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    showAlert(title: "Pris24", message: "Please_write_reviews".LocalizableString(localization: "en"))
                } else{
                    showAlert(title: "Pris24", message: "PPlease_write_reviews".LocalizableString(localization: "da"))
                }
                
                       return true}
            
            return false
        }
        func CallServiceFeedbackAPI() {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
            let parameter: [String: Any] = ["language":MyDefaults().language ?? AnyObject.self,
                                            "product_id":productId,
                                            "user_id":LoggedInUser.shared.id!,
                                            "rating_for":sellerId,
                                            "rating":self.lblRatings.text!,
                                            "feedback_message":self.txtMessage.text!]
           
            print(parameter)
            HTTPService.callForPostApi(url:getFeedbackAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                               debugPrint(response)
                HideHud()
                if response.count != nil {
                    let status = response["responseCode"] as! Int
                    let message = response["message"] as! String
                    if status == 200  {
                       //  let response = ModelBrowser.init(fromDictionary: response as! [String : Any])
                        
                        if self.delagate != nil {
                            self.delagate.delegatRateNot()
                        }
                        self.dismiss(animated: true, completion: nil)
                    }  else if status == 500 {
                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    }
                    
                }else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            }
        }
    }

extension RateNowPopUpVC: FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
    self.rating = String(format: "%.2f", self.floatRatingView.rating)
   }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
        self.rating = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}
