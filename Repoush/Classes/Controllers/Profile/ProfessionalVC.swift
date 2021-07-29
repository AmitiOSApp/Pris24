//
//  ProfessionalVC.swift
//  Repoush
//
//  Created by Apple on 08/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//
//
//  ProfessionalVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/8/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ACFloatingTextfield_Swift
class ProfessionalVC: UIViewController {
    
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var txtCompanyName: ACFloatingTextfield!
    @IBOutlet weak var txtCVRNumber: ACFloatingTextfield!
    @IBOutlet weak var txtCity: ACFloatingTextfield!
    @IBOutlet weak var txtZipCode: ACFloatingTextfield!
  //  @IBOutlet weak var txtGender: ACFloatingTextfield!
    @IBOutlet weak var txtDOB: ACFloatingTextfield!
    @IBOutlet weak var txtMobileNumber: ACFloatingTextfield!
    @IBOutlet weak var txtEmail: ACFloatingTextfield!
    @IBOutlet weak var txtLocation: ACFloatingTextfield!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblMyProfile: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var btnChangeEmail: UIButton!
    @IBOutlet weak var btnUdate: UIButton!
    var imageArray = [[String:Any]]()
    var profile : ModelResponseProfessionalDatum!
    
  
    
    var genderId = "1"
    private var latitude = "0.000000"
    private var longitude = "0.000000"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.txtDOB.delegate = self
        self.datePicker.maximumDate = Date()
        self.txtMobileNumber.delegate = self
        self.openDataPicker()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("ProfileContainernotification"), object: nil)
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
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.imageArray = [[String:Any]]()
        var dict = [String:Any]()
        dict ["uploadfile"] = "user_img"
        dict ["type"] = "image"
        dict ["png"] = self.imgviewUser.image
        dict["isselected"] = "yes"
        self.imageArray.append(dict)
    }
    func openDataPicker() {
           
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
           // datePicker.set18YearValidation()
            datePicker.datePickerMode = .date
            self.txtDOB.inputView = datePicker
            
            datePicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
          } else{
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
                datePicker.datePickerMode = .date
                self.txtDOB.inputView = datePicker
                datePicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
            } else {
                // Fallback on earlier versions
            }
           
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
       // datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
       
        if  isConnectedToInternet() {
            // self.callServicegetUserProfile()
            if LoggedInUser.shared.id != nil {
                self.callServicegetUserProfile()
            } else{
                
            }
            
         } else {
         self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    @objc func updateDateField(sender: UIDatePicker) {
        self.txtDOB?.text = formatDateForDisplay(date: sender.date)
    }

    // Formats the date chosen with the date picker.
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
      // Take Action on Notification
        self.dismiss(animated: true, completion: nil)
    }
    func callServicegetUserProfile() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                        "user_id":LoggedInUser.shared.id as AnyObject]
           print(parameter)
        print(getUserProfileAPI)
        HTTPService.callForPostApi(url:getUserProfileAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                            let response = ModelProfessionalUser.init(fromDictionary: response as! [String : Any])
                            self.profile = response.responseData
                            self.setUI()
                           } else if status == 500 {
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                           }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                }
       }
    func setUI() {
        
       // self.txtFirstName.text = self.profile.firstName.capitalizingFirstLetter()
       // self.txtLastName.text = self.profile.lastName.capitalizingFirstLetter()
       // self.lblRating.text = String(format: "%.2f",self.profile.rating!.toDouble()! as CVarArg)
       
//        let ratingSet = Double(self.profile.rating)
//        if ratingSet == 0 {
//            self.lblRating.text = "0.0"
//        }else{
//            self.lblRating.text = String(format: "%.2f",ratingSet)
//        }
        
        
        
        let ratingSet = self.profile.rating
        
        print(ratingSet)
        
        let rate = Double(ratingSet!)
        self.lblRating.text = String(format: "%.1f",rate!)
        if let reviews = self.profile.review {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.lblReview.text = String(reviews) + " Reviews"
            } else{
                self.lblReview.text = String(reviews) + " Bedømmelser"
            }
        }
        self.txtLocation.text = self.profile.address.capitalizingFirstLetter()
        self.latitude = self.profile.latitude
        self.longitude = self.profile.lognitude
        self.txtEmail.text = self.profile.email
        self.txtCompanyName.text = self.profile.companyName
        self.txtZipCode.text = self.profile.zipCode
        self.txtCVRNumber.text = self.profile.cvrNumber
        self.txtCity.text = self.profile.city
      //  self.txtMobileNumber.text = self.profile.mobileNumber
        
        if self.profile.mobileNumber.isEmpty {
            self.txtMobileNumber.text = "EX.12345678"
            self.txtMobileNumber.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
        } else{
            self.txtMobileNumber.text = self.profile.mobileNumber
            self.txtMobileNumber.textColor = UIColor.black
        }
        self.imgviewUser.sd_setImage(with: URL(string:self.profile.userImg), placeholderImage:#imageLiteral(resourceName: "profileuser"))
        
        if self.profile.dob!.isEmpty {
            
        }else{
            print(self.profile.dob!)
             self.txtDOB.text = self.convertForServertolocal(self.profile.dob)
        }
        
       
        self.imageArray = [[String:Any]]()
        var dict = [String:Any]()
        dict ["uploadfile"] = "user_img"
        dict ["type"] = "image"
        dict ["png"] = self.imgviewUser.image
        dict["isselected"] = "yes"
        self.imageArray.append(dict)
        
    }
//    func callServicegeUpdatetUserProfile() {
//        var loading = ""
//        if (MyDefaults().language ?? "") as String ==  "en"{
//            loading = "Loading".LocalizableString(localization: "en")
//        } else{
//          loading = "Loading".LocalizableString(localization: "da")
//        }
//        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
//                                        "user_id":LoggedInUser.shared.id as AnyObject]
//           print(parameter)
//        print(getUserProfileAPI)
//        HTTPService.callForPostApi(url:getUpdateUserProfileAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
//                       debugPrint(response)
//                     //  HideHud()
//                       if response.count != nil {
//                           let status = response["responseCode"] as! Int
//                           let message = response["message"] as! String
//                           if status == 200  {
//                            let response = ModelProfessionalUser.init(fromDictionary: response as! [String : Any])
//                            self.profile = response.responseData
//                            self.setUI()
//                           } else if status == 500 {
//
//                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
//                           }
//                           }else{
//                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
//                       }
//                }
//       }
    
    func callServiceUpdateUserProfileAPI() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        var strdateOfBirth = ""
        if self.txtDOB.text?.isEmpty == true {
            strdateOfBirth = ""
        } else{
            strdateOfBirth = self.convertForServerDate(self.txtDOB.text ?? "")
        }
        
        let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                         "user_id": LoggedInUser.shared.id as AnyObject,
                                         "first_name":"",
                                         "lastName":"",
                                         "address":self.txtLocation.text!,
                                         "latitude":self.latitude,
                                         "lognitude":self.longitude,
                                         "email":self.txtEmail.text!,
                                         "mobile_number":self.txtMobileNumber.text!,
                                         "device_type":kDevicePlatform,
                                         "gender":self.genderId,
                                         "dob":strdateOfBirth,
                                         "company_name":self.txtCompanyName.text!,
                                         "city":self.txtCity.text!,
                                         "zip_code":self.txtZipCode.text!,
                                         "industry_code":"",
                                                                         
                                        ]
             print(parameter)
             
        HTTPService.uploadimage(url: getUpdateUserProfileAPI, imageToUpload: imageArray, authtoken: "", showHud: true, text: loading, VC: self, parameters: parameter) { (response) in
                    
                if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            self.showErrorPopup(message: message, title: ALERTMESSAGE)
                            appDelegate.mobileNumber = self.txtMobileNumber.text!
                            self.callServicegetUserProfile()
                           } else if status == 500 {
                                self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        }else{
                               self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
            }
        }
    
    @IBAction func actionOnCamera(_ sender:Any){
        self.showSimpleActionSheet(controller: self, tagValue: 0)
    }
//    @IBAction func btnFilter_Action(_ sender: UIButton) {
//        self.popUpFilter(isAnimated: true)
//    }
//    func popUpFilter(isAnimated:Bool) {
//         let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
//         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
//        // popup.data = response
//         // popup.isCategory = true
//         popup.delagate = self
//        self.presentOnRoot(with: popup, isAnimated: isAnimated)
//    }
    @IBAction func actionOnReviews(_ sender:Any){
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : ProfessionalReviewListPopUpVC = pop.instantiateViewController(withIdentifier: "ProfessionalReviewListPopUpVC") as! ProfessionalReviewListPopUpVC
        popup.rating = String(self.profile.rating)
        popup.image = self.profile.userImg
        popup.delagate = self
        popup.isPersonal = false
        popup.name = self.profile.companyName
        
        popup.ratingList = self.profile.ratingList
        self.tabBarController?.tabBar.isHidden = true
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    @IBAction func actionOnLocation(_ sender:Any){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @IBAction func actionOnChangeEmail(_ sender:Any){
        self.popUpchangeEmail(isAnimated: true)
    }
    @IBAction func actionOnUpdate(_ sender:Any){
        
        if  isConnectedToInternet() {
            self.callServiceUpdateUserProfileAPI()
         } else {
         self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
//    @IBAction func actionOnGender(_ sender:Any){
//        self.popUpGender(isAnimated: true)
//    }
//    func popUpGender(isAnimated:Bool) {
//         let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
//         let popup : GenderVCpopUp = pop.instantiateViewController(withIdentifier: "GenderVCpopUp") as! GenderVCpopUp
//        // popup.data = response
//         // popup.isCategory = true
//         popup.delagate = self
//        self.presentOnRoot(with: popup, isAnimated: isAnimated)
//    }
    func popUpchangeEmail(isAnimated:Bool) {
         let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : ChangeEmailVC = pop.instantiateViewController(withIdentifier: "ChangeEmailVC") as! ChangeEmailVC
        // popup.data = response
         // popup.isCategory = true
         popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
}
extension ProfessionalVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showSimpleActionSheet(controller: UIViewController,tagValue:Int) {
      
        if (MyDefaults().language ?? "") as String ==  "en"{
            let alert = UIAlertController(title: "Pris24", message: "Please_Select_an_Option".LocalizableString(localization: "en"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".LocalizableString(localization: "en"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Gallery".LocalizableString(localization: "en"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss".LocalizableString(localization: "en"), style: .destructive, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        } else{
            let alert = UIAlertController(title: "Pris24", message: "Please_Select_an_Option".LocalizableString(localization: "da"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".LocalizableString(localization: "da"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .camera)
            }))
            alert.addAction(UIAlertAction(title: "Gallery".LocalizableString(localization: "da"), style: .default, handler: { (_) in
                self.getImage(fromSourceType: .photoLibrary)
            }))
            alert.addAction(UIAlertAction(title: "Dismiss".LocalizableString(localization: "da"), style: .destructive, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: {
                print("completion block")
            })
        }
    }
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            // isUploadPhoto = true
            self.present(imagePickerController, animated: true, completion: nil)
            
        }}
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let chosenImage = info[.originalImage] as? UIImage{
            self.imgviewUser.image = chosenImage
            self.imageArray = [[String:Any]]()
            var dict = [String:Any]()
            dict ["uploadfile"] = "user_img"
            dict ["type"] = "image"
            dict ["png"] = chosenImage
            dict["isselected"] = "yes"
            self.imageArray.append(dict)
            picker.dismiss(animated: true, completion: nil)
        }
    }
    private func isRequiredFieldValid() -> Bool {
           if !Util.isValidString(txtCompanyName.text!) {
                Util.showAlertWithMessage("Please enter company name".localiz(), title: Key_Alert)
                return false
           } else if !Util.isValidString(txtCity.text!) {
                Util.showAlertWithMessage("Please enter city name".localiz(), title: Key_Alert)
                return false
                   }
           else if !Util.isValidString(txtZipCode.text!) {
                Util.showAlertWithMessage("Please enter zip code".localiz(), title: Key_Alert)
                return false
                   }
           return true
       }
}
extension ProfessionalVC:delegateChangeEmail,delegateProfileReviewlist,delegateProfessionalReviewlist {
    func getProfessionalReviewlist() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func delegatChangeEmail(email:String) {
        self.txtEmail.text = email
        self.dismiss(animated: true, completion: nil)
    }
//    func delegatSelecteGender(dict: [String : Any]) {
//        let gender = dict["gender"] as? String
//        if (MyDefaults().language ?? "") as String ==  "en"{
//           // self.changeLanguage(strLanguage: "en")
//            self.txtGender.text = gender?.LocalizableString(localization: "en")
//        } else{
//            self.txtGender.text = gender?.LocalizableString(localization: "da")
//        }
//        self.genderId = dict["genderId"] as? String ?? "1"
//
//    }
    func getProfileReviewlist(){
        self.tabBarController?.tabBar.isHidden = false
    }
}
   extension ProfessionalVC: GMSAutocompleteViewControllerDelegate,UITextFieldDelegate {
// Handle the user's selection.
func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(String(describing: place.name))")
    print("Place address: \(String(describing: place.formattedAddress))")
    print("Place attributions: \(String(describing: place.attributions))")
    dismiss(animated: true, completion: nil)
    
    forwardGeocoding(address: place.formattedAddress!)
    self.txtLocation.text = place.formattedAddress!
}

func forwardGeocoding(address: String) {
    CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
        if error != nil {
            print(error!)
            return
        }
        let placemarkCount = placemarks?.count
        if placemarkCount! > 0 {
            let placemark = placemarks?[0]
            let location = placemark?.location
            let coordinate = location?.coordinate
            self.latitude = String(coordinate!.latitude)
            self.longitude = String(coordinate!.longitude)
            }
    })
}

func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: \(error)")
    dismiss(animated: true, completion: nil)
}

// User cancelled the operation.
func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    print("Autocomplete was cancelled.")
    dismiss(animated: true, completion: nil)
}
    func changeLanguage(strLanguage:String) {
        self.lblMyProfile.text = "MyProfile".LocalizableString(localization: strLanguage)
        self.lblReview.text = "Reviews".LocalizableString(localization: strLanguage)
        self.txtCompanyName.placeholder = "ComapnyName".LocalizableString(localization: strLanguage)
        self.txtCVRNumber.placeholder = "CVR".LocalizableString(localization: strLanguage)
        self.txtZipCode.placeholder = "ZipCode".LocalizableString(localization: strLanguage)
        self.txtCity.placeholder = "City".LocalizableString(localization: strLanguage)
       // self.txtGender.placeholder = "Gender".LocalizableString(localization: strLanguage)
        self.txtDOB.placeholder = "DateOFBIRTH".LocalizableString(localization: strLanguage)
        self.txtMobileNumber.placeholder = "MobileNumber".LocalizableString(localization: strLanguage)
        self.txtEmail.placeholder = "EmailAddress".LocalizableString(localization: strLanguage)
        self.txtLocation.placeholder = "Locality".LocalizableString(localization: strLanguage)
        self.btnChangeEmail.setTitle("ChangeEmail".LocalizableString(localization: strLanguage), for: .normal)
        self.btnUdate.setTitle("UPDATE".LocalizableString(localization: strLanguage), for: .normal)
        
      
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                           replacementString string: String) -> Bool
    {
        let maxLength = 8
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtMobileNumber {
            if self.txtMobileNumber.text == "EX.12345678" {
                textField.text = ""
            } else{
                
                if self.profile.mobileNumber.isEmpty {
                    self.txtMobileNumber.text = "EX.12345678"
                    self.txtMobileNumber.textColor = UIColor.hexStringToUIColor(hex: "#C0C8DE")
                } else{
                    self.txtMobileNumber.text = self.profile.mobileNumber
                    self.txtMobileNumber.textColor = UIColor.black
                }
                
            }
            
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtMobileNumber {
            textField.textColor = UIColor.black
        }
    }
}
//extension UITextField {
//
//    func setInputViewDatePicker(target: Any, selector: Selector) {
//        // Create a UIDatePicker object and assign to inputView
//        let screenWidth = UIScreen.main.bounds.width
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
//        datePicker.datePickerMode = .date //2
//        self.inputView = datePicker //3
//
//        // Create a toolbar and assign it to inputAccessoryView
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
//        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
//        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
//        self.inputAccessoryView = toolBar //9
//
//    }
//
//    @objc func tapCancel() {
//        self.resignFirstResponder()
//    }
//
//}

