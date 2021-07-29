//
//  AllBidVC.swift
//  Repoush
//
//  Created by Ravi's MacBook Pro on 28/02/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class AllBidVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var imgviewProductName: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var tblviewAllBid: UITableView!
    
    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    private var arrAllBid = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setProductDetail()
        
        // Perform Get all bid API
        getAllBidAPI_Call()
    }

    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
                
                imgviewProductName.kf.indicatorType = .activity
                imgviewProductName.kf.indicator?.startAnimatingView()
                
                let resource = ImageResource(downloadURL: url!)
                
                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        self.imgviewProductName.image = value.image
                    case .failure( _):
                        self.imgviewProductName.image = UIImage(named: "dummy_post")
                    }
                    self.imgviewProductName.kf.indicator?.stopAnimatingView()
                }
            }
            else {
                imgviewProductName.image = UIImage(named: "dummy_post")
            }
        }
    }

    // MARK: - API Methods
    private func getAllBidAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
                kAPI_Language   : MyDefaults().language as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getAllBid(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
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
                self.arrAllBid = NSMutableArray(array: arrTemp)
            }
            
            DispatchQueue.main.async {
                self.tblviewAllBid.reloadData()
            }
        }
    }

    private func updateBidStatusAPI_Call(_ selectedIndex: Int, bidStatus: String, userId: String, bidId: String) {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : userId as AnyObject,
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
                kAPI_BidStatus  : bidStatus as AnyObject,
                kAPI_BidId      : bidId as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.updateBidStatus(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                if bidStatus == "3" {
                    if self.arrAllBid.count > 0 {
                        self.arrAllBid.removeObject(at: selectedIndex)
                    }
                }
                else if bidStatus == "2" {
                    for i in 0..<self.arrAllBid.count {
                        let dictBid = self.arrAllBid[i] as? NSDictionary
                        let dictTemp = NSMutableDictionary(dictionary: dictBid!)
                        dictTemp["bid_status"] = "2"
                        self.arrAllBid.replaceObject(at: i, with: dictTemp)
                    }
                }
                self.tblviewAllBid.reloadData()
            }

        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate
extension AllBidVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAllBid.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllBidCell", for: indexPath) as? AllBidCell
        cell?.selectionStyle = .none
        
        let dictBid = arrAllBid[indexPath.row] as? NSDictionary
        
        cell?.acceptHandler = {
            let dictBid = self.arrAllBid[indexPath.row] as? NSDictionary
            self.updateBidStatusAPI_Call(indexPath.row, bidStatus: "2", userId: dictBid!["user_id"] as! String, bidId: dictBid!["id"] as! String)
        }
        
        cell?.rejectHandler = {
            let dictBid = self.arrAllBid[indexPath.row] as? NSDictionary
            self.updateBidStatusAPI_Call(indexPath.row, bidStatus: "3", userId: dictBid!["user_id"] as! String, bidId: dictBid!["id"] as! String)
        }
        
        let bidStatus = dictBid!["bid_status"] as! String
        
        if bidStatus == "2" {
            cell?.btnAccept.isHidden = true
            cell?.btnReject.isHidden = true
        }
        else {
            cell?.btnAccept.isHidden = false
            cell?.btnReject.isHidden = false
        }
        
        cell?.lblUsername.text = dictBid!["full_name"] as? String
        cell?.lblPrice.text = "$\(dictBid!["bid_amount"] ?? "0.0")"
        cell?.btnDistance.setTitle("\(dictBid!["distance"] ?? "0.0") \("km".localiz())", for: .normal)
        
        var createdDate = ""
        
        if let temp = dictBid!["last_login"] as? String {
            let tempDate = Util.getDateFromString(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "MMM dd, yyyy HH:mm:ss.SSS")
            
            createdDate = Util.relativeDateStringForDate(tempDate)
        }
        cell?.lblLastActiveOn.text = "\("Last active on:".localiz()) \(createdDate)"

        if Util.isValidString(dictBid!["user_img"] as! String) {
            
            let imageUrl = dictBid!["user_img"] as! String
            
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
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
