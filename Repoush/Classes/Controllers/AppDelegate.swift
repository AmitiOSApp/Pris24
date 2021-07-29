//
//  AppDelegate.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/22/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import UserNotifications
//import SKActivityIndicatorView
import PKHUD
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let reachability = try! Reachability()
    var certificateType = ""
    var deviceToken = ""
    var currentLocation: CLLocation?
    var distance = ""
    var apnsAccept = ""
  //  var homeTab = "personal"
    var MyAuction = ""
    var home = "Home"
    var pickUpLocation = ""
    var mobileNumber = ""
    var IntCameraTag : Int = 0
   // private var locManager = CLLocationManager()
    var locationStatus : NSString = "Not Started"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initMyApp(launchOptions)
        // Configure IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Ok"
        // Setup Network status
        setupReachability(nil, useClosures: false)
        startNotifier()
        // Configure Google places API key
        GMSPlacesClient.provideAPIKey("AIzaSyCDCIvoegF9gjgCdHuQc2_eeU8-VEfKioI")
        let currentLanguage = Locale.current.languageCode
        
        let notificationCenter = UNUserNotificationCenter.current()
               notificationCenter.delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        
        MyDefaults().language = currentLanguage
        
        if let languageCode = UserDefaults.standard.string(forKey: "language_code") {
            LanguageManger.shared.defaultLanguage = Languages(rawValue: languageCode)!
            LanguageManger.shared.currentLanguage = Languages(rawValue: languageCode)!
            //UserLanguage.shared.languageCode = languageCode == "en" ? "en" : "pe"
        }
        else {
            LanguageManger.shared.defaultLanguage = Languages(rawValue: Locale.current.languageCode!)!
            LanguageManger.shared.currentLanguage = Languages(rawValue: Locale.current.languageCode!)!
            
            //UserLanguage.shared.languageCode = Locale.current.languageCode! == "en" ? "en" : "pe"
        }
        
        // Default language code
        LanguageManger.shared.setLanguage(language: LanguageManger.shared.currentLanguage)
        
        // Register the App for PNs
        // registerForPushNotifications()
       
        
//        print(UserDefaults.standard.string(forKey: kAPI_Id))
//        print(LoggedInUser.shared.id)
//        print(LoggedInUser.shared.isUserLoggedIn)
        
        
        
        
        
        
        setCertificateType()

        // Setup global navigation
       
        let backButtonImage = UIImage(named: "icon_back_gray3")
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -100000, vertical: 5000), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 17), .foregroundColor : UIColor.black]
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        UIApplication.shared.isIdleTimerDisabled = false
       
//        SKActivityIndicator.spinnerColor(UIColor.hexStringToUIColor(hex: "#02BBCA"))
//        let myFont = UIFont(name: "Montserrat-Regular", size: 14)
//        SKActivityIndicator.statusLabelFont(myFont!)
//        SKActivityIndicator.statusTextColor(UIColor.hexStringToUIColor(hex: "#828282"))
     
      //  print(UserDefaults.standard.string(forKey: kAPI_Id))
        
      if UserDefaults.standard.string(forKey: kAPI_Id) != nil {
            if UserDefaults.standard.string(forKey: kAPI_Id) != nil {
                LoggedInUser.shared.id = UserDefaults.standard.string(forKey: kAPI_Id)
            }
            
            LoggedInUser.shared.latitude = UserDefaults.standard.string(forKey: kAPI_PermanentLatitude)
            LoggedInUser.shared.longitude = UserDefaults.standard.string(forKey: kAPI_PermanentLognitude)
            LoggedInUser.shared.UserRole = UserDefaults.standard.string(forKey: kAPI_Role)
//            print(LoggedInUser.shared.UserRole)
//
//            print(LoggedInUser.shared.id)
            let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let nav = UINavigationController(rootViewController:signInVC)
          //  nav.navigationController?.navigationBar.isHidden = true
            nav.setNavigationBarHidden(true, animated: true)
            let application = UIApplication.shared.delegate as! AppDelegate
            application.window!.rootViewController = nav
//
        
//            window = UIWindow(frame: UIScreen.main.bounds)
//
//
//               let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
//
//               // controller identifier sets up in storyboard utilities
//               // panel (on the right), it called Storyboard ID
//               let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//
//               self.window?.rootViewController = viewController
//               self.window?.makeKeyAndVisible()
//
//               window?.makeKeyAndVisible()
//               window?.rootViewController = viewController
        
//            let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//
//            let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            let addtoolNav = storyboard.instantiateViewController(withIdentifier: "HomeVCNavigation") as! UINavigationController
//            let scannerNav = storyboard.instantiateViewController(withIdentifier: "AddPostVCNavigation") as! UINavigationController
//            let homeNav = storyboard.instantiateViewController(withIdentifier: "MyAuctionVCNavigation") as! UINavigationController
//            let transctionNav = storyboard.instantiateViewController(withIdentifier: "SettingVCNavigation") as! UINavigationController
//            let myAccountNav = storyboard.instantiateViewController(withIdentifier: "ProfileVCNavigation") as! UINavigationController
//
//            tabBarController.viewControllers = [addtoolNav, scannerNav, homeNav,transctionNav, myAccountNav]
//            tabBarController.selectedIndex = 0
//            addtoolNav.pushViewController(addtoolNav, animated:true)
        
        
//            let appdelegate = UIApplication.shared.delegate as! AppDelegate
//            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//            var tableViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//            tableViewController.selectedIndex = 0
//            let navigationVC = UINavigationController(rootViewController: tableViewController)
//            appdelegate.window!.rootViewController = navigationVC
        
        } else{
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController:signInVC)
          //  nav.navigationController?.navigationBar.isHidden = true
            nav.setNavigationBarHidden(true, animated: true)
            let application = UIApplication.shared.delegate as! AppDelegate
            application.window!.rootViewController = nav
        }  
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
//    func permissionGranted(title: String, message: String,okay:String)  {
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
//               UIAlertAction in
//               NSLog("OK Pressed")
//            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//           }
//            alertController.addAction(okAction)
//          self.present(alertController, animated: true, completion: nil)
//    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
       // NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierLocationUpdated"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - init global data -
    func initMyApp(_ launchOptions: [AnyHashable : Any]?) {
        
        //[DBManager checkAndCreateDatabase];
        
        //g_userinfo = UNGetSerializedObject(USERBASEINFO);
        
        //[self initShareSDK];
    }
    
    // MARK: - Private Methods
    private func setCertificateType() {
        // Build change - Manage certificate type according to app mode
        certificateType = kCertificateDevelopment
        
        // certificateType = kCertificateProduction
    }

    // MARK: - Network Reachability Methods
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func startNotifier() {
        do { try reachability.startNotifier() }
        catch { return }
    }
    
    func stopNotifier() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        isNetworkAvailable = reachability.connection != .unavailable ? true : false
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
        case .none:
            print("Network not reachable")
        }
    }
    
    // MARK: - Show/Hide Loader
    func showLoader(_ viewController: UIViewController,text:String) {
        
//        let window = UIApplication.shared.keyWindow!
//
//        let bgView = UIView(frame: window.bounds)
//
//        bgView.tag = 10000001
//        bgView.frame = CGRect.init(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
//        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//
//        viewController.view.addSubview(bgView)
//
//        window.addSubview(bgView)
//        window.backgroundColor = UIColor.white
//
//        let centerView = UIView()
//
//        centerView.frame = CGRect.init(x: bgView.frame.width / 2 - 22, y: bgView.frame.height / 2 - 22, width: 44, height: 44)
//        centerView.backgroundColor = UIColor.white
//        centerView.layer.cornerRadius = 22
//
//        // shadow
//        centerView.layer.shadowColor = UIColor.black.cgColor
//        centerView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        centerView.layer.shadowOpacity = 0.7
//        centerView.layer.shadowRadius = 5.0
//
//        bgView.addSubview(centerView)
//
//        let loadingGroup = STLoadingGroup(side: 20.0, style: .submit)
//
//        loadingGroup.show(bgView)
//        loadingGroup.startLoading()
       
//        SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//        SKActivityIndicator.show(text, userInteractionStatus: false)
    
      //  HUD.flash(.rotatingImage(UIImage(named: "progress")), delay: 2.0)
       // HUD.flash(.labeledProgress(title: "", subtitle: text), delay: 0.5)
        
        SVProgressHUD.show(withStatus: text)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
    }
    
    func hideLoader(_ viewController: UIViewController) {
//        let window = UIApplication.shared.keyWindow!
//        window.backgroundColor = UIColor.white
//        for subview in window.subviews {
//            if subview.tag == 10000001 {
//                subview.backgroundColor = UIColor.white.withAlphaComponent(1.0)
//                subview.removeFromSuperview()
//            }
//        }
   
      //  SKActivityIndicator.dismiss()
   
        SVProgressHUD.dismiss()
        //  HUD.hide(afterDelay: 0.5)
    }

    // MARK: - Request for PNs
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else {
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        DLog(message: "APNs device token: \(deviceTokenString)")
        
        UserDefaults.standard.set(deviceTokenString, forKey: kAPI_DeviceToken)
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
    if let aps = userInfo["aps"] as? NSDictionary {
           print(aps)
            if let moreData = aps["moredata"] as? NSDictionary {
                   print(moreData)
                    self.handleNotification(userInfo: moreData as! [String : Any])
            }
            else if let alert = aps["alert"] as? NSString {
                //Do stuff
            }
        }
    }
    func handleNotification(userInfo: [String:Any]) {

        print(userInfo)
        
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                if let temp = userInfo["product_image"] as? Dictionary<String, AnyObject> {
                let images = temp["product_image"] as! String
                    print(images)
                
                }
                if userInfo["notification_type"] as! String == "Bid Placed" {
                    let notificationType = userInfo["notification_type"] as! String
                    guard let productArray = userInfo["product_image"] as? NSArray else {return}
                    let productDic = productArray[0] as! NSDictionary
                    let productImage = productDic["product_image"] as! String
                    self.switchToToolTransction(productid: userInfo["product_id"] as! String, name: userInfo["product_name"] as! String, productImage: productImage, notificationType: notificationType, info: userInfo)
                    
                }
                if userInfo["notification_type"] as! String == "Pickup Location" {
                    let notificationType = userInfo["notification_type"] as! String
                    guard let productArray = userInfo["product_image"] as? NSArray else {return}
                    let productDic = productArray[0] as! NSDictionary
                    let productImage = productDic["product_image"] as! String
                    self.switchToToolTransction(productid: userInfo["product_id"] as! String, name: userInfo["product_name"] as! String, productImage: productImage, notificationType: notificationType, info: userInfo)
                    
                }
                else if userInfo["notification_type"] as! String == "Bid Accepted" {
                    let notificationType = userInfo["notification_type"] as! String
                    guard let productArray = userInfo["product_image"] as? NSArray else {return}
                    let productDic = productArray[0] as! NSDictionary
                    let productImage = productDic["product_image"] as! String
                    self.switchToToolTransction(productid: userInfo["product_id"] as! String, name: userInfo["product_name"] as! String, productImage: productImage, notificationType: notificationType, info: userInfo)
                    
               }
                else if userInfo["notification_type"] as! String == "Assigned Auction" {
                    let notificationType = userInfo["notification_type"] as! String
                    self.switchToToolTransction(productid: "", name: "", productImage: "", notificationType: notificationType, info: userInfo)
                    
               }
                else if userInfo["notification_type"] as! String == "Seller Rating" {
                    
                    let notificationType = userInfo["notification_type"] as! String
                    self.switchToToolTransction(productid: "", name: "", productImage: "", notificationType: notificationType, info: userInfo)
                }
                else if userInfo["notification_type"] as! String == "Question on Auction" {
                let notificationType = userInfo["notification_type"] as! String
                guard let productArray = userInfo["product_image"] as? NSArray else {return}
                let productDic = productArray[0] as! NSDictionary
                let productImage = productDic["product_image"] as! String
                self.switchToToolTransction(productid: userInfo["product_id"] as! String, name: userInfo["product_name"] as! String, productImage: productImage, notificationType: notificationType, info: userInfo)
                }
                else if userInfo["notification_type"] as! String == "Offer Notification" {
                    let notificationType = userInfo["notification_type"] as! String
                    print(notificationType)
                   self.switchToToolTransction(productid: "", name: "", productImage: "", notificationType: notificationType, info: userInfo)
                    
                }
               
                
                }
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
        self.window? = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    //MARK: - switch To Tool Transction screen
    func switchToToolTransction(productid:String,name:String,productImage:String,notificationType:String,info:[String : Any]) {
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        if notificationType == "Bid Placed" {
            let controller = storyboard.instantiateViewController(withIdentifier: "ShowAllBidVC") as! ShowAllBidVC
            
            controller.productId = productid
            controller.userImage = productImage
            controller.name = name
            openViewController(controller: controller, selectedIndex: 2)
       
        }
        else if notificationType == "Pickup Location" {
            let controller = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            controller.productDetailId = productid
//            controller.userImage = productImage
//            controller.name = name
//            controller.getNotification = "Question on Auction"
            pickUpLocation = "Pickup Location"
            openViewController(controller: controller, selectedIndex: 2)
        }
        else if notificationType == "Question on Auction" {
            let controller = storyboard.instantiateViewController(withIdentifier: "AskQuestionVC") as! AskQuestionVC
            controller.productId = productid
            controller.userImage = productImage
            controller.name = name
            controller.getNotification = "Question on Auction"
            openViewController(controller: controller, selectedIndex: 0)
        } else if notificationType == "Bid Accepted" {
            let controller = storyboard.instantiateViewController(withIdentifier: "MyAuctionVC") as! MyAuctionVC
             controller.BidAccepted = "Bid Accepted"
            appDelegate.MyAuction = "Bid Accepted"
            //controller.userImage = productImage
           // controller.name = name
            //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierFromAPNS"), object: nil)
            controller.tabIndex = 0
            openViewController(controller: controller, selectedIndex: 2)
        } else if notificationType == "Seller Rating" {
            let controller = storyboard.instantiateViewController(withIdentifier: "MyAuctionVC") as! MyAuctionVC
             controller.BidAccepted = "Bid Accepted"
            //controller.userImage = productImage
           // controller.name = name
            //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierFromAPNS"), object: nil)
            openViewController(controller: controller, selectedIndex: 2)
        }
        else if notificationType == "Offer Notification" {
            let controller = storyboard.instantiateViewController(withIdentifier: "OfferNotificationVC") as! OfferNotificationVC
                controller.userInfoDiscountNotification = info
                openViewController(controller: controller, selectedIndex: 2)
        }
        else if notificationType == "Assigned Auction" {
            let controller = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                //controller.userInfoDiscountNotification = info
                openViewController(controller: controller, selectedIndex: 0)
        }
        }
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

}

