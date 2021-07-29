//
//  ProfileContainerVC.swift
//  Repoush
//
//  Created by Apple on 08/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProfileContainerVC: UIViewController,getSelectMapCoordinate {
    @IBOutlet weak var txtSearch : UITextField!
    weak var currentViewController: UIViewController?
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.hexStringToUIColor(hex: "#02BBCA"), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:tabBar.frame.height), lineHeight: 2.0)
        // Do any additional setup after loading the view.
        self.txtSearch.addTarget(self, action: #selector(setDiscount), for: .editingChanged)
        
        if LoggedInUser.shared.UserRole == "1" {
           
            self.currentViewController = Util.loadViewController(fromStoryboard: "ProfileVC", storyboardName: "Home") as? ProfileVC
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
        } else{
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
            self.currentViewController = Util.loadViewController(fromStoryboard: "ProfessionalVC", storyboardName: "Home") as? ProfessionalVC
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(self.currentViewController!)
            self.addSubview(subView: self.currentViewController!.view, toView: self.containerView)
        }
    }
    func changeLanguage(strLanguage:String) {
        self.txtSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
        }
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        self.popUpFilter(isAnimated: true)
    }
    func popUpFilter(isAnimated:Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        // popup.data = response
         // popup.isCategory = true
         popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
    @objc func setDiscount(textField: UITextField) {
        self.tabBarController?.selectedIndex = 0
    }
    func delegatSelectCodinateofMap(latitude: String, longitude: String, distance: String, isMapSelected: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.selectedIndex = 0
        NotificationCenter.default.post(name: Notification.Name("ProfileContainernotification"), object: nil)
    }
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
}

