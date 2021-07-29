//
//  ProfessionalDiscountNotificationVC.swift
//  Repoush
//
//  Created by Apple on 10/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProfessionalDiscountNotificationVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnSent:UIButton!
    @IBOutlet weak var btnReceived:UIButton!
    @IBOutlet weak var lblNoDataFound:UILabel!
   // @IBOutlet weak var lblReceived:UILabel!
    @IBOutlet weak var constraintLeadingSlideLable : NSLayoutConstraint!
    var isSelectedSent = true
    var sentNotification = [ModelOfferList]()
    var receivedNotification = [ModelReceivesdOfferList]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.isSeleteduser(isSent: true)
        if  isConnectedToInternet() {
            self.callServiceGetNotification(type: "1")
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        
    }
    func changeLanguage(strLanguage:String) {
            
        self.lblNoDataFound.text = "Notification_NoDatafound".LocalizableString(localization: strLanguage)
        self.btnSent.setTitle("Sent".LocalizableString(localization: strLanguage), for: .normal)
        self.btnReceived.setTitle("Received".LocalizableString(localization: strLanguage), for: .normal)
        }
    func isSeleteduser(isSent:Bool)  {
        if isSent == true {
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnSent.frame.origin.x
               // self.personal = [ModelHomePersonalResponseDatum]()
                self.view.layoutIfNeeded()
                self.isSelectedSent = true
                if  isConnectedToInternet() {
                self.callServiceGetNotification(type: "1")
                } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
                }
            }
            }else{
                
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnReceived.frame.origin.x
                //self.professional = [ModelProfessionalResponseDatum]()
                self.view.layoutIfNeeded()
                self.isSelectedSent = false
                if  isConnectedToInternet() {
                    self.callServiceGetNotification(type: "2")
                    } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
                }
                
            }
           
        }
    }
    @IBAction func actionOnSent(_ Sender:UIButton){
        if !self.btnSent.isSelected {
            self.btnSent.isSelected = true
            self.btnReceived.isSelected = false
            self.btnSent.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnReceived.setTitleColor(UIColor.hexStringToUIColor(hex: "#313D4E"), for: .normal)
        }else{
            self.btnSent.isSelected = true
            self.btnReceived.isSelected = false
            self.btnSent.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnReceived.setTitleColor(UIColor.hexStringToUIColor(hex: "#313D4E"), for: .normal)
            
        }
        

        self.isSeleteduser(isSent: true)
    }
        @IBAction func actionOnReceived(_ Sender:UIButton) {
            if !self.btnReceived.isSelected {
                self.btnReceived.isSelected = true
                self.btnSent.isSelected = false
                self.btnReceived.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                self.btnSent.setTitleColor(UIColor.hexStringToUIColor(hex: "#313D4E"), for: .normal)
            }else{
                self.btnReceived.isSelected = true
                self.btnSent.isSelected = false
                self.btnReceived.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                self.btnSent.setTitleColor(UIColor.hexStringToUIColor(hex: "#313D4E"), for: .normal)
                
            }
            self.isSeleteduser(isSent: false)

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
                            if self.isSelectedSent == true {
                                let response = ModelSentNotificationList.init(fromDictionary: response as! [String : Any])
                                if response.offerList.count > 0 {
                                    self.sentNotification = response.offerList
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                } else{
                                    self.tblView.isHidden = true
                                }
                            } else{
                                
                                let response = ModelReceivedNotification.init(fromDictionary: response as! [String : Any])
                                if response.offerList.count > 0 {
                                    self.receivedNotification = response.offerList
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                } else{
                                    self.tblView.isHidden = true
                                }
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
extension ProfessionalDiscountNotificationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isSelectedSent {
            return self.receivedNotification.count
        } else {
            return self.sentNotification.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isSelectedSent == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentTableViewCell", for: indexPath) as! SentTableViewCell
            let dates =    self.convertDateFormater24format(self.sentNotification[indexPath.row].createdAt)
                cell.lblDate.text =  dates[1] + " - " + dates[0]
               // cell.lblAnswerBySeller.text = "Answer By Seller"
            cell.lblNotification.text = self.sentNotification[indexPath.row].title
            cell.lblNotifcationMessage.text = self.sentNotification[indexPath.row].notificationMsg
            cell.btnViewRecepientsList.tag = indexPath.row
            cell.btnViewRecepientsList.addTarget(self, action: #selector(recepientsList(_:)), for: .touchUpInside)
            if (MyDefaults().language ?? "") as String ==  "en"{
                cell.btnViewRecepientsList.setTitle("View_Recipients_List".LocalizableString(localization: "en"), for: .normal)
            } else{
                cell.btnViewRecepientsList.setTitle("View_Recipients_List".LocalizableString(localization: "da"), for: .normal)
            }
            
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedTableViewCell", for: indexPath) as! ReceivedTableViewCell
            let dates =    self.convertDateFormater24format(self.receivedNotification[indexPath.row].createdAt)
                cell.lblDate.text =  dates[1] + " - " + dates[0]
               // cell.lblAnswerBySeller.text = "Answer By Seller"
            cell.lblNotification.text = self.receivedNotification[indexPath.row].title
            cell.lblNotifcationMessage.text = self.receivedNotification[indexPath.row].notificationMsg
            cell.btnViewRecepientsList.tag = indexPath.row
            cell.btnViewRecepientsList.addTarget(self, action: #selector(viewDetails(_:)), for: .touchUpInside)
            if (MyDefaults().language ?? "") as String ==  "en"{
                cell.btnViewRecepientsList.setTitle("View_Recipients_List".LocalizableString(localization: "en"), for: .normal)
            } else{
                cell.btnViewRecepientsList.setTitle("View_Recipients_List".LocalizableString(localization: "da"), for: .normal)
            }
            
            return cell
        }
        
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
        if self.isSelectedSent {
            let vc = Util.loadViewController(fromStoryboard: "PriviewPageVC", storyboardName: "Home") as? PriviewPageVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
            aVc.webUrl = self.createUrlPage(index: indexPath.row)
               
                print(aVc.webUrl)
                show(aVc, sender: nil)
            }
        } else {
            let vc = Util.loadViewController(fromStoryboard: "PriviewPageVC", storyboardName: "Home") as? PriviewPageVC
            if let aVc = vc {
                aVc.hidesBottomBarWhenPushed = true
            aVc.webUrl = self.createUrlPage(index: indexPath.row)
               
                print(aVc.webUrl)
                show(aVc, sender: nil)
            }
            
        }
    }
    func createUrlPage(index:Int) -> String {
     
        if isSelectedSent == true {
//            let firstName = LoggedInUser.shared.firstName as AnyObject
//            let lastName = LoggedInUser.shared.lastName as AnyObject
//            let fullName = "\(firstName) \(lastName)"
           
            let stringUrl =         "\(getsentTNotificationTemplate)&buyer_name=\(self.sentNotification[index].buyerName!)&seller_name=\(self.sentNotification[index].sellerName!)&discount_percantage=\(self.sentNotification[index].discountPercentage!)&item_name=\(self.sentNotification[index].itemName!)&store_address=\(self.sentNotification[index].storeAddress!)&valid_until=\(self.sentNotification[index].validUntil!)&start_time=\(self.sentNotification[index].startTime!)&end_time=\(self.sentNotification[index].endTime!)"
            let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            
            
            return escapedString!
        } else {
//            let firstName = LoggedInUser.shared.firstName as AnyObject
//            let lastName = LoggedInUser.shared.lastName as AnyObject
//            let fullName = "\(firstName) \(lastName)"
           
            let stringUrl =         "\(getReceivedNotificationTemplate)&buyer_name=\(self.receivedNotification[index].buyerName!)&seller_name=\(self.receivedNotification[index].sellerName!)&discount_percantage=\(self.receivedNotification[index].discountPercentage!)&item_name=\(self.receivedNotification[index].itemName!)&store_address=\(self.receivedNotification[index].storeAddress!)&valid_until=\(self.receivedNotification[index].validUntil!)&start_time=\(self.receivedNotification[index].startTime!)&end_time=\(self.receivedNotification[index].endTime!)"
            let escapedString = stringUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            return escapedString!
        }
        
        
       // return urlString
    }
    @objc func recepientsList(_ sender: UIButton) {
        let vc = Util.loadViewController(fromStoryboard: "ViewRecipientsListVC", storyboardName: "Home") as? ViewRecipientsListVC
        if let aVc = vc {
            aVc.hidesBottomBarWhenPushed = true
            aVc.productId = self.sentNotification[sender.tag].productId!
            show(aVc, sender: nil)
                       }
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

class SentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNotification :UILabel!
    @IBOutlet weak var lblNotifcationMessage :UILabel!
    @IBOutlet weak var lblDate :UILabel!
    @IBOutlet weak var btnViewRecepientsList :UIButton!
}
class ReceivedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblNotification :UILabel!
    @IBOutlet weak var lblNotifcationMessage :UILabel!
    @IBOutlet weak var lblDate :UILabel!
    @IBOutlet weak var btnViewRecepientsList :UIButton!
   
}

