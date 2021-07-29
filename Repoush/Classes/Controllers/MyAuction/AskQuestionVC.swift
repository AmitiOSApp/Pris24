//
//  AskQuestionVC.swift
//  Repoush
//
//  Created by Apple on 02/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit


class AskQuestionVC: UIViewController {
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblNoRecordsFonund:UILabel!
    @IBOutlet weak var lblTitleNav:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var txtMessage:UITextField!
    var productId = ""
    var userImage = ""
    var name = ""
    var sellerId = ""
    var showBid = [ModelAskQuestionResponseDatum]()
    var commentReply = [ModelCommentReply]()
    var isCommentAvailbale = false
 
    var getNotification = ""
    var userInfo = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

//        if userInfo.isEmpty {
////           let productImage = userInfo["product_image"]
////           print(productImage)
////
////           let weather = userInfo["product_image"] as! [[String : AnyObject]]
//            // let imageValue = (weather as NSDictionary)?["pictureURL"] as? String ?? ""
//          //self.imgProfile.sd_setImage(with: URL(string:imageValue), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
//        }else{
//             self.imgProfile.sd_setImage(with: URL(string:userImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
//        }
//        
        // Do any additional setup after loading the view.
        self.tblView.register(UINib(nibName: "SellerHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SellerHeader")
        self.tblView.register(UINib(nibName: "BuyerHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BuyerHeaderView")
        self.tblView.register(UINib(nibName: "SellerHeaderTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "SellerHeaderTableViewCell")
        self.tblView.register(UINib(nibName: "BuyerHeaderTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "BuyerHeaderTableView")
        self.imgProfile.sd_setImage(with: URL(string:userImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
        self.lblName.text = name
        //var timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(AskQuestionVC.update), userInfo: nil, repeats: true)
        if (MyDefaults().language ?? "") as String ==  "en"{
                    self.changeLanguage(strLanguage: "en")
                } else{
                    self.changeLanguage(strLanguage: "da")
                }
        self.tblView.sectionHeaderHeight = UITableView.automaticDimension
        self.tblView.estimatedSectionHeaderHeight = 44
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.dismiss(animated: false, completion: nil)
        if  isConnectedToInternet() {
           self.callServiceGetAskQuestion()
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        
    }
    func changeLanguage(strLanguage:String) {
          
        self.lblTitleNav.text = "Questions".LocalizableString(localization: strLanguage)
        self.lblNoRecordsFonund.text = "No_Record_Found".LocalizableString(localization: strLanguage)
        self.txtMessage.placeholder = "ask_questions".LocalizableString(localization: strLanguage)
    }
    @IBAction func actionOnSend(_ sender: Any){
//        if isRequiredFieldValid() {
//
//        }
   
        if !isRequiredFieldValid() {
            if  isConnectedToInternet() {
                self.callServiceSendAskQuestion()
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
}
    
    func isRequiredFieldValid() -> Bool {
      guard let password = txtMessage.text , password != ""else {showAlert(title: ALERTMESSAGE, message: "Please enter query.")
            return true}
        
        return false
    }
    @objc func update() {
        if  isConnectedToInternet() {
           self.callServiceGetAskQuestionForTimer()
            } else {
        self.showErrorPopup(message: internetConnetionError, title: alert)
        }
    }
    func callServiceGetAskQuestion() {
                    var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
    let parameter: [String: Any] = ["product_id":productId,
    "language": MyDefaults().language ?? AnyObject.self,]
 
       
        print(parameter)
        HTTPService.callForPostApi(url:getProductCommentListAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           let response = ModelAskQuestion.init(fromDictionary: response as! [String : Any])
                           
                         if response.responseData.count > 0{
                             self.showBid = response.responseData
                             self.tblView.isHidden = false
//                            if self.showBid[0].commentReply.count > 0  {
//                                self.commentReply = response.responseData[0].commentReply
//                                self.isCommentAvailbale = true
//                            }else{
//                                self.isCommentAvailbale = false
//                            }
                            self.txtMessage.text = ""
                            self.tblView.delegate = self
                            self.tblView.dataSource = self
                            self.tblView.reloadData()
                             
                         }else{
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
    func callServiceSendAskQuestion() {
        var loading = ""
          if (MyDefaults().language ?? "") as String ==  "en"{
              loading = "Loading".LocalizableString(localization: "en")
          } else{
              loading = "Loading".LocalizableString(localization: "da")
          }
       let parameter: [String: Any] = ["product_id":productId,
                                       "language":MyDefaults().language ?? AnyObject.self,
                                       "user_id":LoggedInUser.shared.id as AnyObject,
                                       "seller_id":sellerId,
                                       "message":self.txtMessage.text!]
   
           print(parameter)
        HTTPService.callForPostApi(url:getProductCommnetAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                       debugPrint(response)
                     //  HideHud()
                       if response.count != nil {
                           let status = response["responseCode"] as! Int
                           let message = response["message"] as! String
                           if status == 200  {
                              let response = ModelShowAllBid.init(fromDictionary: response as! [String : Any])
                              
//                            if response.responseData.count > 0{
//                                self.showBid = response.responseData
//                                self.tblView.isHidden = false
//                                self.tblView.reloadData()
//
//                            }else{
//                                self.tblView.isHidden = true
//                            }
                            self.txtMessage.resignFirstResponder()
                            self.callServiceGetAskQuestion()
                            } else if status == 500 {
                                  if (MyDefaults().language ?? "") as String ==  "en"{
                                    self.showErrorPopup(message: "You_have_not_received_any_bid".LocalizableString(localization: "en"), title: ALERTMESSAGE)
                                } else{
                                    self.showErrorPopup(message: "You_have_not_received_any_bid".LocalizableString(localization: "da"), title: ALERTMESSAGE)
                                }


                            
                            }
                           }else{
                           self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                       }
                   
           }
          
       }
    func callServiceGetAskQuestionForTimer() {
                    var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
    let parameter: [String: Any] = ["product_id":productId,
    "language": MyDefaults().language ?? AnyObject.self,]
 
       
        print(parameter)
        HTTPService.callForPostApi(url:getProductCommentListAPI , parameter: parameter, authtoken: "", showHud: false, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                           let response = ModelAskQuestion.init(fromDictionary: response as! [String : Any])
                           
                         if response.responseData.count > 0{
                             self.showBid = response.responseData
                             self.tblView.isHidden = false
//                            if self.showBid[0].commentReply.count > 0  {
//                                self.commentReply = response.responseData[0].commentReply
//                                self.isCommentAvailbale = true
//                            }else{
//                                self.isCommentAvailbale = false
//                            }
                            
                            self.tblView.delegate = self
                            self.tblView.dataSource = self
                            self.tblView.reloadData()
                             
                         }else{
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
        
//       if getNotification == "Question on Auction" {
//            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.popViewController(animated: true)
//        } else{
//            self.navigationController?.popViewController(animated: true)
//        }
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension AskQuestionVC:UITableViewDelegate,UITableViewDataSource,alertDelegate,delegateReplyToBuyer,delegateEditReplyToBuyer {
    func getEditReplyToBuyer(index: Int) {
        self.dismiss(animated: true, completion: nil)
        self.showBid = [ModelAskQuestionResponseDatum]()
        self.callServiceGetAskQuestion()
    }
    func getReplyToBuyer(index: Int) {
        self.dismiss(animated: true, completion: nil)
        self.showBid = [ModelAskQuestionResponseDatum]()
        self.callServiceGetAskQuestion()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.showBid.count
    }
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if (LoggedInUser.shared.id as AnyObject) as! String == self.showBid[section].userId! {
           
            if self.showBid[section].userId! == self.showBid[section].sellerId!{
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BuyerHeaderView") as! BuyerHeaderView
                headerView.imgProfile.sd_setImage(with: URL(string:self.showBid[section].customerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                headerView.lblName.text = self.showBid[section].customerName
              //  headerView.lblMessage.numberOfLines = 0
                
                
                headerView.lblMessage.lineBreakMode = .byWordWrapping
                headerView.lblMessage.numberOfLines = 0
                headerView.lblMessage.text = self.showBid[section].message
                
                //headerView.lblDate.text = self.showBid[section].message
                let dates =    self.convertDateFormater24format(self.showBid[section].createdAt)
                headerView.lblDate.text =  dates[1] + " - " + dates[0]
              //  headerView.delegate = self
                headerView.SellerDelete.tag = section
                headerView.SellerDelete.addTarget(self, action: #selector(didTapOnBuyerHeaderViewDelete(_:)), for: .touchUpInside)
                
                headerView.BuyerForword.tag = section
                headerView.BuyerForword.addTarget(self, action: #selector(didTapOnBuyerHeaderViewForword(_:)), for: .touchUpInside)
                
                headerView.BuyerEdit.tag = section
                headerView.BuyerEdit.addTarget(self, action: #selector(didTapOnBuyerHeaderViewEdit(_:)), for: .touchUpInside)
                return headerView
            } else{
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerHeaderTableViewCell") as! SellerHeaderTableViewCell
                headerView.imgProfile.sd_setImage(with: URL(string:self.showBid[section].customerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                headerView.lblName.text = self.showBid[section].customerName
                headerView.lblMessage.text = self.showBid[section].message
              //  headerView.lblDate.text = self.showBid[section].message
                let dates =    self.convertDateFormater24format(self.showBid[section].createdAt)
                headerView.lblDate.text =  dates[1] + " - " + dates[0]
              //  headerView.delegate = self
                headerView.SellerDelete.tag = section
                headerView.SellerDelete.addTarget(self, action: #selector(didTapOnSellerDelete(_:)), for: .touchUpInside)
                
                headerView.SellerEdit.tag = section
                headerView.SellerEdit.addTarget(self, action: #selector(didTapOnSellerEdit(_:)), for: .touchUpInside)
                return headerView
            }
           
        } else {
            if self.showBid[section].userId! == self.showBid[section].sellerId!{
                
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SellerHeader") as! SellerHeader
                    headerView.imgProfile.sd_setImage(with: URL(string:self.showBid[section].customerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                    headerView.lblName.text = self.showBid[section].customerName
                    headerView.lblMessage.text = self.showBid[section].message
                   // headerView.lblDate.text = self.showBid[section].message
                    let dates =    self.convertDateFormater24format(self.showBid[section].createdAt)
                    headerView.lblDate.text =  dates[1] + " - " + dates[0]
              
                    return headerView
            
            
            
            } else{
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BuyerHeaderTableView") as! BuyerHeaderTableView
                    headerView.imgProfile.sd_setImage(with: URL(string:self.showBid[section].customerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                    headerView.lblName.text = self.showBid[section].customerName
                    headerView.lblMessage.text = self.showBid[section].message
                 //   headerView.lblDate.text = self.showBid[section].message
                    let dates =    self.convertDateFormater24format(self.showBid[section].createdAt)
                    headerView.lblDate.text =  dates[1] + " - " + dates[0]
              //  headerView.delegate = self
                    headerView.btnReplay.tag = section
                    headerView.btnReplay.addTarget(self, action: #selector(didTapOnReplay(_:)), for: .touchUpInside)
                    return headerView
                }
            }
        return UIView()
    }

//     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 80  // or whatever
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.showBid[section].commentReply.count
        
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
        print(indexPath.row)
        print(indexPath.section)
        
                    print(LoggedInUser.shared.id!)
                    print(self.showBid[indexPath.section].sellerId!)
        
              if (LoggedInUser.shared.id as AnyObject) as! String == self.showBid[indexPath.section].sellerId! {
                   
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverChatReplyTableViewCell", for: indexPath) as! ReceiverChatReplyTableViewCell
                
                if indexPath.row == 0 {
                    
                    let dates =    self.convertDateFormater24format(self.showBid[indexPath.section].commentReply[indexPath.row].createdAt)
                    cell.lblDate.text =  dates[1] + " - " + dates[0]
                    cell.lblName.text = self.showBid[indexPath.section].commentReply[indexPath.row].sellerName.capitalizingFirstLetter()
                    cell.lblMessage.text = self.showBid[indexPath.section].commentReply[indexPath.row].replyMessage.capitalizingFirstLetter()
                    cell.imgProfile.sd_setImage(with: URL(string:self.showBid[indexPath.section].commentReply[indexPath.row].sellerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                    cell.btnDelete.tag = indexPath.item
                    cell.btnDelete.addTarget(self, action: #selector(didTapOnDeleteSeller(_:)), for: .touchUpInside)
                    cell.btnEdit.tag = indexPath.item
                    cell.btnEdit.addTarget(self, action: #selector(didTapOnEdit), for: .touchUpInside)
                    cell.lblAnwserBySellerHight.constant = 21
                    cell.lblAnwserBySeller.isHidden = false
                    
                    return cell
                }  else{
                
                    let dates =    self.convertDateFormater24format(self.showBid[indexPath.section].commentReply[indexPath.row].createdAt)
                    cell.lblDate.text =  dates[1] + " - " + dates[0]
                    cell.lblName.text = self.showBid[indexPath.section].commentReply[indexPath.row].sellerName.capitalizingFirstLetter()
                    cell.lblMessage.text = self.showBid[indexPath.section].commentReply[indexPath.row].replyMessage.capitalizingFirstLetter()
                    cell.imgProfile.sd_setImage(with: URL(string:self.showBid[indexPath.section].commentReply[indexPath.row].sellerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))
                    cell.btnDelete.tag = indexPath.item
                    cell.btnDelete.addTarget(self, action: #selector(didTapOnDeleteSeller(_:)), for: .touchUpInside)
                    cell.btnEdit.tag = indexPath.item
                    cell.btnEdit.addTarget(self, action: #selector(didTapOnEdit), for: .touchUpInside)
                    cell.lblAnwserBySellerHight.constant = 0
                    cell.lblAnwserBySeller.isHidden = true
                    
                    return cell
                }
                   
                
              } else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
                        let dates =    self.convertDateFormater24format(self.showBid[indexPath.section].commentReply[indexPath.row].createdAt)
                        cell.lblDate.text =  dates[1] + " - " + dates[0]
                        cell.lblName.text = self.showBid[indexPath.section].commentReply[indexPath.row].sellerName.capitalizingFirstLetter()
                        cell.lblMessage.text = self.showBid[indexPath.section].commentReply[indexPath.row].replyMessage.capitalizingFirstLetter()
                        cell.imgProfile.sd_setImage(with: URL(string:self.showBid[indexPath.section].commentReply[indexPath.row].sellerImage), placeholderImage:#imageLiteral(resourceName: "profileuser"))

                        return cell
                   }
                }
            @objc func didTapOnEdit(_ sender: UIButton) {
       
        
           
            }
           @objc func didTapOnDeleteSeller(_ sender: UIButton) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.deleteChildReplayMessage(strLanguage: "en", Index: sender.tag)
            } else {
                self.deleteChildReplayMessage(strLanguage: "da", Index: sender.tag)
            }
        }
        @objc func didTapOnDelete(_ sender: UIButton) {
            let alertController = UIAlertController(title: "Delete Questions ?", message:"Are you sure you want to delete questions ?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.callServiceDeleteQuestion(index: sender.tag)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
          self.present(alertController, animated: true, completion: nil)
    }
  
    @objc func didTapOnBuyerHeaderViewDelete(_ sender: UIButton) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguageAlertView(strLanguage: "en", Index: sender.tag)
        } else {
            self.changeLanguageAlertView(strLanguage: "da", Index: sender.tag)
        }
    }
    @objc func didTapOnBuyerHeaderViewForword(_ sender: UIButton) {
        self.popUpReplyToBuyer(isAnimated: true, index: sender.tag)
   }
    @objc func didTapOnBuyerHeaderViewEdit(_ sender: UIButton) {
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : EditReplyPopUpVC = pop.instantiateViewController(withIdentifier: "EditReplyPopUpVC") as! EditReplyPopUpVC
        popup.productId = self.showBid[sender.tag].productId
        popup.commnetId = self.showBid[sender.tag].id
        popup.editText = self.showBid[sender.tag].message
        popup.Index = sender.tag
        popup.delegate = self
       self.presentOnRoot(with: popup, isAnimated: true)
    }
    @objc func didTapOnReplay(_ sender: UIButton) {
        self.popUpReplyToBuyer(isAnimated: true, index: sender.tag)
    }
    func popUpReplyToBuyer(isAnimated:Bool,index:Int) {
         let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : ReplyToBuyerPopUpVC = pop.instantiateViewController(withIdentifier: "ReplyToBuyerPopUpVC") as! ReplyToBuyerPopUpVC
        popup.productId = self.showBid[index].productId
         popup.sellerId = self.showBid[index].sellerId
         popup.Index = index
         popup.delegate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
    @objc func didTapOnSellerDelete(_ sender: UIButton) {
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguageAlertView(strLanguage: "en", Index: sender.tag)
            } else{
                self.changeLanguageAlertView(strLanguage: "da", Index: sender.tag)
        }
    }
    @objc func didTapOnSellerEdit(_ sender: UIButton) {
        
    }
    func showMessage(index:Int,Message: String) {
       
    }
    func okAction(controller: UIViewController, index: Int) {
       
    // self.CallServiceUnJoinMeetingAPI(index:index)
    }
    func cancelAction(controller: UIViewController) {
       //  self.dismiss(animated: true, completion: nil)
    }
    func callServiceDeleteQuestion(index:Int) {
     
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        
        let parameter: [String: Any] = ["id":self.showBid[index].id!,
                                        "language": MyDefaults().language ?? AnyObject.self]

        print(parameter)
        HTTPService.callForPostApi(url:getDeleteCommentAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            
                           
                            if (MyDefaults().language ?? "") as String ==  "en"{
                            self.deleteSuccfully(index: index, title: "Delete_Questions".LocalizableString(localization: "en"), message: message)
                            } else {
                            self.deleteSuccfully(index: index, title: "Delete_Questions".LocalizableString(localization: "da"), message: message)
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
    func deleteSuccfully(index:Int,title:String,message:String)  {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.showBid.remove(at: index)
            if self.showBid.count == 0 {
                self.tblView.isHidden = true
            } else{
                
            }
            self.tblView.reloadData()
            
        }
         alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func deleteChildSuccfully(index:Int,title:String,message:String)  {
        let alertController = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
//            self.showBid.remove(at: index)
//            if self.showBid.count == 0 {
//                self.tblView.isHidden = true
//            } else{
//
//            }
            
            self.callServiceGetAskQuestion()
          //  self.tblView.reloadData()
            
        }
         alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func changeLanguageAlertView(strLanguage:String,Index:Int) {
        let alertController = UIAlertController(title: "Delete_Questions".LocalizableString(localization: strLanguage), message:"Are_You_Want_To_Delete".LocalizableString(localization: strLanguage), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.callServiceDeleteQuestion(index: Index)
        }
          let cancelAction = UIAlertAction(title: "Report_Cancel".LocalizableString(localization: strLanguage), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func deleteChildReplayMessage(strLanguage:String,Index:Int) {
        let alertController = UIAlertController(title: "Delete_Questions".LocalizableString(localization: strLanguage), message:"Are_You_Want_To_Delete".LocalizableString(localization: strLanguage), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.callServiceDeleteQuestionChild(index: Index)
        }
          let cancelAction = UIAlertAction(title: "Report_Cancel".LocalizableString(localization: strLanguage), style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func callServiceDeleteQuestionChild(index:Int) {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        
        let parameter: [String: Any] = ["id":self.showBid[index].commentReply[index].id!,
                                        "language": MyDefaults().language ?? AnyObject.self]

        print(parameter)
        HTTPService.callForPostApi(url:getDeleteCommentAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                             
                            
                            self.deleteChildSuccfully(index: index, title: "Delete Questions ?", message: message)
                            } else if status == 500 {
                               self.tblView.isHidden = true
                               //self.NORECORDFOUND.isHidden = false
                            }
                        }else{
                        self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
       
    }
}
//extension AskQuestionVC: CustomHeaderDelegate {
//    func customHeader(_ customHeader: CustomHeader, didTapButtonInSection section: Int) {
//        print("did tap button", section)
//    }
//}
class SenderChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnEdit : UIButton!
    
   }
class ReceiverChatReplyTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblAnwserBySeller : UILabel!
    @IBOutlet weak var lblAnwserBySellerHight : NSLayoutConstraint!
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var btnEdit : UIButton!
   
}
class AnwserBySellerTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAnwserBySeller : UILabel!
    
   
}
