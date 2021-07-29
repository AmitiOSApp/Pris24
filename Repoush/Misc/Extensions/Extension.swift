//
//  Extension.swift
//  ShibariStudy
//
//  Created by mac on 12/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func viewCircle(view:UIView)
    {
        view.layer.borderWidth = 1
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
    func roundedWhiteCircle(view:UIView)
    {
        view.layer.borderWidth = 2
        view.layer.masksToBounds = false
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = view.frame.height/2
        view.clipsToBounds = true
    }
}
    extension UIButton {
//    func roundCorner(button:UIButton)
//    {
//       // button.backgroundColor = .clear
//        //button.layer.cornerRadius = 20
//        button.layer.borderWidth = 2
//         button.layer.cornerRadius = button.frame.height/2
//        button.layer.borderColor = UIColor.black.cgColor
//    }
//        func buttonBorderColor(button:UIButton)
//        {
//            // button.backgroundColor = .clear
//            //button.layer.cornerRadius = 20
//            button.layer.borderWidth = 1.0
//            //  button.layer.cornerRadius = button.frame.height/2
//            button.layer.borderColor = UIColor.black.cgColor
//        }
    }

    extension UIViewController {
       func alertViewForBacktoController(title:String,message:String) {
                   let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                   let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                        })
                        //alert.addAction(ok)
                   self.navigationController?.popViewController(animated: true)
       //            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
       //                 })
       //                 alert.addAction(cancel)
                   alert.addAction(ok)
                        DispatchQueue.main.async(execute: {
                           self.present(alert, animated: true)
                   })
               }
        func alertViewForBacktoControllerWhendataNotAvailable(title:String,message:String) {
                   let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                          switch action.style{
                          case .default:
                                print("default")
                                self.clicOnOkdataNotAvalailabel()
                          case .cancel:
                                print("cancel")

                          case .destructive:
                                print("destructive")


                    }}))
                    self.present(alert, animated: true, completion: nil)
                }
        
        
        func clicOnOkdataNotAvalailabel() {
          //  UserDefaultsults().isLogin = false
            self.navigationController?.popViewController(animated: true)
        
        }
        
        func showErrorPopup(message: String, title: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        func showAlert(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
//            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
//               present(alertController, animated: true, completion: nil)
//            }
            self.present(alertController, animated: true, completion: nil)
            }
        func FuncationLogout(title:String , message:String) {
            let alertController = UIAlertController(title: "", message: "Would you like to logout?", preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.clickOnDissmiss()
            }
            let cancelAction = UIAlertAction(title: "YES",style: UIAlertAction.Style.destructive) {
                UIAlertAction in
                 
                self.clickOnYesAlert()
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
         func autoLogout(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // Create the actions
           let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            self.autoLogOutBack(self)
         //   Global.logout(self)
            }
           
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
       
//            MyDefaults().UserId = nil
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let nav = storyboard.instantiateViewController(withIdentifier: "loginnav")
//            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//           // appDel.window?.rootViewController = nav
        
        }
        func autoLogOutBack(_ viewC : UIViewController) {
              
            //UINavigationBar.appearance().tintColor = Global.hexStringToUIColor(AppColor.KKnavigationTintColor)
            //    UINavigationBar.appearance().barTintColor = Global.hexStringToUIColor(AppColor.kkThemeColor)
               
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//               let loginViewController = storyboard.instantiateViewController(withIdentifier: "ZLoginVC") as! ZLoginVC
//               let selectUserNav: UINavigationController = UINavigationController(nibName: "loginnav", bundle: nil)
//               selectUserNav.setViewControllers([loginViewController], animated: true)
//               if viewC.view.window != nil
//               {
//                   UIView.transition(with: viewC.view.window!, duration: 0.3, options: .transitionFlipFromRight, animations: {
//                       viewC.view.window?.rootViewController = selectUserNav
//                   }, completion: { completed in
//                       // maybe do something here
//                   })
//               }
//               else
//               {
//                   let topWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
//                   topWindow.rootViewController = UIViewController()
//                   topWindow.windowLevel = UIWindow.Level.alert + 1
//                   topWindow.makeKeyAndVisible()
//                   UIView.transition(with: topWindow, duration: 0.3, options: .transitionFlipFromRight, animations: {
//                       viewC.view.window?.rootViewController = selectUserNav
//                   }, completion: { completed in
//                       // maybe do something here
//                   })
//               }
        }
        func clickOnYesAlert() {
          //  UserDefaultsults().isLogin = false
             self.callLogoutAPI()
        }
        func clickOnDissmiss() {
          //  UserDefaultsults().isLogin = false
           // self.dismiss(animated: true, completion: nil)
           }
        func callLogoutAPI() {
             //  ShowHud()
            // Global.logout(self)
                //let otpCode = txt1.text! + txt2.text! + txt3.text! + txt4.text!
            
//            UINavigationBar.appearance().barTintColor = UIColor.hexStringToUIColor(hex: AppColor.kkNavigationHeaderColor)
//            UINavigationBar.appearance().tintColor = .white
//            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//            UINavigationBar.appearance().isTranslucent = false

              
//        let parameter: [String: Any] = ["user_id":MyDefaults().UserId!]
//
//         print(parameter)
//         HTTPService.callForPostApi(url:logoutAPI , parameter: parameter, authtoken: "") { (response) in
//             debugPrint(response)
//         //    HideHud()
//             if response.count != nil {
//                 let status = response["responseCode"] as! Int
//                 let message = response["message"] as! String
//                 if status == 200  {
//                      Global.logout(self)
//                 }  else if status == 500 {
//                     self.showErrorPopup(message: message, title: ALERTMESSAGE)
//                 }
//
//             }else{
//                 self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
//             }
//         }
//
//
        
        
        }
        
        
       
        func ShowalertWhenPopUpviewController(title:String , message:String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                self.Popup()
            }
            
            alertController.addAction(okAction)

            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        func Popup() {
            self.navigationController?.popToRootViewController(animated: true)
        }
        func openMapWithLatLong(intLatitude:Double,intLongititude:Double) {
            if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                UIApplication.shared.open(URL(string:
                    "comgooglemaps://?saddr=&daddr=\(intLatitude),\(intLongititude)&directionsmode=driving")! as URL)
                
            } else {
                NSLog("Can't use comgooglemaps://");
                if let url = NSURL(string: "http://maps.apple.com/?saddr=&daddr=\(intLatitude),\(intLongititude)")
                {
                    //UIApplication.shared.openURL(url as URL)
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)

                }
                else
                {
                   // Global.showAlertMessage(self, title: Constants.APP_NAME, andMessage: "Please download maps to get direction")
                }
            }
        }
//        func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
//        {
//            let calendar = NSCalendar.current
//
//            let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
//
//            return components.day
//        }

       

}

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: 0 , width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.darkGray.cgColor//UIColor.hexStringToUIColor(hex: "#7E8290")
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    func addInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
//    func bottomLine(myTextField:UITextField){
//    var bottomLine = CALayer()
//    bottomLine.frame = CGRectMake(0.0, myTextField.frame.height - 1, myTextField.frame.width, 1.0)
//    bottomLine.backgroundColor = UIColor.whiteColor().CGColor
//    myTextField.borderStyle = UITextBorderStyle.None
//    myTextField.layer.addSublayer(bottomLine)
//    }
    func Selecedunderlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: 0 , width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UINavigationController {
    func NavigationBackButton(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        // button.setTitle("Categories", for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        // button.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func backButton()  {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UIDatePicker {
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
        let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
        components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.minimumDate = minDate
        self.maximumDate = maxDate
    }
}
extension String {
    var url:URL?{
        return URL(string: self)
    }
    var thumbnailImage:String {
        return "http://img.youtube.com/vi/\(self)/0.jpg"
    }
    var youtubeVideo: String {
        return "http://www.youtube.com/embed/\(self)"
    }
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    var isValidURL:Bool {
        if let _url = self.url {
            return _url.scheme != ""
        }
        return false
    }
    
    func addBaseURL(_ theURL:String) -> String {
        if self.isValidURL { return self }
        
        // No check for now, just prepending the base url as passed
        return theURL + self
    }
    
    var stringByDecodingURL:String {
        let result = self
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding
        return result!
    }
    func toLengthOf(strRating:String) -> String {
        var str: String = ""
        if strRating.count <= 3 {
            str = strRating
                return str
            } else {
            for charatcer in strRating {
                if str.count == 3{
                    return str
                }else{
                    str = str + "\(charatcer)"
                }
            }
           str = ""
        }
        return str
    }
    func toJSON() -> Any? {
            guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        }

}
public extension UIColor {
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
//    func hexaCGcolor(hexString:String) -> CGColor
//    {
//      if let rgbValue = UInt(hexString, radix: 16) {
//        let red   =  CGFloat((rgbValue >> 16) & 0xff) / 255
//        let green =  CGFloat((rgbValue >>  8) & 0xff) / 255
//        let blue  =  CGFloat((rgbValue      ) & 0xff) / 255
//        return UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
//      } else {
//        return UIColor.black.cgColor
//      }
//    }
}

extension UILabel {
    
    // Pass value for any one of both parameters and see result
//    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
//
//        guard let labelText = self.text else { return }
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = lineSpacing
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
//
//        let attributedString:NSMutableAttributedString
//        if let labelattributedText = self.attributedText {
//            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
//        } else {
//            attributedString = NSMutableAttributedString(string: labelText)
//        }
//
//        // Line spacing attribute
//        attributedString.addAttribute(NSAttrNSAttributedString.KeyraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//
//        self.attributedText = attributedString
//    }
}
extension String {
//    func capitalizingFirstLetter() -> String {
//        return prefix(1).uppercased() + self.lowercased().dropFirst()
//    }
//
//    mutating func capitalizeFirstLetter() {
//        self = self.capitalizingFirstLetter()
//    }
//    func isValidPassword() -> Bool {
//        let regularExpression = regexPassword
//        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
//
//        return passwordValidation.evaluate(with: self)
//    }
    
    
    func convertDateFormaterDate(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = dateFormatter.string(from: date!)
        
        return day
    }
    func convertDateFormaterDateCalender(_ strdate: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let day = dateFormatter.string(from: date!)
        return day
    }
    
      func convertDateFormaterFoeOnlyDate1(_ strdate: String) -> String{
              
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
              let date = dateFormatter.date(from: strdate)
              dateFormatter.dateFormat = "MMM dd, yyyy"
              return  dateFormatter.string(from: date!)
          }
      func convertDateFormaterForAll1(_ strdate: String) -> [String]
      {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
          let date = dateFormatter.date(from: strdate)
          dateFormatter.dateFormat = "MMM dd, yyyy"
          let strDate = dateFormatter.string(from: date!)
          dateFormatter.dateFormat = "hh:mm a"
          let strTime = dateFormatter.string(from: date!)
          return [strDate,strTime]
      }
       func convertTimeFormater1(_ dateAsString: String) -> String
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm:ss"
           let date = dateFormatter.date(from: dateAsString)
           dateFormatter.dateFormat = "hh:mm a"
           let Date12 = dateFormatter.string(from: date!)
           return Date12
       }

        var isValidURLLink: Bool {
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
                // it is a link, if the match covers the whole string
                return match.range.length == self.utf16.count
            } else {
                return false
            }
        }
    
    
    
}

extension UINavigationItem {
//    func addSettingButtonOnRight(){
//        let button = UIButton(type: .custom)
//        button.setTitle("setting", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
//        button.layer.cornerRadius = 5
//        button.backgroundColor = UIColor.gray
//        button.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
//        button.addTarget(self, action: #selectUIControl.Eventge);, for: UIConUIControl.EventtUpInside)
//        let barButton = UIBarButtonItem(customView: button)
//
//        self.rightBarButtonItem = barButton
//    }
//
//    @objc func gotSettingPage(){
//
//    }
}
extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
extension String {
    var isNumber: Bool {
            return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        
    }
    func LocalizableString(localization:String) -> String {
        let path = Bundle.main.path(forResource: localization, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)

    }
    
    func convertTimeFormater(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
   
//    public func toPhoneNumber() -> String {
//        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
//    }
}
extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController ,isAnimated:Bool){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: isAnimated, completion: nil)
    }
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, title) in actionTitles.enumerated() {
                let action = UIAlertAction(title: title, style: .default, handler: actions[index])
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
     func formatPhone(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
       
        var format: [Character]!
        if number.count == 10
        {
            format = [ "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X", "X"]
        }
        else
        {
            format = [ "X", "X", "X", "X", "-", "X", "X", "X", "-", "X", "X", "X",]
        }
        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    func convertHalfMonthDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)

    }
    func convertForServerDate(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd/mm/yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    func sendserverFormat(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    func convertForServertolocal(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy"
        return  dateFormatter.string(from: date!)

    }
    
    
    
    func extensionChangeDateFormat(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    
    func convertDateFormater1(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return  dateFormatter.string(from: date!)
    }
    func convertMMMDDYYYYTOYYYYMMDD(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
    }
    func convertMMMDDYYYYTOYYYYMMDDWithTime(_ strdate: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        return  dateFormatter.string(from: date!)
    }
    func convertDateFormater24format(_ strdate: String) -> [String]
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let strDate = dateFormatter.string(from: date!)
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return [strDate,strTime]
    }
    func convertTimeShortTimeToLongTime(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let dateTime = dateFormatter.date(from: strdate)
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.string(from: dateTime!)
        return date24
    }
    func getCurrentDate() -> String{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = self.getDateTimeFormat(param: "server")
          let strDate = dateFormatter.string(from: Date())
          return strDate
      }
    func extensionOnlyMonth(_ dateAsString: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "E, d MMM yyyy"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    func convertStrinToDate(_ dateAsString: String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateAsString)
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        let date11 = dateFormatter.date(from: dateAsString)!
        return date!
    }
    func GetTimeHourMinet(_ today: String) -> String
    {
         
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let date = dateFormatter.date(from:today)!
        
            var calendar = Calendar.current

           // *** Get components using current Local & Timezone ***
           print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))

           // *** define calendar components to use as well Timezone to UTC ***
           calendar.timeZone = TimeZone(identifier: "UTC")!

           // *** Get All components from date ***
           let components = calendar.dateComponents([.hour, .year, .minute], from: date)
           print("All Components : \(components)")

           // *** Get Individual components from date ***
           let hour = calendar.component(.hour, from: date)
           let minutes = calendar.component(.minute, from: date)
           let seconds = calendar.component(.second, from: date)
           print("\(hour):\(minutes):\(seconds)")
        
        
        return ("\(hour):\(minutes):\(seconds)")
    }
    
    
    func dateDiff(_ dateStr:String, DateFormat dateFormate: String) -> String {
    let f:DateFormatter = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "UTC")
    //f.timeZone = NSTimeZone.local
    f.dateFormat = dateFormate
    
    let now = f.string(from: NSDate() as Date)
    let startDate = f.date(from: dateStr)
    let endDate = f.date(from: now)
    
    let dateComponents = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: startDate!, to: endDate!)
    
    let weeks   = dateComponents.weekOfMonth ?? 0
    let days    = dateComponents.day ?? 0
    let hours   = dateComponents.hour ?? 0
    let min     = dateComponents.minute ?? 0
    let sec     = dateComponents.second ?? 0
    
    var timeAgo = ""
    
    if (sec > 0){
        if (sec > 1) {
            timeAgo = "\(sec) Sec Ago"
        } else {
            timeAgo = "\(sec) Sec Ago"
        }
   // timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
        }
    if (sec < 0){
         if (sec > 1) {
             timeAgo = "\(sec) Sec Ago"
         } else {
            // timeAgo = "\(sec) Sec Ago"
            
            timeAgo = self.currentTime(dateStr)
         }
    // timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
         }
    if (min > 0){
        if (min > 1) {
            timeAgo = "\(min) Mins Ago"
        } else {
            timeAgo = "\(min) Min Ago"
        }
    }
    
    if(hours > 0){
        if (hours > 1) {
            timeAgo = "\(hours) Hours Ago"
        } else {
            timeAgo = "\(hours) Hour Ago"
        }
    }
    
    if (days > 0) {
        if (days > 1) {
           // timeAgo = "\(days) Days Ago"
            timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
        } else {
            timeAgo = "\(days) Day Ago"
        }
    }
    
    if(weeks > 0){
        timeAgo = stringFromNSDate(startDate!, dateFormate: "MMM dd, yyyy h:mm a")
    }
    
    //print("timeAgo is===> \(timeAgo)")
    return timeAgo;
}
    func currentTime(_ strdate: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: strdate)
       
        dateFormatter.dateFormat = "hh:mm a"
        let strTime = dateFormatter.string(from: date!)
        return strTime
    }
//STring From date
func stringFromNSDate(_ date: Date, dateFormate: String) -> String
{
    print(date)
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.full
    dateFormatter.dateFormat = dateFormate
    let formattedDate: String = dateFormatter.string(from: date)
    return formattedDate
    
}
   
    // MARK: - Get Date Time Format 12 Hours
    func getDateTimeFormatOn12Hours(param:String) -> String{
        
        if param == "date" {
            return "MMM d, yyyy"
        }else if param == "time"{
            return "h:mm a"//"HH:mm a"
        }else if param == "dateTime12"{
            return "dd-MM-yyyy h:mm a"
        }else if param == "currentDate"{
            return "dd-MM-yyyy"
        }else if param == "server"{
            return  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        }else if param == "server12"{
            return  "yyyy-MM-dd'T'h:mm a .SSS'Z'"
        }
        return "MMM d, yyyy"
    }
    
    // MARK: - Get Date Time Format
     func getDateTimeFormat(param:String) -> String{
        
        if param == "date" {
            return "MMM d, yyyy"
        }else if param == "time"{
            return "h:mm a"//"HH:mm a"
            
        }else if param == "dateTime"{
            return "MMM dd, yyyy h:mm a"
        }else if param == "server"{
            //2018-05-17T05:24:18.576Z
            //"2018-05-20T12:28:05.000Z"
            //2018-05-14T12:32:00.127Z
            return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        }else if param == "isolocal"{
            let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
            if formatter.contains("a") {
                //phone is set to 12 hours
                return  "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
            } else {
                //phone is set to 24 hours
                return  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            }
        }
        return "MMM d, yyyy"
    }
    func getDateStr(dateStr:String?) -> String{
        
        let dateServerFormat = DateFormatter()
        dateServerFormat.timeZone = NSTimeZone.local
        dateServerFormat.dateFormat = "yyyy-MM-dd h:mm:ss"
        dateServerFormat.locale = Locale(identifier: "en_US_POSIX")
        
        let dateLocalFormat = DateFormatter()
        dateLocalFormat.dateFormat = "MMM dd, yyyy h:mm a"
        dateLocalFormat.locale = Locale(identifier: "en_US_POSIX")
        
        let dateObj: Date? = dateServerFormat.date(from: dateStr!)
        let strDate = dateLocalFormat.string(from: dateObj!)
        return strDate
        
        
    }
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
//        let val = value * percentageVal
//        return val / 100.0
    
    
        let discount = percentageVal * 100 / value
        let total =  100 - discount
        return total
    }
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
extension UIView {
    func roundCornersBottomSide(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
extension Date {

    var tomorrow: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}

extension UIButton{
    func roundedButtonOnlyLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedButtonOnlyRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topRight],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :0 ), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
extension UICollectionView {

var centerPoint : CGPoint {

    get {
        return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
    }
}

var centerCellIndexPath: IndexPath? {

    if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
        return centerIndexPath
    }
    return nil
}
}
