//
//  TabBarVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
protocol CustomTabBarControllerDelegate {
    func onTabSelected(isTheSame: Bool)
}

class TabBarVC: UITabBarController, UITabBarControllerDelegate,getUserAppear,gestuserLogin {
    // MARK: - IBOutlets
    
    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        self.tabBarController?.delegate = self
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeTabbarItem(strLanguage: "en")
        } else{
            self.changeTabbarItem(strLanguage: "da")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.blue,NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 11)!], for: .normal)
//
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red,NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 11)!], for: .selected)
        self.tabBarController?.delegate = self
    }
    func showGuestUser(index:Int,Message: String,title:String,okay:String,cancel:String,isPlaceBid:Bool) {
        let commonAlert = GuestUserAlertViewController()
        commonAlert.delegate = self
        commonAlert.index = index
        commonAlert.isLoginByPlaceBid = true
        commonAlert.ShowAlertWhenUserNotExist(title: title, message: Message, vc: self, Okay: okay, Cancel: cancel)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let items = tabBar.items else { return }

        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeTabbarItem(strLanguage: "en")
        } else{
            self.changeTabbarItem(strLanguage: "da")
        }
    }
//    override func viewWillLayoutSubviews() {
//        var tabFrame = self.tabBar.frame
//        // - 40 is editable , the default value is 49 px, below lowers the tabbar and above increases the tab bar size
//        tabFrame.size.height = 40
//        tabFrame.origin.y = self.view.frame.size.height - 40
//        self.tabBar.frame = tabFrame
//
//
//    }
//    override func viewWillLayoutSubviews() {
//        // acess to list of tab bar items
//        if let items = self.tabBar.items {
//            // in each item we have a view where we find 2 subviews imageview and label
//            // in this example i would like to change
//            // access to item view
//            let viewTabBar = items[2].value(forKey: "view") as? UIView
//            // access to item subviews : imageview and label
//            if viewTabBar?.subviews.count == 2 {
//                let label = viewTabBar?.subviews[1]as? UILabel
//                // here is the customization for my label 2 lines
//                label?.numberOfLines = 2
//                label?.textAlignment = .center
//                label!.text = "tabbbab babbbbbb"
//                // here customisation for image insets top and bottom
//                items[2].imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -5, right: 0)
//            }
//        }
//    }
//    override func viewWillLayoutSubviews() {
//        // acess to list of tab bar items
//              if let items = self.tabBar.items {
//              // in each item we have a view where we find 2 subviews imageview and label
//              // in this example i would like to change
//                   // access to item view
//                  let viewTabBar = items[2].value(forKey: "view") as? UIView
//                // access to item subviews : imageview and label
//                if viewTabBar?.subviews.count == 2 {
//                    let label = viewTabBar?.subviews[1]as? UILabel
//                  // here is the customization for my label 2 lines
//                    label?.numberOfLines = 2
//                    label?.textAlignment = .center
//                    label!.text = "tab_point"
//                    // here customisation for image insets top and bottom
//                    items[2].imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -5, right: 0)
//                    }
//                    }
//
//          }
    
    // MARK: - UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        appDelegate.MyAuction = ""
        appDelegate.IntCameraTag = 0
        let itemIndex = (tabBar.items?.firstIndex(of: item))
   print(item)
        if LoggedInUser.shared.id != nil {
            if itemIndex == 0 {
                
           //     NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierChnageLanguage"), object: nil)
            
            } else if itemIndex == 1 {
                
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifierSwitchUser"), object: nil)
                
                }
            
        } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.showGuestUser(index: itemIndex ?? 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: true)
            } else{
                self.showGuestUser(index: itemIndex ?? 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: true)
            }
        }
   
    
    
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller")

        //(viewController as? CustomTabBarControllerDelegate)?.onTabSelected(isTheSame: selectedViewController == viewController)
       
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeTabbarItem(strLanguage: "en")
        } else{
            self.changeTabbarItem(strLanguage: "da")
        }
        
    }
    func changeTabbarItem(strLanguage:String) {
        tabBar.items![0].title = "HOME".LocalizableString(localization: strLanguage)
        tabBar.items![1].title = "NEW AUCTION".LocalizableString(localization: strLanguage)
        tabBar.items![2].title = "MY AUCTIONS".LocalizableString(localization: strLanguage)
        tabBar.items![3].title = "SETTINGS".LocalizableString(localization: strLanguage)
        tabBar.items![4].title = "PROFILE".LocalizableString(localization: strLanguage)
        }
    func GetgusetUserAppear(controller: UIViewController, index: Int, isLoginByPlaceBid: Bool) {
        
        let pop = UIStoryboard.init(name: "Main", bundle: nil)
        let popup : LoginVC = pop.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        popup.isGuestUserLogin = true
        popup.index = index
        popup.isPlaceBid = isLoginByPlaceBid
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
   
    }
    
    func cancelGuestUser(controller: UIViewController) {
//        self.navigationController?.popViewController(animated: true)
//        self.tabBarController?.selectedIndex = 0
//        self.navigationController?.popToRootViewController(animated: true)
//        self.tabBarController?.selectedIndex = 0
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let signInVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        let nav = UINavigationController(rootViewController:signInVC)
//      //  nav.navigationController?.navigationBar.isHidden = true
//        nav.setNavigationBarHidden(true, animated: true)
//        let application = UIApplication.shared.delegate as! AppDelegate
//        application.window!.rootViewController = nav
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        let navigationController = UINavigationController(rootViewController: newViewController)
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window!.rootViewController = navigationController
        
               // self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
        
    }
    func getDelegateGuestUserLogin(index: Int, isPlaceBid: Bool) {
       print(index)
        if index == 1 {
            
            let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
            if let aVc = vc {
               // self?.present(aVc, animated: true)
                aVc.selectedIndex = 1
                self.navigationController?.pushViewController(aVc, animated: true)
            }
            
        } else if index == 2 {
            let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
            if let aVc = vc {
               // self?.present(aVc, animated: true)
                aVc.selectedIndex = 2
                self.navigationController?.pushViewController(aVc, animated: true)
            }
        } else if index == 3 {
            let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
            if let aVc = vc {
               // self?.present(aVc, animated: true)
                aVc.selectedIndex = 3
                self.navigationController?.pushViewController(aVc, animated: true)
            }
        } else if index == 4 {
            let vc = Util.loadViewController(fromStoryboard: "TabBarVC", storyboardName: "Home") as? TabBarVC
            if let aVc = vc {
               // self?.present(aVc, animated: true)
                aVc.selectedIndex = 4
                self.navigationController?.pushViewController(aVc, animated: true)
            }
        }
    }
    
}
