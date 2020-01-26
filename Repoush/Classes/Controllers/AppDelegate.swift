//
//  AppDelegate.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/22/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let reachability = try! Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initMyApp(launchOptions)
        
        // Configure IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // Setup Network status
        setupReachability(nil, useClosures: false)
        startNotifier()
        
        // Setup global navigation
        let backButtonImage = UIImage(named: "icon_back_gray3")
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -100000, vertical: 5000), for: .default)
        
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 17), .foregroundColor : UIColor.black]
        UINavigationBar.appearance().tintColor = UIColor.darkGray
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        return true
    }

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
    func showLoader(_ viewController: UIViewController) {
        
        let window = UIApplication.shared.keyWindow!
        
        let bgView = UIView(frame: window.bounds)
        
        bgView.tag = 10000001
        bgView.frame = CGRect.init(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        viewController.view.addSubview(bgView)
        
        window.addSubview(bgView)
        window.backgroundColor = UIColor.white
        
        let centerView = UIView()
        
        centerView.frame = CGRect.init(x: bgView.frame.width / 2 - 22, y: bgView.frame.height / 2 - 22, width: 44, height: 44)
        centerView.backgroundColor = UIColor.white
        centerView.layer.cornerRadius = 22
        
        // shadow
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        centerView.layer.shadowOpacity = 0.7
        centerView.layer.shadowRadius = 5.0
        
        bgView.addSubview(centerView)
        
        let loadingGroup = STLoadingGroup(side: 20.0, style: .submit)
        loadingGroup.show(bgView)
        loadingGroup.startLoading()
    }
    
    func hideLoader(_ viewController: UIViewController) {
        let window = UIApplication.shared.keyWindow!
        window.backgroundColor = UIColor.white
        for subview in window.subviews {
            if subview.tag == 10000001 {
                subview.backgroundColor = UIColor.white.withAlphaComponent(1.0)
                subview.removeFromSuperview()
            }
        }
    }

}

