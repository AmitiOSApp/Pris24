//
//  Util.swift
//  kluly
//
//  Created by Apple on 06/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

//** MARK: Global Properties
var isNetworkAvailable = false
var g_UIUtil: Util?

class Util : NSObject {
    
    var g_isBusy = false

    //****************************************************
    // MARK: - Properties
    //****************************************************
    
    class var userDateFormatter : DateFormatter {
        struct Static {
            static let instance: DateFormatter = {
                let dateFormatter = DateFormatter()
                return dateFormatter
            }()
        }
        return Static.instance
    }
    
    static var documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static var cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    // MARK: - Validations Methods
    class func isValidEmail(_ emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    class func isPhoneNumberLength(_ phoneNumber: String) -> Bool {
        return phoneNumber.count > 10 ? true : false
    }
    
    class func getWithoutFormattedPhoneNumber(_ phoneNumber: String) -> String {
        var formattedPhoneNo = phoneNumber.replacingOccurrences(of: "(", with: "", options: .literal, range: nil)
        formattedPhoneNo = formattedPhoneNo.replacingOccurrences(of: ")", with: "", options: .literal, range: nil)
        formattedPhoneNo = formattedPhoneNo.replacingOccurrences(of: "-", with: "", options: .literal, range: nil)
        formattedPhoneNo = formattedPhoneNo.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        
        return formattedPhoneNo
    }

    class func generateRandomNumber(_ numDigits: Int) -> Int {
        var place = 1
        var finalNumber = 0
        
        for _ in 0 ..< numDigits {
            place *= 10
            let randomNumber = arc4random_uniform(6)
            finalNumber += Int(randomNumber) * Int(place)
        }
        return finalNumber
    }

    class func checkEnglishPhoneNumberFormat(_ string: String?, str: String?, textField: UITextField) -> Bool {
        
        if string == "" { //BackSpace
            return true
        }
        else if str!.count < 3 {
            if str!.count == 1 {
                textField.text = "("
            }
        }
        else if str!.count == 5 {
            textField.text = textField.text! + ") "
        }
        else if str!.count == 10 {
            textField.text = textField.text! + "-"
        }
        else if str!.count > 14 {
            return false
        }
        return true
    }

    // MARK: - Password Validation : Check current and Confirm is Same. || Password length Validation - Length should grater than 7.
    class func isPwdLenth(password: String , confirmPassword : String) -> Bool {
        if password.count <= 6 && confirmPassword.count <= 6 {
            return true
        }
        else {
            return false
        }
    }
    class func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword {
            return true
        }
        else {
            return false
        }
    }
    
    class func getValidString(_ string: String?) -> (String) {
        if string == nil || string == "nil" || string!.isKind(of: NSNull.self) || string == "null" || string == "<null>" || string == "(null)" {
            
            return ""
        }
        return string!.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    class func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    class func isValidString(_ string: String) -> (Bool) {
        let str = getValidString(string)
        return !str.isEmpty
    }
    
    class func removeInLineWhiteSpace(_ string: String) -> (String){
       return string.replacingOccurrences(of: " ", with: "")
    }
    
    class func encodedURL(_ string: String) -> (String){
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    class func getValidPrice(_ string: String?) -> (String) {
        
        if isValidString(string!){
            
            let price = Double(string!)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            
            var ValidPrice = ""
            
            if let amount = price {
                ValidPrice = ("£\(numberFormatter.string(from: NSNumber(value: amount))!)")
            } else {
                ValidPrice = ""
            }
            
            return ValidPrice
        }
            
        else{
            return ""
        }
    }
    
    class func getCapitalizedString(_ string: String?) -> (String) {
        
        if isValidString(string!){
            
            return (string!.capitalizingFirstLetter()) }
            
        else{
            return ""
        }
    }

    class func isValidUrl (urlString: String?) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: urlString)
        return result
    }

    class func base64StringFromImage(_ image: UIImage) -> (String) {
        let imageData = image.pngData()
        let strBase64:String = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    class func showNetWorkAlert() {
        showAlertWithMessage("Please check your connection and try again.", title:"No Network Connection")
    }
    
    class func showAlertWithMessage(_ message: String, title: String) {
        //** If any Alert view is alrady presented then do not show another alert
        if UIApplication.topViewController() != nil {
            if (UIApplication.topViewController()!.isKind(of: UIAlertController.self)) {
                return
            }
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    class func getDateFromatFromDateStringForNotification(_ dateString: String) -> String {
        return kAPI_ServerNotificationDateFormat
    }

    class func getDateFromatFromDateString(_ dateString: String) -> String {
        return kAPI_ServerDateFormat
    }

    class func getCurrentDateInUTCFormate() -> Date {

        let currentDate = Date()

        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")

        userDateFormatter.timeZone = TimeZone(identifier: "UTC")
        userDateFormatter.dateFormat = kAPI_AppDateFormat
        let dateString = userDateFormatter.string(from: currentDate)
        //log.debug("currentDate:\(currentDate),\n UTC date:\(dateFormatter.dateFromString(dateString)!)")
        return userDateFormatter.date(from: dateString)!
    }
    
    class func getUTCDateFromDateStringForNotification(_ dateString: String) -> Date? {
        return getUTCDateFromDateString(dateString, dateFormat: getDateFromatFromDateStringForNotification(dateString))
    }

    class func getUTCDateFromDateString(_ dateString: String) -> Date? {
        return getUTCDateFromDateString(dateString, dateFormat: getDateFromatFromDateString(dateString))
    }

    class func getUTCDateFromDateString(_ dateString: String, dateFormat: String) -> Date? {

        if !self.isValidString(dateString) {
           return nil
        }

        userDateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        userDateFormatter.timeZone   = TimeZone(identifier: "UTC")
        userDateFormatter.dateFormat = dateFormat
        
        return userDateFormatter.date(from: dateString)!
    }

    class func relativeDateStringForDate(_ date:  Date?) -> String {

        if date == nil {
            return ""
        }

        let gregorian = Calendar.current
        let units = NSCalendar.Unit(rawValue: UInt.max)

        let dateToday = getCurrentDateInUTCFormate()

        let components = (gregorian as NSCalendar).components(units, from: date!, to: dateToday, options: [])

        if components.year! > 0 {
            if components.year == 1 {
                return "\(components.year!) year"
            } else {
                return "\(components.year!) years"
            }
        }
        else if components.month! > 0 {
            if components.month == 1 {
                return "\(components.month!) month"
            } else {
                return "\(components.month!) months"
            }
        }
        else if components.weekOfYear! > 0 {
            if components.weekOfYear == 1 {
                return "\(components.weekOfYear!) week"
            } else {
                return "\(components.weekOfYear!) weeks"
            }
        }
        else if components.day! > 0 {
            if components.day == 1 {
                return "\(components.day!) day"
            } else {
                return "\(components.day!) days"
            }
        }
        else if components.hour! > 0 {
            if components.hour == 1 {
                return "\(components.hour!) hour"
            } else {
                return "\(components.hour!) hours"
            }
        }
        else if components.minute! > 0 {
            if components.minute == 1 {
                return "\(components.minute!) min"
            } else {
                return "\(components.minute!) mins"
            }
        }
        else if components.second! > 0  {
            if components.second == 1 {
               return "\(components.second!) second"
            } else {
               return "\(components.second!) seconds"
            }
        }
        else {
            return "Just now"
        }
    }

    //*> Get week day name
    class func getDayOfWeekString(_ today:String) ->String? {

        userDateFormatter.dateFormat = "yyyy-MM-dd"
        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let todayDate = userDateFormatter.date(from: today) {

            let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let myComponents = (myCalendar as NSCalendar).components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1?:
                return "Sunday"
            case 2?:
                return "Monday"
            case 3?:
                return "Tuesday"
            case 4?:
                return "Wednesday"
            case 5?:
                return "Thursday"
            case 6?:
                return "Friday"
            case 7?:
                return "Saturday"
            default:
                print("Error fetching days")
                return "Day"
            }
        }
        else {
            return nil
        }
    }

    class func getDateStringInDesiredFormat(_ dateString: String, sourceFormat: String, destinationFormat: String) -> String {

        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        userDateFormatter.dateFormat = sourceFormat
        let date = userDateFormatter.date(from: dateString)

        userDateFormatter.dateFormat = destinationFormat
        
        if date == nil {
            return ""
        }
        else {
            let desiredString = userDateFormatter.string(from: date!)
            return desiredString
        }
    }

    class func getStringFromDate(_ date: Date, sourceFormat: String, destinationFormat: String) -> String {

        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // userDateFormatter.dateFormat = sourceFormat

        userDateFormatter.dateFormat = destinationFormat
        let desiredString = userDateFormatter.string(from: date)

        return desiredString
    }
    
    class func getStringFromDateWithDestination(_ date: Date, destinationFormat: String) -> String {
        
        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        userDateFormatter.dateFormat = destinationFormat
        let desiredString = userDateFormatter.string(from: date)
        
        return desiredString
    }

    class func getDateFromString(_ strDate: String, sourceFormat: String, destinationFormat: String) -> Date {

        userDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        userDateFormatter.dateFormat = sourceFormat
        let date = userDateFormatter.date(from: Util.getValidString(strDate))
        
        if date == nil {
            return Date()
        }
        return date!
    }

    class func isGreaterThanDate(_ dateToCompare: Date) -> Bool {

        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")

        //Declare Variables
        var isGreater = false

        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    class func isLessThanDate(_ dateToCompare: Date) -> Bool {

        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")

        //Declare Variables
        var isLess = false

        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    class func equalToDate(_ dateToCompare: Date) -> Bool {

        let strDate = Util.getStringFromDate(Date(), sourceFormat: "yyyy-MM-dd hh:mm:ss a ZZZ", destinationFormat: "yyyy/MM/dd")
        let date = Util.getDateFromString(strDate, sourceFormat: "yyyy/MM/dd", destinationFormat: "yyyy/MM/dd")

        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if date.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }

    class func dateCompraisionStatus(_ compareType: String, date: Date) -> Bool {

        var isCompareStatus = false

        if compareType == "GreaterThan" {
            isCompareStatus = self.isGreaterThanDate(date)
        }
        else if compareType == "LessThan" {
            isCompareStatus = self.isLessThanDate(date)
        }
        else if compareType == "Equal"{
            isCompareStatus = self.equalToDate(date)
        }

        return isCompareStatus
    }
    
    class func deleteHTMLTag(tag: String) -> String {
        let str = tag.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        return str
    }
    
    // MARK: - Print fonts
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    class func lableLineSpacing(text: String, fontName: String, lblName: UILabel) {
        let attributeLandlordInfo = [NSAttributedString.Key.font: UIFont(name: fontName, size: lblName.font.pointSize)!]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        
        var attrString = NSMutableAttributedString()
        
        attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttributes (attributeLandlordInfo, range: NSMakeRange(0, attrString.length))
        
        lblName.attributedText = attrString
    }
    
    class func removeAllChilds(in parent: UIView?) {
        if parent == nil {
            return
        }
        for subview: UIView? in parent?.subviews ?? [] {
            subview?.removeFromSuperview()
        }
    }
    
    class func removeAllTargets(_ control: UIControl?) {
        if control == nil {
            return
        }
        for target: Any? in control?.allTargets ?? [] {
            control?.removeTarget(target, action: nil, for: .allEvents)
        }
    }

    class func getViewController(_ view: UIView?) -> UIViewController? {
        
        var next: UIView? = view
        while next != nil {
            let next_responder: UIResponder? = next?.next
            if (next_responder is UINavigationController) {
                return next_responder as? UIViewController
            }
            if (next_responder is UIViewController) {
                let vc = next_responder as? UIViewController
                if vc?.navigationController != nil {
                    return vc
                }
            }
            next = next?.superview
        }
        
        return nil
        
        //    for (UIView* next = view; next; next = next.superview) {
        //        UIResponder* nextResponder = [next nextResponder];
        //        if ([nextResponder isKindOfClass:[UIViewController class]]) {
        //            UIViewController* vc = (UIViewController*)nextResponder;
        //            if(vc.navigationController != nil)
        //                return vc;
        //        }
        //    }
        //    return nil;
    }
    
    class var topViewController: UIViewController? {
        var resultVC: UIViewController?
        
        resultVC = Util._topViewController(UIApplication.shared.keyWindow?.rootViewController)
        
        while ((resultVC?.presentedViewController) != nil) {
            resultVC = Util._topViewController(resultVC?.presentedViewController)
        }
        return resultVC
    }

    class func _topViewController(_ vc: UIViewController?) -> UIViewController? {
        if (vc is UINavigationController) {
            return Util._topViewController((vc as? UINavigationController)?.topViewController)
        } else if (vc is UITabBarController) {
            return Util._topViewController((vc as? UITabBarController)?.selectedViewController)
        } else {
            return vc
        }
    }
    
    class func loadViewController(fromStoryboard vcid: String?, storyboardName sbname: String?) -> UIViewController? {
        let sb = UIStoryboard(name: sbname ?? "", bundle: nil)
        return sb.instantiateViewController(withIdentifier: vcid ?? "")
    }

    class func loadView(fromXib xibname: String?) -> UIView? {
        let nibArray = Bundle.main.loadNibNamed(xibname!, owner: nil, options: nil)
        return (nibArray?.last as! UIView)
    }
    
    class func setNavigationBarBackItem(_ viewctrl: UIViewController?) {
        return
//        let leftBarButton: UIButton? = Util.setNavigationBarBackItemWithReturn(viewctrl)
//        if g_UIUtil == nil {
//            g_UIUtil = Util()
//        }
//        leftBarButton?.addTarget(g_UIUtil, action: #selector(self.popupViewController(_:)), for: .touchUpInside)
    }

    class func setNavigationBarBackItemWithReturn(_ viewctrl: UIViewController?) -> UIButton? {
        let leftBarButton = UIButton(type: .custom)
        
        leftBarButton.contentHorizontalAlignment = .left
        leftBarButton.setImage(UIImage(named: "icon_back_gray"), for: .normal)
        leftBarButton.setTitle("aaa", for: .normal)
        leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0) //-20
        leftBarButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -40, right: 0) //-20
        leftBarButton.setTitleColor(UIColor.gray, for: .highlighted)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        leftBarButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        viewctrl?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        return leftBarButton
    }
    
    @objc func popupViewController(_ sender: UIButton?) {
        let vc: UIViewController? = Util.getViewController(sender)
        if (vc is UINavigationController) {
            let navvc = vc as? UINavigationController
            navvc?.popViewController(animated: true)
        } else {
            vc?.navigationController?.popViewController(animated: true)
        }
    }

    class func alert(_ message: String?, acceptTitle: String?) {
        Util.alert(withTitle: "", message: message, acceptTitle: acceptTitle)
    }
    
    class func alert(withTitle title: String?, message: String?, acceptTitle: String?) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: acceptTitle, style: UIAlertAction.Style.default, handler: nil))

        let viewctrl: UIViewController? = Util.topViewController
        viewctrl?.present(alertC, animated: true)
    }
    
    class func query(_ message: String?, acceptTitle: String?, cancelTitle: String?, acceptHandler: @escaping () -> Void) {
        Util.query(message, acceptTitle: acceptTitle, cancelTitle: cancelTitle, acceptHandler: acceptHandler, rejectHandler: {})
    }
    
    class func query(withTitle title: String?, message: String?, acceptTitle: String?, cancelTitle: String?, acceptHandler: @escaping () -> Void) {
        
        Util.query(withTitle: title, message: message, acceptTitle: acceptTitle, cancelTitle: cancelTitle, acceptHandler: acceptHandler, rejectHandler: {})
    }
    
    class func query(_ message: String?, acceptTitle: String?, cancelTitle: String?, acceptHandler: @escaping () -> Void, rejectHandler: @escaping () -> Void) {
        
        Util.query(withTitle: "", message: message, acceptTitle: acceptTitle, cancelTitle: cancelTitle, acceptHandler: acceptHandler, rejectHandler: rejectHandler)
    }

    class func query(withTitle title: String?, message: String?, acceptTitle: String?, cancelTitle: String?, acceptHandler: @escaping () -> Void, rejectHandler: @escaping () -> Void) {

        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertC.addAction(UIAlertAction(title: acceptTitle, style: .default, handler: { action in
            acceptHandler()
        }))

        alertC.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { action in
            rejectHandler()
        }))
        let viewctrl: UIViewController? = Util.topViewController
        viewctrl?.present(alertC, animated: true)
    }
    
    class func getHeaderHeight(_ viewController: UIViewController) -> CGFloat {
        
        // let yNavBar = viewController.navigationController?.navigationBar.frame.size.height
        let yStatusBar = UIApplication.shared.statusBarFrame.size.height

        let headerHeight = 44 + yStatusBar
        
        return headerHeight
    }

    class func createUsername(_ dictTemp: NSDictionary) -> String {
        let firstName = dictTemp["first_name"] as? String
        let lastName = dictTemp["last_name"] as? String
        
        let username = "\(firstName ?? "") \(lastName ?? "")"
        
        return username
    }

}

extension CALayer {
    func setBorderColorFrom(_ color: UIColor?) {
        borderColor = color?.cgColor
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension NSLayoutConstraint {
    func setMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint? {
        NSLayoutConstraint.deactivate([self])
        
        var newl: NSLayoutConstraint? = nil
        if let anItem = firstItem {
            newl = NSLayoutConstraint(item: anItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        }
        
        newl?.priority = priority
        newl?.shouldBeArchived = shouldBeArchived
        newl?.identifier = identifier
        
        NSLayoutConstraint.activate([newl!])
        
        return newl
    }
}

/**
 * Find and retun top or visible view controller
 */
extension UIApplication {
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
//    func capitalizingFirstLetter() -> String {
//        let first = String(prefix(1)).capitalized
//        let other = String(dropFirst())
//        return first + other
//    }
    
    func height(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var isUrlValid: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.endIndex.encodedOffset
        }
        else {
            return false
        }
    }
    
}

//****************************************************
// MARK: - Global Methods
//****************************************************

func noop() {
    //** Global no operation function, useful for doing nothing in a switch option, and examples
}

extension UIImage {
    func resize(_ newSize: CGSize) -> UIImage? {
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize)
        
        // Tell the old image to draw in this new context, with the desired
        // new size
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        // Get the new image from the context
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context
        UIGraphicsEndImageContext()
        
        // Return the new image.
        return newImage
    }
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func resizedImage(_ newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions((CGSize(width: newWidth, height: newHeight)), false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
