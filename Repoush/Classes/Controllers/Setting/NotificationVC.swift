//
//  NotificationVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/1/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblviewNotification: UITableView!
    
    // MARK: - Property initialization
    private var arrNotification = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Perform Notification list API
        notificationListAPI_Call()
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Methods
    private func notificationListAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId : LoggedInUser.shared.id as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getNotificationList(postParams), callerObj: self, showHud: true) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["notification_data"].arrayObject != nil {
                let arrTemp = jsonObj["notification_data"].arrayObject! as NSArray
                self?.arrNotification = NSMutableArray(array: arrTemp)
            }
            
            DispatchQueue.main.async {
                self?.tblviewNotification.reloadData()
            }
        }
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationCell
        cell?.selectionStyle = .none
        
        let dictPost = arrNotification[indexPath.row] as! NSDictionary

        cell?.lblNotificationStatus.text = dictPost["title"] as? String
        cell?.lblNotificationMsg.text = dictPost["notification_msg"] as? String

        var createdDate = ""
        
        if let temp = dictPost["created_at"] as? String {
            let tempDate = Util.getDateFromString(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "yyyy-MM-dd HH:mm:ss.SSS")

            createdDate = Util.relativeDateStringForDate(tempDate)

            if createdDate != "Just now" {
                createdDate = "\(createdDate) ago"
            }
        }
        cell?.lblDate.text = createdDate
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
