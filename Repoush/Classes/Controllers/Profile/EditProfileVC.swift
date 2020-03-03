//
//  EditProfileVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/26/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var txfFirstName: UITextField!
    @IBOutlet weak var txfLastName: UITextField!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var txfMobileNumber: UITextField!
    @IBOutlet weak var txfEmailAddress: UITextField!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewDatePicker: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerViewGender: UIPickerView!

    // MARK: - Property initialization
    private var pickerAction = 0
    private var latitude = 0.0
    private var longitude = 0.0

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        setUserData()
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTakeImage_Action(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        })
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func btnUser_Action(_ sender: UIButton) {
        if sender.tag == 100 {
            pickerAction = sender.tag
            viewDatePicker.isHidden = false
            datePicker.isHidden = true
            pickerViewGender.isHidden = false
        }
        else if sender.tag == 101 {
            pickerAction = sender.tag
            viewDatePicker.isHidden = false
            datePicker.isHidden = false
            pickerViewGender.isHidden = true
        }
    }
    
    @IBAction func btnPicker_Action(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Done" {
            if pickerAction == 100 {
                let selectedIndex = pickerViewGender.selectedRow(inComponent: 0)
                let strGender = selectedIndex == 0 ? "Male" : "Female"
                lblGender.text = strGender
            }
            else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let selectedDate = formatter.string(from: datePicker.date)
                
                lblAge.text = selectedDate
            }
        }
        viewDatePicker.isHidden = true
    }
    
    @IBAction func btnSelectAddress_Action(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }

    @IBAction func btnUpdateProfile_Action(_ sender: UIButton) {
        // Check required field validation
        if isRequiredFieldValid() {
            // Perform Update profile API
            updateProfileAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func setUserData() {
        txfFirstName.text = LoggedInUser.shared.firstName
        txfLastName.text = LoggedInUser.shared.lastName
        lblGender.text = LoggedInUser.shared.gender
        lblAge.text = LoggedInUser.shared.dob == "" ? "Select dob" : LoggedInUser.shared.dob
        txfMobileNumber.text = LoggedInUser.shared.mobileNo
        txfEmailAddress.text = LoggedInUser.shared.email
        lblAddress.text = LoggedInUser.shared.address
        
        if Util.isValidString(LoggedInUser.shared.userImage!) {
            
            let url = URL.init(string: LoggedInUser.shared.userImage!)
            
            imgviewUser.kf.indicatorType = .activity
            imgviewUser.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgviewUser.image = value.image
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            imgviewUser.image = UIImage(named: "dummy_user")
        }
    }

    private func isRequiredFieldValid() -> Bool {
        if imgviewUser.image == nil || imgviewUser.image == UIImage(named: "dummy_user") {
            Util.showAlertWithMessage("Please select profile image", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfFirstName.text!) {
            Util.showAlertWithMessage("Please enter first name", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfLastName.text!) {
            Util.showAlertWithMessage("Please enter last name", title: Key_Alert); return false
        }
        else if lblAge.text == "Date of birth" {
            Util.showAlertWithMessage("Please select date of birth", title: Key_Alert); return false
        }
        else if lblGender.text == "Gender" {
            Util.showAlertWithMessage("Please select gender", title: Key_Alert); return false
        }
        else if !Util.isValidString(txfMobileNumber.text!) {
            Util.showAlertWithMessage("Please enter mobile number", title: Key_Alert); return false
        }
        else if Util.isValidString(txfEmailAddress.text!) {
            if !Util.isValidEmail(txfEmailAddress.text!) {
                Util.showAlertWithMessage("Please enter valid email address", title: Key_Alert); return false
            }        }
        else if !Util.isValidString(lblAddress.text!) {
            Util.showAlertWithMessage("Please select address", title: Key_Alert); return false
        }
        return true
    }
    
    private func resignAllActiveResponder() {
        if txfFirstName.isFirstResponder {
            txfFirstName.resignFirstResponder()
        }
        else if txfLastName.isFirstResponder {
            txfLastName.resignFirstResponder()
        }
        else if txfMobileNumber.isFirstResponder {
            txfMobileNumber.resignFirstResponder()
        }
        else if txfEmailAddress.isFirstResponder {
            txfEmailAddress.resignFirstResponder()
        }
    }

    // MARK: - API Methods
    private func updateProfileAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        var latitudePass = LoggedInUser.shared.latitude
        var longitudePass = LoggedInUser.shared.longitude
        
        if latitude > 0.0 {
            latitudePass = "\(latitude)"
            longitudePass = "\(longitude)"
        }

        let postParams: [String: AnyObject] =
            [
                kAPI_UserId      : LoggedInUser.shared.id as AnyObject,
                kAPI_FirstName   : txfFirstName.text as AnyObject,
                kAPI_LastName    : txfLastName.text as AnyObject,
                kAPI_Address     : lblAddress.text as AnyObject,
                kAPI_Latitude    : latitudePass as AnyObject,
                kAPI_Longitude   : longitudePass as AnyObject,
                kAPI_Email       : txfEmailAddress.text as AnyObject,
                kAPI_MobileNumber : txfMobileNumber.text as AnyObject,
                 kAPI_DeviceType  : "ios" as AnyObject,
                kAPI_DeviceToken  : Util.getValidString((UserDefaults.standard.object(forKey: kAPI_DeviceToken) as? String)) as AnyObject,
                kAPI_CertificateType : appDelegate.certificateType as AnyObject,
                kAPI_Language        : "en" as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.uploadImagesWithParams(Networking.Router.updateUserProfile(postParams), imageArray: [imgviewUser.image], strImageKey: "user_img", dictParams: postParams, callerObj: self, showHud: true) { (encodingResult) -> Void in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    guard let result = response.result.value else {
                        return
                    }
                    let jsonObj = JSON(result)
                    
                    if jsonObj[Key_ResponseCode].intValue == 500 {
                        Util.showAlertWithMessage(jsonObj[Key_Message].stringValue, title: Key_Alert)
                        return
                    }
                    DLog(message: "\(result)")
                    
                    if let userData = jsonObj["responseData"].dictionary {
                        LoggedInUser.shared.initLoggedInUserFromResponse(userData as AnyObject)
                    }
                    DispatchQueue.main.async { [weak self] in
                        let uiAlert = UIAlertController(title: "Repoush", message: "Propfile updated successfully", preferredStyle:UIAlertController.Style.alert)
                        self?.present(uiAlert, animated: true, completion: nil)
                        
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }))
                    }
                }
            case .failure(let encodingError):
                
                let alertController = UIAlertController(title: kAPI_Alert, message: encodingError as? String, preferredStyle: UIAlertController.Style.alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                )
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate method
extension EditProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Male"
        }
        else {
            return "Female"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
}

// MARK: - UIImagePickerController Delegate
extension EditProfileVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            imgviewUser.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        
        forwardGeocoding(address: place.formattedAddress!)
        
        self.lblAddress.text = place.formattedAddress!
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
                
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
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
    
}
