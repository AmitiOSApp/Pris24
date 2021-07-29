//
//  DiscountNotifiationVC.swift
//  Repoush
//
//  Created by Apple on 03/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class DiscountNotifiationVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblReceived:UILabel!
    @IBOutlet weak var lblNodatFound:UILabel!
    var receivedNotification = [ModelReceivesdOfferList]()
    var isCommentAvailbale = false
    var userInfo = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  isConnectedToInternet() {
            self.callServiceGetNotification(type: "2")
            } else {
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
       self.lblReceived.text = "Received".LocalizableString(localization: strLanguage)
        self.lblTitle.text = "Discount_Notifications".LocalizableString(localization: strLanguage)
        self.lblNodatFound.text = "Notification_NoDatafound".LocalizableString(localization: strLanguage)
    }
    func callServiceGetNotification(type:String) {
        var loading = ""
      if (MyDefaults().language ?? "") as String ==  "en"{
          loading = "Loading".LocalizableString(localization: "en")
      } else{
          loading = "Loading".LocalizableString(localization: "da")
      }
    let parameter: [String: Any] = ["user_id":LoggedInUser.shared.id!,
                                    "type":type,
                                    "language":MyDefaults().language ?? AnyObject.self]
        print(parameter)
        HTTPService.callForPostApi(url:getOfferList , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
            print(type)
            if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            
                                let response = ModelReceivedNotification.init(fromDictionary: response as! [String : Any])
                                if response.offerList.count > 0 {
                                    self.receivedNotification = response.offerList
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                } else{
                                    self.tblView.isHidden = true
                                }
                             
                            } else if status == 500 {
                               self.tblView.isHidden = true
                               //self.NORECORDFOUND.isHidden = false
                        }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
      }
   
 
    
    @IBAction func actionOnback(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiscountNotifiationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivedNotification.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedTableViewCell", for: indexPath) as! ReceivedTableViewCell
            let dates =    self.convertDateFormater24format(self.receivedNotification[indexPath.row].createdAt)
                cell.lblDate.text =  dates[1] + " - " + dates[0]
               // cell.lblAnswerBySeller.text = "Answer By Seller"
            cell.lblNotification.text = self.receivedNotification[indexPath.row].title
            cell.lblNotifcationMessage.text = self.receivedNotification[indexPath.row].notificationMsg
            cell.btnViewRecepientsList.tag = indexPath.row
            cell.btnViewRecepientsList.addTarget(self, action: #selector(viewDetails(_:)), for: .touchUpInside)
                               
        if (MyDefaults().language ?? "") as String ==  "en"{
            
            cell.btnViewRecepientsList.setTitle("ViewDetails".LocalizableString(localization: "en"), for: .normal)
            
        } else{
            cell.btnViewRecepientsList.setTitle("ViewDetails".LocalizableString(localization: "da"), for: .normal)
        }
       
        return cell
        
        
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let vc = Util.loadViewController(fromStoryboard: "PriviewPageVC", storyboardName: "Home") as? PriviewPageVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
            aVc.webUrl = self.createUrlPage(index: indexPath.row)
               
                print(aVc.webUrl)
                show(aVc, sender: nil)
            
            
        }
    }
    func createUrlPage(index:Int) -> String {
     let stringUrl =         "\(getReceivedNotificationTemplate)&buyer_name=\(self.receivedNotification[index].buyerName!)&seller_name=\(self.receivedNotification[index].sellerName!)&discount_percantage=\(self.receivedNotification[index].discountPercentage!)&item_name=\(self.receivedNotification[index].itemName!)&store_address=\(self.receivedNotification[index].storeAddress!)&valid_until=\(self.receivedNotification[index].validUntil!)&start_time=\(self.receivedNotification[index].startTime!)&end_time=\(self.receivedNotification[index].endTime!)"
            let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            return escapedString!
   
    }
    @objc func viewDetails(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "PriviewPageVC", storyboardName: "Home") as? PriviewPageVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            aVc.webUrl = self.createUrlPage(index: sender.tag)
           
            print(aVc.webUrl)
            show(aVc, sender: nil)
        }
        
    }
}

