//
//  BuyerReviewPopUpVC.swift
//  Repoush
//
//  Created by mac  on 28/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit

protocol getSelectBuyerPopUpDelegate {
    func delegatBuyerPopUp()
}
class BuyerReviewPopUpVC: UIViewController {
@IBOutlet var floatRatingView: FloatRatingView!
   @IBOutlet var lblReviews: UILabel!
    @IBOutlet var imgProfile: UIImageView!
     @IBOutlet var lblMobileNumber: UILabel!
     @IBOutlet var lblLocality: UILabel!
    @IBOutlet var lblRatings: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var viewEmailAddress: UIView!
    @IBOutlet var viewEmailAddressConstant: NSLayoutConstraint!
  
    @IBOutlet var lblMobilNumberLoc: UILabel!
    @IBOutlet var lblEmailAddressLoc: UILabel!
    @IBOutlet var lblLocationLoc: UILabel!
    
    var delagate: getSelectBuyerPopUpDelegate!
    var buyerData : ModelBuyerReviewResponseDatum!

    var rating = ""
    var userId = ""
    var OtherUserId = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        // Do any additional setup after loading the view.
        self.lblName.text = name
            if  isConnectedToInternet() {
            CallServiceBuyerReviewAPI()
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else {
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
           self.lblEmailAddressLoc.text = "Email_Address".LocalizableString(localization: strLanguage)
           self.lblMobilNumberLoc.text = "Mobile_Number".LocalizableString(localization: strLanguage)
           self.lblLocationLoc.text = "location_city".LocalizableString(localization: strLanguage)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func actionOnSubmit(_ Sender:Any){
//        if !checkSignUpValidationOnLRating() {
//            if  isConnectedToInternet() {
//                CallServiceFeedbackAPI()
//            } else {
//                self.showErrorPopup(message: internetConnetionError, title: alert)
//            }
//        }
    }
     @IBAction func actionOnReview(_ Sender:Any){
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : BuyerMultipleReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerMultipleReviewPopUpVC") as! BuyerMultipleReviewPopUpVC
         
        
        let ratingSet = self.buyerData.rating
        
        if ratingSet == nil {
            popup.rating = "0"
        } else{
            popup.rating = self.buyerData.rating
        }
        
        
         popup.ratingList = self.buyerData.ratingList
        if self.buyerData.firstName == "" && self.buyerData.firstName == "" {
            popup.name = self.buyerData.companyName
        }else{
            popup.name = self.buyerData.firstName + " " +  self.buyerData.lastName
        }
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    @IBAction func actionBack(_ Sender:Any){
        self.dismiss(animated: true, completion: nil)
       }
//    @IBAction func actionOnCancel(_ Sender:Any){
//        self.dismiss(animated: true, completion: nil)
//       }
    
        func CallServiceBuyerReviewAPI() {
            var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
            let parameter: [String: Any] = ["language":MyDefaults().language ?? AnyObject.self,
                                            "otheruser_id":OtherUserId,
                                            "user_id":userId]

            print(parameter)
            HTTPService.callForPostApi(url:getOtherUserDetailAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                               debugPrint(response)
                if response.count != nil {
                    let status = response["responseCode"] as! Int
                    let message = response["message"] as! String
                    if status == 200  {
                         let response = ModelBuyerReview.init(fromDictionary: response as! [String : Any])
                        self.buyerData = response.responseData
                        self.setUI()
                       // self.dismiss(animated: true, completion: nil)
                    }  else if status == 500 {
                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                    }
                }else{
                    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                }
            }
        }
    func setUI()  {
         let geocoder = CLGeocoder()
        if let review = self.buyerData.review {
           
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.lblReviews.text = String(review) + " " + "Reviews".LocalizableString(localization: "en")
            } else {
                self.lblReviews.text = String(review) + " " + "Reviews".LocalizableString(localization: "da")
            }
            
        }
       // self.lblRatings.text = self.buyerData.rating
        
       // let ratingSet = self.buyerData.rating
        
       // let doubleRating = (self.buyerData.rating).doubleValue
        
       
        
        let ratingSet = self.buyerData.rating
        print(ratingSet)
        
        let rate = Double(ratingSet!)
        
        self.lblRatings.text = String(format: "%.1f",rate!)
        
        print(self.lblRatings.text!)
        
       
        self.imgProfile.sd_setImage(with: URL(string:self.buyerData.userImg), placeholderImage:#imageLiteral(resourceName: "profileuser"))
        if self.buyerData.firstName == "" && self.buyerData.lastName == "" {
            self.lblName.text = self.buyerData.companyName
        }else{
            self.lblName.text = self.buyerData.firstName + " " + self.buyerData.lastName
        }
        if self.buyerData.showStatus == 1 {
            if self.buyerData.email.isEmpty {
                self.viewEmailAddressConstant.constant = 0
                self.viewEmailAddress.isHidden = true
            }else{
                let myStringArr = self.buyerData.email.components(separatedBy: "@")
                self.lblEmail.text = "***********@" + myStringArr[1]
                self.viewEmailAddressConstant.constant = 42
                self.viewEmailAddress.isHidden = false
            }
        }
        if let rating = self.buyerData.rating{
            
            floatRatingView.delegate = self
            floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
            floatRatingView.type = .halfRatings
            floatRatingView.rating = Double(rating) ?? 0.0
            floatRatingView.editable = false
        }
        self.lblMobileNumber.text = "*********" + self.buyerData.mobileNumber.dropLast(2)
        let location = CLLocation(latitude: (self.buyerData.latitude).toDouble() ?? 0.0, longitude: (self.buyerData.lognitude).toDouble() ?? 0.0)
                            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                                   if error == nil {
                                       if let firstLocation = placemarks?[0],
                                           let cityName = firstLocation.locality { // get the city name
                                         //  let distanceKm =   String(format: "%.2f",self?.personal[indexPath.row].distance!.toDouble()! as! CVarArg)
                                           self?.lblLocality.text =   "*****************************"
                                       }
                                   }
                               }
        
    }
   
    }

extension BuyerReviewPopUpVC: FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
//    self.rating = String(format: "%.2f", self.floatRatingView.rating)
   
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
        self.rating = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}
