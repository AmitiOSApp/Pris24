//
//  QuestionVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/19/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class QuestionVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var tblviewQuestion: UITableView!
    @IBOutlet weak var txvQuestion: UITextView!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewUpdateComment: UIView!
    @IBOutlet weak var txvUpdateComment: UITextView!
    @IBOutlet weak var lblHeader: UILabel!

    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    private var arrQuestion = NSMutableArray()
    private var replyAction = 1
    private var dictData = NSDictionary()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblviewQuestion.rowHeight = UITableView.automaticDimension
        tblviewQuestion.estimatedRowHeight = 50
        
        setProductDetail()
        
        // Perform Get product comment API
        productCommentListAPI_Call()
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancel_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewUpdateComment.isHidden = true
    }
    
    @IBAction func btnSend_Action(_ sender: UIButton) {
        if !Util.isValidString(txvQuestion.text) {
            Util.showAlertWithMessage("Please enter something", title: ""); return
        }
        // Perform Send product comment API
        sendProductCommentAPI_Call()
    }
    
    @IBAction func btnUpdateComment_Action(_ sender: UIButton) {
        if !Util.isValidString(txvUpdateComment.text) {
            Util.showAlertWithMessage("Please enter something", title: ""); return
        }
        
        if replyAction == 1 {
            productCommentUpdateAPI_Call()
        }
        else if replyAction == 2 {
            productCommentReplyAPI_Call()
        }
        else if replyAction == 3 {
            productCommentReplyUpdateAPI_Call()
        }
    }
    
    // MARK: - Private Methods
    private func setProductDetail() {
        
        lblProductName.text = dictProduct["selling"] as? String
        
        var arrProductImage = NSMutableArray()
        
        if let arrTemp = dictProduct["product_image"] as? NSArray {
            arrProductImage = NSMutableArray(array: arrTemp)
        }
        
        if arrProductImage.count > 0 {
            let dictProductImage = arrProductImage[0] as? NSDictionary
            
            if Util.isValidString(dictProductImage!["product_image"] as! String) {
                
                let imageUrl = dictProductImage!["product_image"] as! String
                
                let url = URL.init(string: imageUrl)
                
                imgviewProduct.kf.indicatorType = .activity
                imgviewProduct.kf.indicator?.startAnimatingView()
                
                let resource = ImageResource(downloadURL: url!)
                
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        self.imgviewProduct.image = value.image
                    case .failure( _):
                        self.imgviewProduct.image = UIImage(named: "dummy_post")
                    }
                    self.imgviewProduct.kf.indicator?.stopAnimatingView()
                }
            }
            else {
                imgviewProduct.image = UIImage(named: "dummy_post")
            }
        }
    }

    // MARK: - API Methods
    private func sendProductCommentAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_SellerId   : dictProduct["user_id"] as AnyObject,
                kAPI_Message    : txvQuestion.text as AnyObject,
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.productComment(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.txvQuestion.text = ""
            }
            self.productCommentListAPI_Call()
        }
    }

    private func productCommentReplyAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_CommentId    : dictData["id"] as AnyObject,
                kAPI_ReplyMessage : txvUpdateComment.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.productCommentReply(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.viewBG.isHidden = true
                self.viewUpdateComment.isHidden = true
                self.txvUpdateComment.text = ""
            }
            self.productCommentListAPI_Call()
        }
    }

    private func productCommentListAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.productCommentList(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["responseData"].arrayObject != nil {
                let arrTemp = jsonObj["responseData"].arrayObject! as NSArray
                self.arrQuestion = NSMutableArray(array: arrTemp)
            }
            
            DispatchQueue.main.async {
                self.tblviewQuestion.reloadData()
            }
        }
    }
    
    private func productCommentUpdateAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_CommentId  : dictData["id"] as AnyObject,
                kAPI_Message    : txvUpdateComment.text as AnyObject,
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.productCommentUpdate(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.viewBG.isHidden = true
                self.viewUpdateComment.isHidden = true
                self.txvUpdateComment.text = ""
            }
            self.productCommentListAPI_Call()
        }
    }

    private func deleteProductCommentAPI_Call(_ dictTemp: NSDictionary) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_CommentId  : dictTemp["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.deleteProductComment(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            self.productCommentListAPI_Call()
        }
    }
    
    private func productCommentReplyUpdateAPI_Call() {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        // id,reply_message
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Id           : dictData["id"] as AnyObject,
                kAPI_ReplyMessage : txvUpdateComment.text as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.productCommentReplyUpdate(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                self.viewBG.isHidden = true
                self.viewUpdateComment.isHidden = true
                self.txvUpdateComment.text = ""
            }
            self.productCommentListAPI_Call()
        }
    }

    private func deleteProductCommentReplyAPI_Call(_ dictTemp: NSDictionary) {
        
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_Id : dictTemp["id"] as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.deleteProductReplyComment(postParams), callerObj: self, showHud: true) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            self.productCommentListAPI_Call()
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension QuestionVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrQuestion.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictQuestion = arrQuestion[section] as? NSDictionary
        if let arrTemp = dictQuestion!["comment_reply"] as? NSArray {
            return arrTemp.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dictQuestion = arrQuestion[section] as? NSDictionary

        var sectionHeight = 50.0
        if let arrTemp = dictQuestion!["comment_reply"] as? NSArray {
            if arrTemp.count > 0 {
                sectionHeight = sectionHeight + 15
            }
        }
        let messageHgt = (dictQuestion!["message"] as? String)?.height(ScreenSize.width - 85, font: UIFont(name: AppFontRegular, size: 12.0)!)
        
        sectionHeight = sectionHeight + Double(messageHgt ?? 0.0)

        return CGFloat(sectionHeight)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as! QuestionCell
        
        // headerCell.backgroundColor = .red
        
        headerCell.lblAnswerBySeller.isHidden = true
        headerCell.lblAnswerBySeller.text = ""
        
        let dictQuestion = arrQuestion[section] as? NSDictionary
        
        if let arrTemp = dictQuestion!["comment_reply"] as? NSArray {
            if arrTemp.count > 0 {
                headerCell.lblAnswerBySeller.isHidden = false
                headerCell.lblAnswerBySeller.text = "Answer By Seller"
            }
        }

        headerCell.editHandler = {
            
            self.replyAction = 1
            
            self.dictData = self.arrQuestion[section] as! NSDictionary
            
            self.txvUpdateComment.text = self.dictData["message"] as? String
            self.lblHeader.text = "Update Comment"
            
            self.viewBG.isHidden = false
            self.viewUpdateComment.isHidden = false
        }
        
        headerCell.deleteHandler = {
            let uiAlert = UIAlertController(title: "", message: "Are you sure you want to delete questions??", preferredStyle:UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "No".localiz(), style: .default, handler: { action in }))

            uiAlert.addAction(UIAlertAction(title: "YES".localiz(), style: .default, handler: { action in
                
                let dictTemp = self.arrQuestion[section] as! NSDictionary
                self.deleteProductCommentAPI_Call(dictTemp)
            }))
        }

        headerCell.replyHandler = {
            
            self.replyAction = 2

            self.dictData = self.arrQuestion[section] as! NSDictionary

            self.lblHeader.text = "Reply To Buyer"
            self.txvUpdateComment.text = ""
            
            self.viewBG.isHidden = false
            self.viewUpdateComment.isHidden = false
        }
        
        headerCell.lblQuestion.text = dictQuestion!["message"] as? String
        
        var createdDate = ""
        
        if let temp = dictQuestion!["created_at"] as? String {
            createdDate = Util.getDateStringInDesiredFormat(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "MMM dd, yyyy")
        }
        headerCell.lblDate.text = createdDate
        
        if Util.isValidString(dictQuestion!["customer_image"] as! String) {
            
            let imageUrl = dictQuestion!["customer_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            headerCell.imgviewUser.kf.indicatorType = .activity
            headerCell.imgviewUser.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    headerCell.imgviewUser.image = value.image
                case .failure( _):
                    headerCell.imgviewUser.image = UIImage(named: "dummy_user")
                }
                headerCell.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            headerCell.imgviewUser.image = UIImage(named: "dummy_user")
        }

        headerView.addSubview(headerCell)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as? ReplyCell
        cell?.selectionStyle = .none
        
        let dictQuestion = arrQuestion[indexPath.section] as? NSDictionary
        let arrTemp = dictQuestion!["comment_reply"] as? NSArray
        
        let dictReply = arrTemp![indexPath.row] as? NSDictionary
        
        cell?.lblUsername.text = createUsername(dictReply!)
        cell?.lblReply.text = dictReply!["reply_message"] as? String

        var createdDate = ""
        
        if let temp = dictReply!["created_at"] as? String {
            createdDate = Util.getDateStringInDesiredFormat(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "MMM dd, yyyy")
        }
        cell?.lblDate.text = createdDate
        
        if Util.isValidString(dictReply!["seller_image"] as! String) {
            
            let imageUrl = dictReply!["seller_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            cell?.imgviewUser.kf.indicatorType = .activity
            cell?.imgviewUser.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    cell?.imgviewUser.image = value.image
                case .failure( _):
                    cell?.imgviewUser.image = UIImage(named: "dummy_user")
                }
                cell?.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            cell?.imgviewUser.image = UIImage(named: "dummy_user")
        }

        cell?.editHandler = {
            
            self.replyAction = 3

            let dictQuestion = self.arrQuestion[indexPath.section] as? NSDictionary
            let arrTemp = dictQuestion!["comment_reply"] as? NSArray
            
            self.dictData = arrTemp![indexPath.row] as! NSDictionary

            self.txvUpdateComment.text = self.dictData["reply_message"] as? String
            self.lblHeader.text = "Update Comment"
            
            self.viewBG.isHidden = false
            self.viewUpdateComment.isHidden = false
        }
        
        cell?.deleteHandler = {
            let uiAlert = UIAlertController(title: "", message: "Are you sure you want to delete questions??", preferredStyle:UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "No".localiz(), style: .default, handler: { action in }))
            
            uiAlert.addAction(UIAlertAction(title: "YES".localiz(), style: .default, handler: { action in
                
                let dictQuestion = self.arrQuestion[indexPath.section] as? NSDictionary
                let arrTemp = dictQuestion!["comment_reply"] as? NSArray
                
                let dictTemp = arrTemp![indexPath.row] as! NSDictionary

                self.deleteProductCommentReplyAPI_Call(dictTemp)
            }))
        }

        return cell!
    }
    
    func createUsername(_ dictTemp: NSDictionary) -> String {
        let firstName = dictTemp["seller_first_name"] as? String
        let lastName = dictTemp["seller_last_name"] as? String
        
        let username = "\(firstName ?? "") \(lastName ?? "")"
        
        return username
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
