//
//  DiscountNotificationDetailVC.swift
//  Repoush
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class DiscountNotificationDetailVC: UIViewController,UITextFieldDelegate,delegateOpenWebViewFromSendNotification {
    
    
    @IBOutlet weak var txtItemName : UITextField!
    @IBOutlet weak var txtDiscountPercentage : UITextField!
    @IBOutlet weak var txtStoreAddress : UITextField!
    @IBOutlet weak var txtvalidUnit : UITextField!
    @IBOutlet weak var txtStartTime : UITextField!
    @IBOutlet weak var txtEndTime : UITextField!
    @IBOutlet weak var lblTitle : UILabel!
     
   
    @IBOutlet weak var datePicker : UIDatePicker!
    
    
    @IBOutlet weak var lblItemNameLoc : UILabel!
    @IBOutlet weak var lblDiscountPercentageLoc : UILabel!
    @IBOutlet weak var lblStoresAddressLoc : UILabel!
    @IBOutlet weak var lblValiduntillLoc : UILabel!
    @IBOutlet weak var lblHours : UILabel!
    @IBOutlet weak var lblCancelLoc : UILabel!
    @IBOutlet weak var lblShowNotificationLoc: UILabel!

//    @IBOutlet weak var btnCancelLoc : UIButton!
//    @IBOutlet weak var btnShowNotificationLoc : UIButton!
    
    var sellerid = ""
    var product_id = ""
    var seller_name = ""
    private var startDateWithTime = Date()
    private var endDateWithTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (MyDefaults().language ?? "") as String ==  "en" {
            self.changeLanguage(strLanguage: "en")
        } else {
            self.changeLanguage(strLanguage: "da")
        }
    }
    func changeLanguage(strLanguage:String) {
            self.lblTitle.text = "Discount_Notifications".LocalizableString(localization: strLanguage)
            self.lblItemNameLoc.text = "ItemName".LocalizableString(localization: strLanguage)
            self.lblDiscountPercentageLoc.text = "DiscountPercentage".LocalizableString(localization: strLanguage)
            self.lblStoresAddressLoc.text = "StoresAddress".LocalizableString(localization: strLanguage)
            self.lblValiduntillLoc.text = "ValidUntil".LocalizableString(localization: strLanguage)
            self.lblHours.text = "Hours".LocalizableString(localization: strLanguage)
            self.lblCancelLoc.text = "cancel_bid".LocalizableString(localization: strLanguage)
            self.lblShowNotificationLoc.text = "show_notification".LocalizableString(localization: strLanguage)
            self.lblDiscountPercentageLoc.text = "DiscountPercentage".LocalizableString(localization: strLanguage)
            self.txtStartTime.placeholder = "From".LocalizableString(localization: strLanguage)
            self.txtEndTime.placeholder = "To".LocalizableString(localization: strLanguage)
     }
    @IBAction func actionOnCancel(_ sender: Any){
       // self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func actionOnShowNotification(_ sender: Any){
        if isRequiredFieldValid() {
            if  isConnectedToInternet() {
                self.callServiceGetShowNotification()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
    }
    @IBAction func actionOnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    private func isRequiredFieldValid() -> Bool {
        if !Util.isValidString(txtItemName.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("item_name_blank_error".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("item_name_blank_error".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        }
        else if !Util.isValidString(txtDiscountPercentage.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("discount_percentage_blank_error".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("discount_percentage_blank_error".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        }
        else if !Util.isValidString(txtStoreAddress.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("store_address_blank_error".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("store_address_blank_error".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        }
        else if !Util.isValidString(txtvalidUnit.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("valid_until_blank_error".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("valid_until_blank_error".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        }
        else if !Util.isValidString(txtStartTime.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("Please_enter_from_date".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("Please_enter_from_date".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        } else if !Util.isValidString(txtEndTime.text!) {
            if (MyDefaults().language ?? "") as String ==  "en" {
                Util.showAlertWithMessage("Please_enter_to_date".LocalizableString(localization: "en"), title: "Key_Alert".LocalizableString(localization: "en")); return false
            } else {
                Util.showAlertWithMessage("Please_enter_to_date".LocalizableString(localization: "da"), title: "Key_Alert".LocalizableString(localization: "da")); return false
            }
        }
        return true
    }

    
    @IBAction func actionOnAddress(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @IBAction func startDateClick(_ sender: UIButton) {

            var components = DateComponents()
               components.day = 1
               let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to:  Date())
        
        DatePickerDialog().show(controller: self, "Start Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: startDateWithTimePlusOne, datePickerMode: .date) {
              (date) -> Void in
              if let dt = date {
                  let formatter = DateFormatter()
                  formatter.dateFormat = self.getDateTimeFormat(param: "date")
                  //sender.setAttributedTitle(NSAttributedString(string: formatter.string(from: dt)), for: .normal)
                self.txtvalidUnit.text = formatter.string(from: dt)

               formatter.dateFormat = self.getDateTimeFormat(param: "server")
                   formatter.locale = Locale(identifier: "en_US_POSIX")
                //  self.startDate = formatter.string(from: dt)
                self.startDateWithTime = dt
            }
          }

   }
    @IBAction func startTimeClick(_ sender: UIButton) {

        DatePickerDialog().show(controller:self,"Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .time) {
                    (date) -> Void in
                    if let dt = date {
                        var formatter = DateFormatter()
                        formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                        formatter.locale = Locale(identifier: "en_US_POSIX")
                        formatter.amSymbol = "AM"
                        formatter.pmSymbol = "PM"

                        self.txtStartTime.text = formatter.string(from: dt)
                        formatter = DateFormatter()
                        formatter.amSymbol = "AM"
                        formatter.pmSymbol = "PM"
                        formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "dateTime12")
                        formatter.locale = Locale(identifier: "en_US_POSIX")

                    }
                }
        
    }

        @IBAction func endTimeClick(_ sender: UIButton) {

           
                         
                       //  let startDateWithTimePlusOne = Calendar.current.date(byAdding: components, to: self.startDateWithTime)
                         DatePickerDialog().show(controller: self, "End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel" ,minimumDate: Date(), datePickerMode: .time) {
                             (date) -> Void in
                             if let dt = date {
                                 var formatter = DateFormatter()
                                 formatter = DateFormatter()
                                 formatter.dateFormat = self.getDateTimeFormatOn12Hours(param: "time")
                                 formatter.locale = Locale(identifier: "en_US_POSIX")
                                 formatter.amSymbol = "AM"
                                 formatter.pmSymbol = "PM"
                                 //sender.setTitle(formatter.string(from: dt), for: .normal)
                                 self.txtEndTime.text = (formatter.string(from: dt))
                                self.txtEndTime.text = formatter.string(from: dt)

                            }
                         }
                     }
    
    func callServiceGetShowNotification() {
     
        let firstName = LoggedInUser.shared.firstName as AnyObject
        let lastName = LoggedInUser.shared.lastName as AnyObject
        let fullName = "\(firstName) \(lastName)"
        
        
        let stringUrl =         "\(getsentTNotificationTemplate)&buyer_name=\(fullName)&seller_name=\(seller_name)&discount_percantage=\(self.txtDiscountPercentage.text!)&item_name=\(self.txtItemName.text!)&store_address=\(self.txtStoreAddress.text!)&valid_until=\(self.txtvalidUnit.text!)&start_time=\(self.txtStartTime.text!)&end_time=\(self.txtEndTime.text!)"
        let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        print(stringUrl)
        
        self.openSendNotificationPopUp(webUrl: escapedString!)
    }
    func openSendNotificationPopUp(webUrl:String) {
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : DiscountNotificationWebpagePopUp = pop.instantiateViewController(withIdentifier: "DiscountNotificationWebpagePopUp") as! DiscountNotificationWebpagePopUp
        popup.webUrl = webUrl
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
    }
   
    func GetdelegateOpenWebView() {
        self.callServiceSendNotification()
    }
    func callServiceSendNotification() {
        var loading = ""
      if (MyDefaults().language ?? "") as String ==  "en"{
          loading = "Loading".LocalizableString(localization: "en")
      } else{
          loading = "Loading".LocalizableString(localization: "da")
      }
       print(self.txtvalidUnit.text!)
        let parameter: [String: Any] = ["sender_id":sellerid,
                                        "language": MyDefaults().language ?? AnyObject.self,
                                        "product_id":product_id,
                                        "seller_name":seller_name,
                                        "discount_percantage":self.txtDiscountPercentage.text!,
                                        "item_name":self.txtItemName.text!,
                                        "valid_until": self.sendserverFormat(self.txtvalidUnit.text!),
                                        "start_time":self.txtStartTime.text!,
                                        "end_time":self.txtEndTime.text!,
                                        "store_address":self.txtStoreAddress.text!]
 print(parameter)
        HTTPService.callForPostApi(url:getsentNotificationAllUser , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            if (MyDefaults().language ?? "") as String ==  "en"{
                                self.messageShowAccept(index: 0, title: "", message: message, Okay: "Okay".LocalizableString(localization: "en"))
                            } else {
                                self.messageShowAccept(index: 0, title: "", message: message, Okay: "Okay".LocalizableString(localization: "da"))
                            }
                         } else if status == 500 {
                              
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
    }
    func messageShowAccept(index:Int,title:String,message:String,Okay:String) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Okay, style: UIAlertAction.Style.default) {
                UIAlertAction in
            //self.tabBarController?.selectedIndex = 0
            //self.navigationController?.backToViewController(viewController: MyAuctionVC.self)
//            let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            let addtoolNav = storyboard.instantiateViewController(withIdentifier: "HomeVCNavigation") as! UINavigationController
//            addtoolNav.pushViewController(tabBarController, animated:true)
//
//            appDelegate.window?.rootViewController = tabBarController
//            appDelegate.window?.makeKeyAndVisible()
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            newViewController.selectedIndex = 0
//
//            let navigationController = UINavigationController(rootViewController: newViewController)
//            navigationController.navigationController?.isNavigationBarHidden = true
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            appdelegate.window!.rootViewController = navigationController
        
            print(self.tabBarController?.viewControllers ?? "controll")
       
//            if let destinationIndex = self.tabBarController?.viewControllers?.firstIndex(where: { $0 is HomeVC }) {
//                print(destinationIndex)
//                self.tabBarController?.selectedIndex = destinationIndex
//                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierRemoveFilterFronDiscountNotification"), object: nil)
//            }
            self.dismiss(animated: true, completion: nil)
            
           // let nav = (self.tabBarController?.viewControllers?[0] as? UINavigationController)
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            //   let loginVc = storyBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
           // loginVc.selectedIndex = 0
            //let rootVc = UINavigationController(rootViewController: loginVc)
               
//            let addtoolNav = storyBoard.instantiateViewController(withIdentifier: "HomeVCNavigation") as! UINavigationController
//
//            rootVc.navigationController?.isNavigationBarHidden = true
            self.navigationController?.popToRootViewController(animated: true)
           
//            UIApplication.shared.keyWindow?.rootViewController = rootVc
           // let controller = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            
           // self.openViewController(controller: controller, selectedIndex: 0)
            
            //let tabBar: UITabBarController = appDelegate.window?.rootViewController as! UITabBarController

            self.tabBarController?.selectedIndex = 0
            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierRemoveFilterFronDiscountNotification"), object: nil)
        }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
    }
    func openViewController(controller:UIViewController?, selectedIndex: Int?) {

            let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            
            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let addtoolNav = storyboard.instantiateViewController(withIdentifier: "HomeVCNavigation") as! UINavigationController
            let scannerNav = storyboard.instantiateViewController(withIdentifier: "AddPostVCNavigation") as! UINavigationController
            let homeNav = storyboard.instantiateViewController(withIdentifier: "MyAuctionVCNavigation") as! UINavigationController
            let transctionNav = storyboard.instantiateViewController(withIdentifier: "SettingVCNavigation") as! UINavigationController
            let myAccountNav = storyboard.instantiateViewController(withIdentifier: "ProfileVCNavigation") as! UINavigationController

            tabBarController.viewControllers = [addtoolNav, scannerNav, homeNav,transctionNav, myAccountNav]
            tabBarController.selectedIndex = selectedIndex!
            if selectedIndex == 0{
                if tabBarController.selectedViewController == addtoolNav {
                    NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierRemoveFilterFronDiscountNotification"), object: nil)
                    addtoolNav.pushViewController(controller!, animated:true)
                }
            }else if selectedIndex == 1{
                if tabBarController.selectedViewController == scannerNav {
                    scannerNav.pushViewController(controller!, animated:true)
                }
            }else if selectedIndex == 2{
                if tabBarController.selectedViewController == homeNav {
                    homeNav.pushViewController(controller!, animated:true)
                }
            }else if selectedIndex == 3{
                if tabBarController.selectedViewController == transctionNav {
                    transctionNav.pushViewController(controller!, animated:true)
                }
            }else{
                if tabBarController.selectedViewController == myAccountNav {
                    myAccountNav.pushViewController(controller!, animated:true)
                }
            }
        appDelegate.window? = UIWindow.init(frame: UIScreen.main.bounds)
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
    }
}
extension DiscountNotificationDetailVC: GMSAutocompleteViewControllerDelegate {
// Handle the user's selection.
func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(String(describing: place.name))")
    print("Place address: \(String(describing: place.formattedAddress))")
    print("Place attributions: \(String(describing: place.attributions))")
    dismiss(animated: true, completion: nil)
    forwardGeocoding(address: place.formattedAddress!)
    self.txtStoreAddress.text = place.formattedAddress!
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
            
            //self.latitude = coordinate!.latitude
            //self.longitude = coordinate!.longitude
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
