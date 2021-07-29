//
//  NotificationVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblNODATAFOUND:UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var tblviewNotification: UITableView!
    
//    private var titlesArray = [["title":"What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has? What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has?"],
//               ["title":"What is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has?"],
//               ["title":"CWhat is Lorem Ipsum Lorem Ipsum is simply dummy text of the printing and typesetting industry Lorem Ipsum has been the industry's standard dummy text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book it has?"]]
    
    var notificationData = [PersonalModelNotificationDatum]()
    // MARK: - Property initialization
    private var arrNotification = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Perform Notification list API
        self.tblviewNotification.estimatedRowHeight = 68.0
        self.tblviewNotification.rowHeight = UITableView.automaticDimension
        
        if  isConnectedToInternet() {
            notificationListAPI_Call()
            self.tblviewNotification.isHidden = false
            } else {
                self.tblviewNotification.isHidden = true
            self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        
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
    func changeLanguage(strLanguage:String) {
       
        self.lblTitle.text = "Notification".LocalizableString(localization: strLanguage)
        self.lblNODATAFOUND.text = "No_Record_Found".LocalizableString(localization: strLanguage)
    }
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Methods

    func notificationListAPI_Call() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
      
        let parameter: [String: Any] = [kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                                        "language": MyDefaults().language ?? "",
                                   ]
        
        print(parameter)
        HTTPService.callForPostApi(url:personalUserNotificationListAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            let response = ModelPersonalNotificationList.init(fromDictionary: response as! [String : Any])
                            
                            if response.notificationData.count > 0 {
                                self.tblviewNotification.isHidden = false
                                self.notificationData = response.notificationData
                            } else{
                                self.tblviewNotification.isHidden = true
                            }
                            
                            self.tblviewNotification.reloadData()
                        }  else if status == 500 {
                            self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        
                    }else{
                        if (MyDefaults().language ?? "") as String ==  "en"{
                            self.showErrorPopup(message: "serverNotFound".LocalizableString(localization: "en"), title: ALERTMESSAGE)
                        } else {
                            self.showErrorPopup(message: "serverNotFound".LocalizableString(localization: "da"), title: ALERTMESSAGE)
                        }
                        
                    }
                }
            }


}

// MARK: UITableViewDataSource, UITableViewDelegate
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell
        cell?.selectionStyle = .none
        //let dictPost = arrNotification[indexPath.row] as! NSDictionary
        
        cell?.lblNotificationStatus.text = self.notificationData[indexPath.row].title.capitalizingFirstLetter()
        cell?.lblNotificationMsg.text = self.notificationData[indexPath.row].notificationMsg

        let dateToday = self.convertDateFormater24format(self.notificationData[indexPath.row].createdAt)
        cell?.lblDate.text = dateToday[1] + " - " +  dateToday[0]
        
//        let dict = self.titlesArray[indexPath.row]
//        cell?.lblNotificationMsg.text = dict["title"]
        return cell!
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
