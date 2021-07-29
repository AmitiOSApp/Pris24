////
////  UtilityClass.swift
////  ShibariStudy
////
////  Created by mac on 11/04/19.
////  Copyright © 2019 mac. All rights reserved.
////
//
import Foundation

import Alamofire

let internetConnetionError = "Please check your connection and try again."
let internetConnetionTitle = "Connection Issue"
let titleSuccsefull = "Alert"
let alert = "Alert"
let logoutTitle = "Log out"

struct AppSecureKey{
    static let APIKey       = "HmTGlpmOucnXebDayeJi5PpxIvcUVO5L"
}
struct storyBoard {
    static let PopUp = UIStoryboard.init(name: "PopUp", bundle: nil)
    static let Main = UIStoryboard.init(name: "Main", bundle: nil)
    static let ZoomTab = UIStoryboard.init(name: "Tab", bundle: nil)
    static let Setting = UIStoryboard.init(name: "Setting", bundle: nil)
    
   
}

func ShowHud()  {
//    SKActivityIndicator.spinnerStyle(.spinningHalfCircles)
//    SKActivityIndicator.show("Loading....", userInteractionStatus: true)
 //   ACProgressHUD.shared.showHUD(withStatus: "Loading...")
   // ACProgressHUD.showHUD()
}
//---------encoded--------

func HideHud()  {
 // SKActivityIndicator.dismiss()
   // ACProgressHUD.shared.hideHUD()
}
func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}
func addRightTransitionCollection(containerView:UIView){
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    containerView.layer.add(transition, forKey: kCATransition)
}
func addLeftTransitionCollection(containerView:UIView){
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    containerView.layer.add(transition, forKey: kCATransition)
}
//func addBarButtonLeftSideOnNavigationBar()
//{
//    let button = UIButton(type: .system)
//    button.setImage(UIImage(named: "Arrow_icon"), for: .normal)
//    // button.setTitle("Categories", for: .normal)
//    button.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
//    button.sizeToFit()
//    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
//}
