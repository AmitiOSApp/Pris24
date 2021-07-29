////
////  MyAuctionVC.swift
////  Repoush
////
////  Created by Ravi Sendhav on 1/25/20.
////  Copyright © 2020 Ravi Sendhav. All rights reserved.
////
//

class MyAuctionVC: UIViewController {
     
    // MARK: - IBOutlets
     @IBOutlet weak var lblNODATAFOUND : UILabel!
     @IBOutlet weak var btnSellerProfile : UIButton!
     @IBOutlet weak var btnBuyerProfile : UIButton!
     @IBOutlet weak var btnActiveAcutions : UIButton!
     @IBOutlet weak var btnInProgress : UIButton!
     @IBOutlet weak var btnHistory : UIButton!
     @IBOutlet weak var txtSearch : UITextField!
    
     @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var constraintLeadingSlideLable : NSLayoutConstraint!
     var isSellerProfile = true
     var K_TAG = 158
     var K_Type = "1"
    var BidAccepted = ""
    var sellerActiveAuction = [ModelSellerActiveAuctionResponseDatum]()
    var buyerActiveAuction = [ModelBuyerActiveAuctionResponseDatum]()
    var BuyerHistory = [ModelHistoryBuyerResponseDatum]()
    var sellerHistory = [ModelHistorySellerResponseDatum]()
    var inProgressSeller = [ModelInProgressSellerResponseDatum]()
    var inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
    var tabIndex : Int = 0
    
// MARK: - Property initialization
// MARK: - View Life Cycle
override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let tabBar = self.tabBarController!.tabBar
    tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.hexStringToUIColor(hex: "#02BBCA"), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:tabBar.frame.height), lineHeight: 2.0)
//
    
        
    if tabIndex == 0 {
        self.setUpDidLoad()
    }
    
        if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
       // self.GetCallAPI()
       NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationForShowAllBid(notification:)), name: Notification.Name("NotificationIdentifierAcceptBid"), object: nil)
    
   // NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationIdentifierFromAPNS(notification:)), name: Notification.Name("NotificationIdentifierFromAPNS"), object: nil)
    print(tabIndex)
    if BidAccepted == "Bid Accepted" {
        self.tabIndex = 1
        self.moveToInProgress()
    }   else if tabIndex == 1 {
        self.moveToInProgress()
    }
    self.txtSearch.addTarget(self, action: #selector(setDiscount), for: .editingChanged)
}
    @objc func methodOfReceivedNotificationForShowAllBid(notification: Notification) {
         self.senderInprogressBuyer()
    }
    @objc func NotificationIdentifierFromAPNS(notification: Notification) {
        self.senderInprogressBuyer()
       
    }
    func setUpDidLoad() {
        
        self.collectionView.register(UINib(nibName: "ActiveAuctionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActiveAuctionCollectionViewCell")
        self.collectionView.register(UINib(nibName: "InProgressCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InProgressCollectionViewCell")
        self.collectionView.register(UINib(nibName: "HistorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HistorCollectionViewCell")
        self.collectionView.register(UINib(nibName: "BuyerHistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BuyerHistoryCollectionViewCell")
        self.collectionView.register(UINib(nibName: "BuyerProfileActiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BuyerProfileActiveCollectionViewCell")
        self.collectionView.register(UINib(nibName: "InProgressSellerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InProgressSellerCollectionViewCell")
        self.collectionView.register(UINib(nibName: "ProfessionalSellerHistoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfessionalSellerHistoryCollectionViewCell")
        

        
        
        print(tabIndex)
        
        if tabIndex == 0 {
            self.btnSellerProfile.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnBuyerProfile.setTitleColor(UIColor.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
            self.GetCallAPI()
        } else if tabIndex == 2 {
           
        } else if tabIndex == 1 {
           // self.moveToInProgress()
        }
//        if appDelegate.pickUpLocation == "Pickup Location" {
//           self.moveToInProgress()
//        }
    }
    @objc func setDiscount(textField: UITextField) {
        self.tabBarController?.selectedIndex = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (MyDefaults().language ?? "") as String ==  "en"{
                self.changeLanguage(strLanguage: "en")
            } else{
                self.changeLanguage(strLanguage: "da")
            }
        
//        if appDelegate.MyAuction == "" {
//            self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//           // self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//           // self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//           // self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//           // self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//           // self.setUpDidLoad()
//        } else if appDelegate.MyAuction == "" {
//          //  self.setUpDidLoad()
//        }
        self.setUpDidLoad()
    
    }
    func GetCallAPI()  {
        if  isConnectedToInternet() {
           print(appDelegate.apnsAccept)
            if appDelegate.apnsAccept == "Bid Accepted" {
                self.moveToInProgress()
            }else{
                callServiceGetSellerActiveAcution(status: isSellerProfile, urlType: getAllUserProduct)
            }
            } else {
                self.showErrorPopup(message: internetConnetionError, title: alert)
            }
    }
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       self.collectionView.collectionViewLayout.invalidateLayout()
     }
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        self.popUpFilter(isAnimated: true)
    }
    func popUpFilter(isAnimated:Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: isAnimated)
    }
    func callServiceGetSellerActiveAcution(status:Bool,urlType:String) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["type":K_Type,
                                       "language": MyDefaults().language ?? AnyObject.self,
                                       "user_id": LoggedInUser.shared.id ?? "" ,
                                       "latitude":LoggedInUser.shared.latitude ?? "",
                                       "lognitude":LoggedInUser.shared.longitude ?? ""]
       print(parameter)
        HTTPService.callForPostApi(url:urlType , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                   debugPrint(response)
                 //  HideHud()
                   if response.count != nil {
                       let status = response["responseCode"] as! Int
                       let message = response["message"] as! String
                       if status == 200  {
                        if self.isSellerProfile == true {
                           let response = ModelSellerActiveAuction.init(fromDictionary: response as! [String : Any])
                            if response.responseData.count > 0{
                                self.sellerActiveAuction = response.responseData
                                self.collectionView.isHidden = false
                                appDelegate.MyAuction = ""
                                self.collectionView.reloadData()
                            }else{
                                self.collectionView.isHidden = true
                        }
                        } else{
                           
                        let response = ModelBuyerActiveAuction.init(fromDictionary: response as! [String : Any])
                             if response.responseData.count > 0{
                                 self.buyerActiveAuction = response.responseData
                                 self.collectionView.isHidden = false
                                appDelegate.MyAuction = ""
                                 self.collectionView.reloadData()
                             }else{
                                 self.collectionView.isHidden = true
                         }
                        }
                        
                        
                        
                } else if status == 500 {
                               self.collectionView.isHidden = true
                              // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                       }
                       }else{
                       self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                   }
               
       }
   }
}

    extension MyAuctionVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if self.isSellerProfile == true {
                if K_TAG == 158 {
                    return self.sellerActiveAuction.count
                } else if K_TAG == 159 {
                return self.inProgressSeller.count
               
                } else if K_TAG == 160 {
                    return self.sellerHistory.count
                }
            }else{
                if K_TAG == 158 {
                    return self.buyerActiveAuction.count
                } else if K_TAG == 159 {
                    return self.inprogressBuyer.count
                } else if K_TAG == 160 {
                    return self.BuyerHistory.count
                }
                
                return 0
            }
        
        return 0
        
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                      
            if self.isSellerProfile == true {
                
                if K_TAG == 158 {
                    let cell: ActiveAuctionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveAuctionCollectionViewCell", for: indexPath) as! ActiveAuctionCollectionViewCell
                                
                    if self.sellerActiveAuction.count > 0 {
                        if (MyDefaults().language ?? "") as String ==  "en"{
                            cell.lblTitle.text = self.sellerActiveAuction[indexPath.row].selling.capitalizingFirstLetter()
                            let off = "OFF".LocalizableString(localization: "en")
                            print(off)
                            
                            cell.lblDiscount.text = self.sellerActiveAuction[indexPath.row].discount + "% " + off
                            cell.lblOriginalPrice.text =  "Kr " + self.sellerActiveAuction[indexPath.row].basePrice
                            cell.lblOfferPrice.text =  "Kr " + self.sellerActiveAuction[indexPath.row].offerPrice
                            cell.totalTime = self.sellerActiveAuction[indexPath.row].timeLeftInSecond
                            
                            if let lastbid = self.sellerActiveAuction[indexPath.row].lastBid  {
                                cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "en") + "  Kr " + String(lastbid)
                            }else{
                                cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "en") + "  Kr " + String(format: "%", self.sellerActiveAuction[indexPath.row].lastBid ?? 0)
                            }
                            cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "en")
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                            cell.btnShowAllBid.setTitle("ShowAllBid".LocalizableString(localization: "en"), for: .normal)
                        
                        } else{
                                cell.lblTitle.text = self.sellerActiveAuction[indexPath.row].selling.capitalizingFirstLetter()
                                let off = "OFF".LocalizableString(localization: "da")
                           
                            cell.lblDiscount.text = self.sellerActiveAuction[indexPath.row].discount + "% " + off
                            cell.lblOriginalPrice.text =  "Kr " + self.sellerActiveAuction[indexPath.row].basePrice
                                cell.lblOfferPrice.text =  "Kr " + self.sellerActiveAuction[indexPath.row].offerPrice
                                cell.totalTime = self.sellerActiveAuction[indexPath.row].timeLeftInSecond
                                
                                if let lastbid = self.sellerActiveAuction[indexPath.row].lastBid  {
                                    cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "da") + "  Kr " + String(lastbid)
                                }else{
                                    cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "da") +  String(format: "%", self.sellerActiveAuction[indexPath.row].lastBid ?? 0)
                                }
                            cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "da")
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                            cell.btnShowAllBid.setTitle("ShowAllBid".LocalizableString(localization: "da"), for: .normal)
                            }
                                
                                
                    
                                cell.btnDelteActiveAuctions.tag = indexPath.item
                                cell.btnDelteActiveAuctions.addTarget(self, action: #selector(didTapActiveAuctionDelete(_:)), for: .touchUpInside)
        
                                cell.btnEdit.tag = indexPath.item
                                cell.btnEdit.addTarget(self, action: #selector(didTapActiveAuctionEdit(_:)), for: .touchUpInside)
        
                                cell.btnDuplicateCopy.tag = indexPath.item
                                cell.btnDuplicateCopy.addTarget(self, action: #selector(didTapActiveAuctionDuplicateCopy(_:)), for: .touchUpInside)
                    
                                cell.btnShowAllBid.tag = indexPath.item
                                cell.btnShowAllBid.addTarget(self, action: #selector(didTapOnShowAllBid(_:)), for: .touchUpInside)
        
                            if self.sellerActiveAuction[indexPath.row].productImage.count > 0 {
                                self.configureCellSellerProfileActiveAuctionsImage(cell: cell, image: self.sellerActiveAuction[indexPath.row].productImage[0].productImage)
                            }else{
                                self.configureCellSellerProfileActiveAuctionsImage(cell: cell, image: "")
                            }
                            return cell
                    }
            } else if K_TAG == 159 {
                    let cell: InProgressSellerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InProgressSellerCollectionViewCell", for: indexPath) as! InProgressSellerCollectionViewCell
                       
                    if self.inProgressSeller.count > 0 {
                        cell.lblTitle.text = self.inProgressSeller[indexPath.row].selling.capitalizingFirstLetter()
                        cell.lblDiscount.text = self.inProgressSeller[indexPath.row].discount + "% Off"
                        cell.lblOriginalPrice.text =  "Kr " + self.inProgressSeller[indexPath.row].basePrice
                        cell.lblOfferPrice.text =  "Kr " + self.inProgressSeller[indexPath.row].offerPrice
                        cell.totalTime = self.inProgressSeller[indexPath.row].timeLeftInSecond
//                        let lastbid = self.activeAution[indexPath.row].lastBid as  Int
//                        cell.lblBidPrice.text =  "Last Bid : " + "  Kr " + String(lastbid)
                        if (MyDefaults().language ?? "") as String ==  "en"{
                            let off = "OFF".LocalizableString(localization: "en")
                            cell.lblDiscount.text = self.inProgressSeller[indexPath.row].discount + "% " + off
                            cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "en")
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                           
                        
                        } else{
                            let off = "OFF".LocalizableString(localization: "da")
                            cell.lblDiscount.text = self.inProgressSeller[indexPath.row].discount + "% " + off
                            cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "da")
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                            
                            
                        }
                        if self.inProgressSeller[indexPath.row].productImage.count > 0 {
                        self.configureCellInprogressImage(cell: cell, image: self.inProgressSeller[indexPath.row].productImage[0].productImage)
                        }else{
                        self.configureCellInprogressImage(cell: cell, image: "")
                        }
                    
                    }
                    return cell
            } else if K_TAG == 160 {
                   
                let cell: HistorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistorCollectionViewCell", for: indexPath) as! HistorCollectionViewCell
                   
                    if self.sellerHistory.count > 0 {
                        cell.lblTitle.text = self.sellerHistory[indexPath.row].productName.capitalizingFirstLetter()
                        cell.lblDiscount.text = self.sellerHistory[indexPath.row].discount + "% Off"
                        cell.lblOriginalPrice.text =  "Kr " + self.sellerHistory[indexPath.row].basePrice
                        cell.lblOfferPrice.text =  "Kr " + self.sellerHistory[indexPath.row].offerPrice
                       
                        let lastbid = self.sellerHistory[indexPath.row].lastBid
                       // cell.lblBidPrice.text =  "Last Bid : " + "  Kr " + String(lastbid ?? "0")
                        
                        
                        if (MyDefaults().language ?? "") as String ==  "en"{
                            let off = "OFF".LocalizableString(localization: "en")
                            cell.lblDiscount.text = self.sellerHistory[indexPath.row].discount + "% " + off
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                            cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "en") + "  Kr " + String(lastbid ?? "")
                        
                        } else{
                            let off = "OFF".LocalizableString(localization: "da")
                            cell.lblDiscount.text = self.sellerHistory[indexPath.row].discount + "% " + off
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                            cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "da") + "  Kr " + String(lastbid ?? "")
                        }
                        
                        //cell.lblBidPrice.text = "Last Bid : " + "  Kr " + self.History[indexPath.row].lastBid
                        cell.btnRateBuyer.tag = indexPath.item
                        cell.btnRateBuyer.addTarget(self, action: #selector(didTapRateSellerHistory(_:)), for: .touchUpInside)
                        cell.btnRePost.tag = indexPath.item
                        cell.btnRePost.addTarget(self, action: #selector(didTapSellerHistoryRepost(_:)), for: .touchUpInside)
                        cell.btnDeleteSellerProfile.tag = indexPath.item
                        cell.btnDeleteSellerProfile.addTarget(self, action: #selector(didSellerHistoryProfile(_:)), for: .touchUpInside)
                        if self.sellerHistory[indexPath.item].isBooked == "1" {
                        if self.sellerHistory[indexPath.item].isRated! == 1 {
                                cell.btnRateBuyer.isHidden = true
                                cell.btnRateBuyerwidthConstraints.constant = 0
                                cell.btnRepostwidthConstraints.constant = 0
                            cell.lblDealCompleted.isHidden = false
                            if (MyDefaults().language ?? "") as String ==  "en"{
                                cell.lblDealCompleted.text = "deal_completed".LocalizableString(localization: "en")
                            } else{
                                cell.lblDealCompleted.text = "deal_completed".LocalizableString(localization: "da")
                            }
                            
                        } else if self.sellerHistory[indexPath.item].isBooked == "1"  {
                            if self.sellerHistory[indexPath.item].isRated == 0 {
                                cell.btnRepostwidthConstraints.constant = 0
                                cell.btnRePost.isHidden = true
                                cell.btnRateBuyer.isHidden = false
                                cell.btnRateBuyerwidthConstraints.constant = 84
                                cell.lblDealCompleted.isHidden = true
                                if (MyDefaults().language ?? "") as String ==  "en"{
                                    cell.btnRateBuyer.setTitle("Rate_Buyer".LocalizableString(localization: "en"), for: .normal)
                                } else{
                                    cell.btnRateBuyer.setTitle("Rate_Buyer".LocalizableString(localization: "da"), for: .normal)
                                }
                            }
                        }
                    } else{
                       if self.sellerHistory[indexPath.item].isBooked == "0" {
                         if self.sellerHistory[indexPath.item].isRated! == 0 {
                            cell.btnRepostwidthConstraints.constant = 94
                            cell.btnRePost.isHidden = false
                            cell.btnRateBuyerwidthConstraints.constant = 0
                            cell.btnRateBuyer.isHidden = true
                            cell.lblDealCompleted.isHidden = true
                            if (MyDefaults().language ?? "") as String ==  "en"{
                                cell.btnRePost.setTitle("REPOST".LocalizableString(localization: "en"), for: .normal)
                            } else{
                                cell.btnRePost.setTitle("REPOST".LocalizableString(localization: "da"), for: .normal)
                            }

                         } else{
                            if self.sellerHistory[indexPath.item].isRated == 1 {
                                cell.btnRepostwidthConstraints.constant = 60
                                cell.btnRePost.isHidden = false
                                cell.btnRateBuyerwidthConstraints.constant = 0
                                cell.btnRateBuyer.isHidden = true
                                cell.lblDealCompleted.isHidden = true
                                if (MyDefaults().language ?? "") as String ==  "en"{
                                    cell.btnRePost.setTitle("REPOST".LocalizableString(localization: "en"), for: .normal)
                                } else{
                                    cell.btnRePost.setTitle("REPOST".LocalizableString(localization: "da"), for: .normal)
                                }

                                }
                            }

                        }
                        }

//                        }
                        
                    if self.sellerHistory[indexPath.row].productImage.count > 0 {
                                 self.configureCellHistoryImage(cell: cell, image: self.sellerHistory[indexPath.row].productImage[0].productImage)
                             }else{
                                 self.configureCellHistoryImage(cell: cell, image: "")
                             }
                    }
                 return cell
               
            }
                
            }else{
                if K_TAG == 158 {
                    
                    let cell: BuyerProfileActiveCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyerProfileActiveCollectionViewCell", for: indexPath) as! BuyerProfileActiveCollectionViewCell
                          
                    if self.buyerActiveAuction.count > 0  {
                        cell.lblTitle.text = self.buyerActiveAuction[indexPath.row].productName.capitalizingFirstLetter()
                            
                        if self.buyerActiveAuction[indexPath.row].firstName.isEmpty {
                            cell.lblName.text = "By :- " + self.buyerActiveAuction[indexPath.row].companyName.capitalizingFirstLetter()
                        } else {
                           
                            cell.lblName.text = self.buyerActiveAuction[indexPath.row].firstName.capitalizingFirstLetter() + " " + self.buyerActiveAuction[indexPath.row].lastName.capitalizingFirstLetter()
                        }
                        
                        cell.lblDiscount.text = self.buyerActiveAuction[indexPath.row].discount + "% Off"
                           cell.lblOriginalPrice.text =  "Kr " + self.buyerActiveAuction[indexPath.row].basePrice
                           cell.lblOfferPrice.text =  "Kr " + self.buyerActiveAuction[indexPath.row].offerPrice
                           cell.imgGallery.sd_setImage(with: URL(string:self.buyerActiveAuction[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "gallery"))
                            cell.totalTime = self.buyerActiveAuction[indexPath.row].timeleftinsecond
                        let lastbid = self.buyerActiveAuction[indexPath.row].bidAmount
                           
                        if (MyDefaults().language ?? "") as String ==  "en"{
                           let off = "OFF".LocalizableString(localization: "en")
                           print(off)
                           cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                           cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                           cell.lblBidPrice.text =  "My_bid".LocalizableString(localization: "en") + "  Kr " + String(lastbid ?? "")
                           cell.lblDiscount.text = self.buyerActiveAuction[indexPath.row].discount + "% " + off
                            cell.btnCancelBid.setTitle("Cancel_Bid".LocalizableString(localization: "en"), for: .normal)
                            } else{
                            let off = "OFF".LocalizableString(localization: "da")
                            print(off)
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                            cell.lblBidPrice.text =  "LastBid".LocalizableString(localization: "da") + "  Kr " + String(lastbid ?? "")
                            cell.lblDiscount.text = self.buyerActiveAuction[indexPath.row].discount + "% " + off
                            cell.btnCancelBid.setTitle("Cancel_Bid".LocalizableString(localization: "da"), for: .normal)
                        }
                           cell.btnCancelBid.tag = indexPath.item
                           cell.btnCancelBid.addTarget(self, action: #selector(didTapBuyerActiveAuctionCancelBid(_:)), for: .touchUpInside)
                    
                       if self.buyerActiveAuction[indexPath.row].productImage.count > 0 {
                           self.configureCellBuyerProfile(cell: cell, image: self.buyerActiveAuction[indexPath.row].productImage[0].productImage)
                       }else{
                           self.configureCellBuyerProfile(cell: cell, image: "")
                       }
                    }
                         return cell
                    
                } else if K_TAG == 159 {
                     let cell: InProgressCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "InProgressCollectionViewCell", for: indexPath) as! InProgressCollectionViewCell
                    
                    if self.inprogressBuyer.count > 0 {
                        cell.lblTitle.text = self.inprogressBuyer[indexPath.row].productName.capitalizingFirstLetter()
                            cell.lblDiscount.text = self.inprogressBuyer[indexPath.row].discount + "% Off"
                            cell.lblOriginalPrice.text =  "Kr " + self.inprogressBuyer[indexPath.row].basePrice
                            cell.lblOfferPrice.text =  "Kr " + self.inprogressBuyer[indexPath.row].offerPrice
                        cell.imgGallery.sd_setImage(with: URL(string:self.inprogressBuyer[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "gallery"))
                        cell.lblName.text = "By :- " + self.inprogressBuyer[indexPath.row].firstName.capitalizingFirstLetter() + " " + self.inprogressBuyer[indexPath.row].lastName.capitalizingFirstLetter()
                        cell.lblMyBid.text = "OfferPrice".LocalizableString(localization: "en")
                        
                        let lastbid =  self.inprogressBuyer[indexPath.row].bidAmount
                        
                    if self.inprogressBuyer[indexPath.row].timeLeftInSecond != nil {
                        cell.totalTime = self.inprogressBuyer[indexPath.row].timeLeftInSecond
                    }else{
                       // cell.totalTime = "Times UP!"
                    }
                        
                        if (MyDefaults().language ?? "") as String ==  "en"{
                           let off = "OFF".LocalizableString(localization: "en")
                           print(off)
                           cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                           cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                            cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "en")
                           cell.lblDiscount.text = self.inprogressBuyer[indexPath.row].discount + "% " + off
                            cell.lblMyBid.text =  "My_bid".LocalizableString(localization: "en") + "  Kr " + String(lastbid ?? "")
                            cell.btnProductReceived.setTitle("order_received".LocalizableString(localization: "en").uppercased(), for: .normal)
                           
                            } else{
                            let off = "OFF".LocalizableString(localization: "da")
                            print(off)
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                                cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "da")
                            cell.lblDiscount.text = self.inprogressBuyer[indexPath.row].discount + "% " + off
                            cell.lblMyBid.text =  "My_bid".LocalizableString(localization: "da") + "  Kr " + String(lastbid ?? "")
                                cell.btnProductReceived.setTitle("order_received".LocalizableString(localization: "da").uppercased(), for: .normal)
                        }
                        
                        
                    cell.btnProductReceived.tag = indexPath.item
                    cell.btnProductReceived.addTarget(self, action: #selector(didTapProductReceived(_:)), for: .touchUpInside)
                    if self.inprogressBuyer[indexPath.row].productImage.count > 0 {
                            self.configureCellInprogressImage(cell: cell, image: self.inprogressBuyer[indexPath.row].productImage[0].productImage)
                            }else{
                            self.configureCellInprogressImage(cell: cell, image: "")
                            }
                    }
                     return cell
                } else if K_TAG == 160 {
                    let cell: BuyerHistoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyerHistoryCollectionViewCell", for: indexPath) as! BuyerHistoryCollectionViewCell
                    if self.BuyerHistory.count > 0 {
                       print(self.BuyerHistory[indexPath.row].productName)
                        cell.lblTitle.text = self.BuyerHistory[indexPath.row].productName.capitalizingFirstLetter()
                        cell.lblDiscount.text = self.BuyerHistory[indexPath.row].discount + "% Off"
                        cell.lblOriginalPrice.text =  "Kr " + self.BuyerHistory[indexPath.row].basePrice
                        cell.lblOfferPrice.text =  "Kr " + self.BuyerHistory[indexPath.row].offerPrice
                        
                        cell.imgGallery.sd_setImage(with: URL(string:self.BuyerHistory[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "gallery"))
                        if self.BuyerHistory[indexPath.row].firstName == "" && self.BuyerHistory[indexPath.row].lastName == ""{
                             cell.lblName.text = "By :- " + self.BuyerHistory[indexPath.row].companyName
                         }else{
                             cell.lblName.text = "By :- " + self.BuyerHistory[indexPath.row].firstName.capitalizingFirstLetter() + " " + self.BuyerHistory[indexPath.row].lastName.capitalizingFirstLetter()
                         }
                    
                        let lastbid =  self.BuyerHistory[indexPath.row].bidAmount
                        if (MyDefaults().language ?? "") as String ==  "en"{
                            let off = "OFF".LocalizableString(localization: "en")
                            cell.lblDiscount.text = self.BuyerHistory[indexPath.row].discount + "% " + off
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                            cell.lblBidPrice.text =  "My_bid".LocalizableString(localization: "en") + "  Kr " + String(lastbid ?? "")
                           /// cell.lblBidPrice.text = "My Bid : " + "  Kr " + self.BuyerHistory[indexPath.row].bidAmount
                        } else{
                            let off = "OFF".LocalizableString(localization: "da")
                            cell.lblDiscount.text = self.BuyerHistory[indexPath.row].discount + "% " + off
                            cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                            cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                            cell.lblBidPrice.text =  "My_bid".LocalizableString(localization: "da") + "  Kr " + String(lastbid ?? "")
                            //cell.lblBidPrice.text = "My Bid : " + "  Kr " + self.BuyerHistory[indexPath.row].bidAmount
                        }
                       // cell.btnRateSeller.isHidden = true
                       // cell.lblDealStatus.isHidden = true
                        
                        if self.BuyerHistory[indexPath.row].orderType! == "order" {
                               
                                    
                                    if self.BuyerHistory[indexPath.row].orderStatus! == "1" {
                                        
                                        }
                                    else  if self.BuyerHistory[indexPath.row].orderStatus! == "2" {
                                       if self.BuyerHistory[indexPath.row].isRated! == 0 {
                                        if (MyDefaults().language ?? "") as String ==  "en"{
                                            cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "en")
                                            cell.btnRateSeller.setTitle("RATE_SALLER".LocalizableString(localization: "en"), for: .normal)
                                        }
                                        else{
                                            cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "da")
                                            cell.btnRateSeller.setTitle("RATE_SALLER".LocalizableString(localization: "da"), for: .normal)
                                            }
                                        cell.lblDealStatus.isHidden = false
                                        cell.lblDealStatus.textColor = UIColor.hexStringToUIColor(hex: "#00B259")
                                        cell.btnRateSeller.isHidden = false
                                        cell.btnRateSellerWidthConstant.constant = 86
                                        
                                        } else if self.BuyerHistory[indexPath.row].isRated! == 1 {
                                            if (MyDefaults().language ?? "") as String ==  "en"{
                                                cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "en")
                                            }
                                            else{
                                                cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "da")
                                            }
                                            cell.lblDealStatus.isHidden = false
                                            cell.btnRateSeller.isHidden = true
                                            cell.btnRateSellerWidthConstant.constant = 0
                                            cell.lblDealStatus.textColor = UIColor.hexStringToUIColor(hex: "#00B259")
                                    
                                        }
                                    }
                                    else  if self.BuyerHistory[indexPath.row].orderStatus! == "3" {
                                       
                                        if self.BuyerHistory[indexPath.row].isRated! == 0 {
                                            if (MyDefaults().language ?? "") as String ==  "en"{
                                                cell.lblDealStatus.text = "Deal_InCompleted".LocalizableString(localization: "en")
                                            }
                                            else{
                                                cell.lblDealStatus.text = "Deal_InCompleted".LocalizableString(localization: "da")
                                            }
                                            cell.btnRateSeller.isHidden = true
                                            cell.btnRateSellerWidthConstant.constant = 0
                                            cell.lblDealStatus.textColor = UIColor.red
                                            
                                        } else if self.BuyerHistory[indexPath.row].isRated! == 1 {
                                            if (MyDefaults().language ?? "") as String ==  "en"{
                                                cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "en")
                                            }
                                            else{
                                                cell.lblDealStatus.text = "deal_completed".LocalizableString(localization: "da")
                                            }
                                            cell.btnRateSeller.isHidden = true
                                            cell.btnRateSellerWidthConstant.constant = 0
                                            cell.lblDealStatus.textColor = UIColor.hexStringToUIColor(hex: "#00B259")
                                            
                                        }
                                     
                                    }
                                
                                
                               } else{
                                if self.BuyerHistory[indexPath.row].isRated == 0 {
                                    cell.btnRateSeller.isHidden = false
                                    cell.btnRateSellerWidthConstant.constant = 94
                                    if (MyDefaults().language ?? "") as String ==  "en"{
                                        cell.btnRateSeller.setTitle("CANCEL_BID".LocalizableString(localization: "en"), for: .normal)
                                        
                                    }
                                    else{
                                        cell.btnRateSeller.setTitle("CANCEL_BID".LocalizableString(localization: "da"), for: .normal)
                                       
                                        }
                                    }
                                }
                                if self.BuyerHistory[indexPath.row].productImage.count > 0 {
                                    self.configureCellBuyerProfileHistoryImage(cell: cell, image: self.BuyerHistory[indexPath.row].productImage[0].productImage)
                    }else{
                        self.configureCellBuyerProfileHistoryImage(cell: cell, image: "")
                    }
                        cell.btnRateSeller.tag = indexPath.item
                        cell.btnRateSeller.addTarget(self, action: #selector(didTapRateSeller(_:)), for: .touchUpInside)
                    
                        cell.btnbuyerProfile.tag = indexPath.item
                        cell.btnbuyerProfile.addTarget(self, action: #selector(didTapBuyerProfile(_:)), for: .touchUpInside)
                      
                   
                  
                    
                    }
                    return cell
                }
            
        }
           return UICollectionViewCell()
}

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

//            let vc = storyBoard.ZoomTab.instantiateViewController(withIdentifier: "BrowserDetailVC") as! BrowserDetailVC
//            vc.categoryIId = self.categoryData[indexPath.row].id
//            self.navigationController?.pushViewController(vc, animated: true)
       
            if self.isSellerProfile == true {
                if K_TAG == 158 {
                    //self.sellerActiveAuction[indexPath.row].selling
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.sellerActiveAuction[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "activeSellerProfile"
                        vc.isSelectedTabs = false
                       // vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                
                    }  else if K_TAG == 159 {
                    //self.inProgressSeller[indexPath.row].selling
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.inProgressSeller[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "inprogressSellerProfile"
                        vc.isSelectedTabs = false
                        vc.isProfessional = false
                       
                        vc.isHistory = false
                       // vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if K_TAG == 160 {
                    //self.sellerHistory[indexPath.row].productName
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.sellerHistory[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "historySellerProfile"
                        vc.isSelectedTabs = false
                    vc.isProfessional = false
                        //vc.hidesBottomBarWhenPushed = true
                    vc.isHistory = true
                    //vc.isDealCompleted = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if K_TAG == 158 {
                   // self.buyerActiveAuction[indexPath.row].productName
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.buyerActiveAuction[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "activeBuyerProfile"
                        vc.isSelectedTabs = true
                    vc.isHistory = true
                       // vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                 }  else if K_TAG == 159 {
                    //self.inprogressBuyer[indexPath.row].productName
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.inprogressBuyer[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "inprogressBuyerProfile"
                        vc.isSelectedTabs = true
                   
                    vc.isHistory = false
                       // vc.hidesBottomBarWhenPushed = true
                        
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if K_TAG == 160 {
                    //self.BuyerHistory[indexPath.row].productName
                    let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as! ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc.productDetailId = self.BuyerHistory[indexPath.item].productId
                        vc.delagate = self
                        vc.slecteTabs = "historyBuyerProfile"
                        vc.isSelectedTabs = true
                        
                      //  vc.hidesBottomBarWhenPushed = true
                        vc.isHistory = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                   let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
                   let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
                   let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
                    
                if self.isSellerProfile == true {
                    if K_TAG == 158 {
                        return CGSize(width: size, height: 328.0)
                    } else if K_TAG == 159 {
                        return CGSize(width: size, height: 282)
                    } else if K_TAG == 160 {
                        return CGSize(width: size, height: 320.0)
                    }
                }else{
                    if K_TAG == 158 {
                        return CGSize(width: size, height: 348.0)
                    } else if K_TAG == 159 {
                        return CGSize(width: size, height: 345)
                    } else if K_TAG == 160 {
                        return CGSize(width: size, height: 344.0)
                    }
                }
                return CGSize(width: size, height: 320.0)
            
        }

        func configureCellSellerProfileActiveAuctionsImage(cell:ActiveAuctionCollectionViewCell,image:String)  {
                        if Util.isValidString(image) {
                            let imageUrl = image
                            let url = URL.init(string: imageUrl)
                            cell.imgBuyer.kf.indicatorType = .activity
                            cell.imgBuyer.kf.indicator?.startAnimatingView()
                            let resource = ImageResource(downloadURL: url!)
                            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                                         switch result {
                                         case .success(let value):
                                             cell.imgBuyer.image = value.image
                                         case .failure( _):
                                             cell.imgBuyer.image = UIImage(named: "dummy_post")
                                         }
                                         cell.imgBuyer.kf.indicator?.stopAnimatingView()
                                     }
                                 }
                                 else {
                                     cell.imgBuyer.image = UIImage(named: "dummy_post")
                                 }
                      
                      }
        func configureCellInprogressImage(cell:InProgressCollectionViewCell,image:String)  {
                    if Util.isValidString(image) {
                       let imageUrl = image
                       let url = URL.init(string: imageUrl)
                        cell.imgBuyer.kf.indicatorType = .activity
                        cell.imgBuyer.kf.indicator?.startAnimatingView()
                       let resource = ImageResource(downloadURL: url!)
                       KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                           switch result {
                           case .success(let value):
                               cell.imgBuyer.image = value.image
                           case .failure( _):
                               cell.imgBuyer.image = UIImage(named: "dummy_post")
                           }
                           cell.imgBuyer.kf.indicator?.stopAnimatingView()
                       }
                   }
                   else {
                       cell.imgBuyer.image = UIImage(named: "dummy_post")
                   }
        }
        func configureCellInprogressImage(cell:InProgressSellerCollectionViewCell,image:String)  {
                           if Util.isValidString(image) {
                              let imageUrl = image
                              let url = URL.init(string: imageUrl)
                               cell.imgBuyer.kf.indicatorType = .activity
                               cell.imgBuyer.kf.indicator?.startAnimatingView()
                              let resource = ImageResource(downloadURL: url!)
                              KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                                  switch result {
                                  case .success(let value):
                                      cell.imgBuyer.image = value.image
                                  case .failure( _):
                                      cell.imgBuyer.image = UIImage(named: "dummy_post")
                                  }
                                  cell.imgBuyer.kf.indicator?.stopAnimatingView()
                              }
                          }
                          else {
                              cell.imgBuyer.image = UIImage(named: "dummy_post")
                          }
               }
        func configureCellHistoryImage(cell:HistorCollectionViewCell,image:String)  {
                    if Util.isValidString(image) {
                       let imageUrl = image
                       let url = URL.init(string: imageUrl)
                        cell.imgBuyer.kf.indicatorType = .activity
                        cell.imgBuyer.kf.indicator?.startAnimatingView()
                       let resource = ImageResource(downloadURL: url!)
                       KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                           switch result {
                           case .success(let value):
                               cell.imgBuyer.image = value.image
                           case .failure( _):
                               cell.imgBuyer.image = UIImage(named: "dummy_post")
                           }
                           cell.imgBuyer.kf.indicator?.stopAnimatingView()
                       }
                   }
                   else {
                       cell.imgBuyer.image = UIImage(named: "dummy_post")
                   }

        }
        func configureCellBuyerProfileHistoryImage(cell:BuyerHistoryCollectionViewCell,image:String)  {
                    if Util.isValidString(image) {
                       let imageUrl = image
                       let url = URL.init(string: imageUrl)
                        cell.imgBuyer.kf.indicatorType = .activity
                        cell.imgBuyer.kf.indicator?.startAnimatingView()
                       let resource = ImageResource(downloadURL: url!)
                       KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                           switch result {
                           case .success(let value):
                               cell.imgBuyer.image = value.image
                           case .failure( _):
                               cell.imgBuyer.image = UIImage(named: "dummy_post")
                           }
                           cell.imgBuyer.kf.indicator?.stopAnimatingView()
                       }
                   }
                   else {
                       cell.imgBuyer.image = UIImage(named: "dummy_post")
                   }

        }
        func configureCellBuyerProfile(cell:BuyerProfileActiveCollectionViewCell,image:String)  {
                    if Util.isValidString(image) {
                       let imageUrl = image
                       let url = URL.init(string: imageUrl)
                        cell.imgBuyer.kf.indicatorType = .activity
                        cell.imgBuyer.kf.indicator?.startAnimatingView()
                       let resource = ImageResource(downloadURL: url!)
                       KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                           switch result {
                           case .success(let value):
                               cell.imgBuyer.image = value.image
                           case .failure( _):
                               cell.imgBuyer.image = UIImage(named: "dummy_post")
                           }
                           cell.imgBuyer.kf.indicator?.stopAnimatingView()
                       }
                   }
                   else {
                       cell.imgBuyer.image = UIImage(named: "dummy_post")
                   }

        }
        
        func configureCellProfessionalSellerHistoryImage(cell:ProfessionalSellerHistoryCollectionViewCell,image:String)  {
                    if Util.isValidString(image) {
                       let imageUrl = image
                       let url = URL.init(string: imageUrl)
                        cell.imgBuyer.kf.indicatorType = .activity
                        cell.imgBuyer.kf.indicator?.startAnimatingView()
                       let resource = ImageResource(downloadURL: url!)
                       KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                           switch result {
                           case .success(let value):
                               cell.imgBuyer.image = value.image
                           case .failure( _):
                               cell.imgBuyer.image = UIImage(named: "dummy_post")
                           }
                           cell.imgBuyer.kf.indicator?.stopAnimatingView()
                       }
                   }
                   else {
                       cell.imgBuyer.image = UIImage(named: "dummy_post")
                   }

        }
        
        @objc func didTapActiveAuctionDelete(_ sender: UIButton) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.deleteSellerProfile(index: sender.tag, Message: "Are_you_sure_you_want_to_delete_this_auction_Seller".LocalizableString(localization: "en"), title: "Delete_auction".LocalizableString(localization: "en"))
            } else {
                self.deleteSellerProfile(index: sender.tag, Message: "Are_you_sure_you_want_to_delete_this_auction_Seller".LocalizableString(localization: "da"), title: "Delete_auction".LocalizableString(localization: "da"))
            }
        }
        
        @objc func didTapRateSellerHistory(_ sender: UIButton) {
            self.popUpRateSaller(isAnimated: true, index: sender.tag)
          
        }
        
        @objc func didSellerHistoryProfile(_ sender: UIButton) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.deleteSellerHistoryProfile(index: sender.tag,Message: "Are_you_sure_you_want_to_delete_this_auction_Seller".LocalizableString(localization: "en"),
                title: "Delete_auction".LocalizableString(localization: "en"), okay: "showAllbidYes".LocalizableString(localization: "en"), cancel: "cancel_bid".LocalizableString(localization: "en"))
            
            } else {
                self.deleteSellerHistoryProfile(index: sender.tag,Message: "Are_you_sure_you_want_to_delete_this_auction_Seller".LocalizableString(localization: "da"),
                title: "Delete_auction".LocalizableString(localization: "da"), okay: "showAllbidYes".LocalizableString(localization: "da"), cancel: "cancel_bid".LocalizableString(localization: "da"))
            }
            
        }
        func deleteSellerHistoryProfile(index: Int, Message: String,title: String,okay: String,cancel: String) {
            let alertController = UIAlertController(title: title, message: Message, preferredStyle: .alert)

            // Create the actions
              let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
                UIAlertAction in
                  self.callServiceDeleteSellerHistory(index:index)
            }
              let cancelAction = UIAlertAction(title:cancel , style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }

            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        func callServiceDeleteSellerHistory(index:Int) {
            
            
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
                  let parameter: [String: Any] = [
                                                     "language": MyDefaults().language ?? AnyObject.self,
                                                     "product_id":self.sellerHistory[index].productId!]
                    
                    
                   print(parameter)
            HTTPService.callForPostApi(url:deleteProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                                 debugPrint(response)
                               //  HideHud()
                                 if response.count != nil {
                                     let status = response["responseCode"] as! Int
                                     let message = response["message"] as! String
                                     if status == 200  {
       
                                        // self.showMessage(index: 0, Message: "Deal Completed,Item Moved to History",title:"Deal Completed")
                                        self.sellerHistory.remove(at: index)
                                       // let indexPath = IndexPath(item: index, section: 0)
                                        self.collectionView.reloadData()
                                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                         
                              } else if status == 500 {
                                             self.collectionView.isHidden = true
                                             self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                     }
                                     }else{
                                     self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                                 }
                             
                     }
                
                 }
        
    @objc func didTapSellerHistoryRepost(_ sender: UIButton) {
        
        if (MyDefaults().language ?? "") as String ==  "en"{
                let alertController = UIAlertController(title: "Repost_auction".LocalizableString(localization: "en"), message: "Are_you_sure_you_want_to_repost_this_auction".LocalizableString(localization: "en"), preferredStyle: .alert)

                // Create the actions
                  let okAction = UIAlertAction(title: "showAllbidYes".LocalizableString(localization: "en"), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                      self.callServiceGetRepostHistorySeller(index:sender.tag)
                }
                  let cancelAction = UIAlertAction(title: "cancel_bid".LocalizableString(localization: "en"), style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }

                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else{
                let alertController = UIAlertController(title: "Repost_auction".LocalizableString(localization: "da"), message: "Are_you_sure_you_want_to_repost_this_auction".LocalizableString(localization: "da"), preferredStyle: .alert)

                // Create the actions
                  let okAction = UIAlertAction(title: "showAllbidYes".LocalizableString(localization: "da"), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                      self.callServiceGetRepostHistorySeller(index:sender.tag)
                }
                  let cancelAction = UIAlertAction(title: "cancel_bid".LocalizableString(localization: "da"), style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }

                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        @objc func didTapActiveAuctionEdit(_ sender: UIButton) {
            let vc = Util.loadViewController(fromStoryboard: "AddPostEditVC", storyboardName: "Home") as? AddPostEditVC
            vc?.productId = self.sellerActiveAuction[sender.tag].productId
            vc?.objActiveAuction = self.sellerActiveAuction[sender.tag]
            vc?.titleName = "Edit Auction"
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        @objc func didTapActiveAuctionDuplicateCopy(_ sender: UIButton) {
            let commonAlert = CommonPopupAlert()
            commonAlert.delegate = self
            // commonAlert.index = index
            commonAlert.indexSelection = sender.tag
            commonAlert.viewContolls = "duplicate"
            if (MyDefaults().language ?? "") as String ==  "en"{
                commonAlert.showAlertPopUp(title: "Duplicate Auction", message: "Do_you_want_to_create_another_auction_now".LocalizableString(localization: "en"), vc: self)
            } else {
                commonAlert.showAlertPopUp(title: "Duplicate Auction", message: "Do_you_want_to_create_another_auction_now".LocalizableString(localization: "da"), vc: self)
            }
        }
        
        @objc func didTapProductReceived(_ sender: UIButton) {
           //
          //  self.callServiceGetChangeStaus(productId: self.inprogressBuyer[sender.tag].productId., basePrice: self.inprogressBuyer[sender.tag].basePrice, offerPrice:String,discount:self.inprogressBuyer[sender.tag].,sellerId: String,dealPrice:self.inprogressBuyer[sender.tag].)
        //self.inprogressBuyer[indexPath.row].
       
            self.callServiceGetChangeStaus(orderId: self.inprogressBuyer[sender.tag].orderId)
        
        }
        
        @objc func didTapRateBuyer(_ sender: UIButton) {
               
             
        }
        @objc func didTapDeleteHistory(_ sender: UIButton) {
               
               }
        @objc func didTapRateSeller(_ sender: UIButton) {
            
            if let buttonTitle = sender.title(for: .normal) {
                if buttonTitle == "RATE SELLER"  {
                    self.popUpRateSaller(isAnimated: true, index: sender.tag)
                } else  if buttonTitle == "Bedøm sælger"  {
                    self.popUpRateSaller(isAnimated: true, index: sender.tag)
                }
                
                
                else{
                    
                    
                }
              
            
            
            }
       
        
        }
        @objc func didTapBuyerActiveAuctionCancelBid(_ sender: UIButton) {
          
            if (MyDefaults().language ?? "") as String ==  "en"{
                let refreshAlert = UIAlertController(title: "Cancel_Bid_myAuction_Alret".LocalizableString(localization: "en"), message: "Cancel_Bid_myAuction_Message_Alret".LocalizableString(localization: "en"), preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            print("Handle Ok logic here")
                        self.cancelBid(index: sender.tag)
                   }))

                    refreshAlert.addAction(UIAlertAction(title: "Report_Cancel".LocalizableString(localization: "en"), style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        
                            refreshAlert .dismiss(animated: true, completion: nil)
                   }))

                    self.present(refreshAlert, animated: true, completion: nil)
                
            } else {
                let refreshAlert = UIAlertController(title: "Cancel_Bid_myAuction_Alret".LocalizableString(localization: "da"), message: "Cancel_Bid_myAuction_Message_Alret".LocalizableString(localization: "da"), preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            print("Handle Ok logic here")
                        self.cancelBid(index: sender.tag)
                   }))

                    refreshAlert.addAction(UIAlertAction(title: "Report_Cancel".LocalizableString(localization: "da"), style: .cancel, handler: { (action: UIAlertAction!) in
                            print("Handle Cancel Logic here")
                        
                            refreshAlert .dismiss(animated: true, completion: nil)
                   }))

                    self.present(refreshAlert, animated: true, completion: nil)
            }
            }
        
        @objc func didTapProfessionalSellerHistoryRepost(_ sender: UIButton) {
           
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.professionalSellerHisoryRepostAlert(title: "Repost_auction".LocalizableString(localization: "en"), message: "Are_you_sure_you_want_to_repost_this_auction".LocalizableString(localization: "en"), okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), index: sender.tag)
            } else{
                self.professionalSellerHisoryRepostAlert(title: "Repost_auction".LocalizableString(localization: "da"), message: "Are_you_sure_you_want_to_repost_this_auction".LocalizableString(localization: "da"), okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), index: sender.tag)
            }
            
        }
        @objc func didTapProfessionalSellerHistorySendOffer(_ sender: UIButton) {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.professionalSellerHisorySendOfferAlert(title: "Send_Offer".LocalizableString(localization: "en"), message: "Do_you_want_to_send_notification".LocalizableString(localization: "en"), okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), index: sender.tag)
            } else{
                self.professionalSellerHisorySendOfferAlert(title: "Send_Offer".LocalizableString(localization: "da"), message: "Do_you_want_to_send_notification".LocalizableString(localization: "da"), okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), index: sender.tag)
            }
            
        }
        func professionalSellerHisoryRepostAlert(title:String , message: String, okay: String, cancel:String,index:Int) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

                // Create the actions
            let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                self.callServiceGetRepostHistorySeller(index:index)
                }
            let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                   // NSLog("Cancel Pressed")
                }

                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)

                // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        func professionalSellerHisorySendOfferAlert(title:String , message: String, okay: String, cancel:String,index:Int) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

                // Create the actions
            let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   // NSLog("OK Pressed")
                let vc = Util.loadViewController(fromStoryboard: "ProfessionalSellerHistoyDiscountNotificationVC", storyboardName: "Home") as? ProfessionalSellerHistoyDiscountNotificationVC
//                vc?.productDetailId = dictProduct["id"] as! String
//                 vc?.productDetailId = self.personal[indexPath.item].id
              //  vc?.userId = self.personal[indexPath.item].userId
                
                
                vc?.strName = self.sellerHistory[index].companyName
              
                vc?.imgString = self.sellerHistory[index].productImage[0].thumbsProductImage
                if let aVc = vc {
                    aVc.hidesBottomBarWhenPushed = true
                    self.show(aVc, sender: nil)
            }
                
                
                
                }
            let cancelAction = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                   // NSLog("Cancel Pressed")
                }

                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)

                // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
        
        
        func cancelBid(index:Int)  {
            self.callServiceBidCancel(index: index)
        }
        
        func popUpRateSaller(isAnimated:Bool,index:Int) {
             let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
             let popup : RateNowPopUpVC = pop.instantiateViewController(withIdentifier: "RateNowPopUpVC") as! RateNowPopUpVC
            self.tabBarController?.tabBar.isHidden = true
            
            if isSellerProfile == true {
                popup.productId = self.sellerHistory[index].productId
                popup.strUserImg = self.sellerHistory[index].userImage
                if self.sellerHistory[index].firstName == "" && self.sellerHistory[index].lastName == ""{
                   popup.name = self.sellerHistory[index].companyName
               }else{
                   popup.name =  self.sellerHistory[index].firstName.capitalizingFirstLetter() + " " + self.sellerHistory[index].lastName.capitalizingFirstLetter()
               }
                popup.sellerId = self.sellerHistory[index].buyerId
            }else{
                popup.productId = self.BuyerHistory[index].productId
                popup.strUserImg = self.BuyerHistory[index].userImage
                if self.BuyerHistory[index].firstName == "" && self.BuyerHistory[index].lastName == ""{
                    popup.name = self.BuyerHistory[index].companyName
                }else{
                    popup.name =  self.BuyerHistory[index].firstName.capitalizingFirstLetter() + " " + self.BuyerHistory[index].lastName.capitalizingFirstLetter()
                }
                popup.sellerId = self.BuyerHistory[index].sellerId
            }
            popup.delagate = self
            self.presentOnRoot(with: popup, isAnimated: isAnimated)
        }
        @objc func didTapBuyerProfile(_ sender: UIButton) {
             if isSellerProfile == true {
                
             }else{
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
                    let popup : BuyerReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerReviewPopUpVC") as! BuyerReviewPopUpVC
                popup.userId = LoggedInUser.shared.id!
                popup.OtherUserId = self.BuyerHistory[sender.tag].sellerId
                  //  popup.delagate = self
                self.presentOnRoot(with: popup, isAnimated: true)
            }
        }
        @objc func didTapOnShowAllBid(_ sender: UIButton) {
        
            
            //self.present(vc!, animated: true, completion: nil)
      
        
            if self.sellerActiveAuction[sender.tag].role == "1" {
                let vc = Util.loadViewController(fromStoryboard: "ShowAllBidVC", storyboardName: "Home") as? ShowAllBidVC
                vc?.productId = self.sellerActiveAuction[sender.tag].productId
                vc?.name = self.sellerActiveAuction[sender.tag].selling
                vc?.delegate = self
                if self.sellerActiveAuction[sender.tag].productImage.count > 0 {
                    vc?.userImage = self.sellerActiveAuction[sender.tag].productImage[0].productImage!
                }
               self.navigationController?.pushViewController(vc!, animated: true)
            } else{
                let vc = Util.loadViewController(fromStoryboard: "ProfessionalShowAllBid", storyboardName: "Home") as? ProfessionalShowAllBid
                vc?.productId = self.sellerActiveAuction[sender.tag].productId
                vc?.name = self.sellerActiveAuction[sender.tag].selling
              //  vc?.delegate = self
                if self.sellerActiveAuction[sender.tag].productImage.count > 0 {
                    vc?.userImage = self.sellerActiveAuction[sender.tag].productImage[0].productImage!
                }
               self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            
        
        }
        
       
        @IBAction func actionOnActiveAction(_ sender:Any){
             K_TAG = 158
             if self.btnActiveAcutions.isSelected == false {
                self.btnActiveAcutions.isSelected = true
                 self.btnActiveAcutions.setTitleColor(.white, for: .normal)
                 self.btnInProgress.setTitleColor(.black, for: .normal)
                 self.btnHistory.setTitleColor(.black, for: .normal)
                 
                 self.btnActiveAcutions.backgroundColor = .black
                 self.btnInProgress.backgroundColor = .white
                 self.btnHistory.backgroundColor = .white
             }else{
                 self.btnActiveAcutions.isSelected = false
                 self.btnActiveAcutions.setTitleColor(.white, for: .normal)
                 self.btnInProgress.setTitleColor(.black, for: .normal)
                 self.btnHistory.setTitleColor(.black, for: .normal)
                 
                 self.btnActiveAcutions.backgroundColor = .black
                 self.btnInProgress.backgroundColor = .white
                 self.btnHistory.backgroundColor = .white
             }
            self.tabIndex = 0
             self.buyerActiveAuction = [ModelBuyerActiveAuctionResponseDatum]()
             self.sellerActiveAuction = [ModelSellerActiveAuctionResponseDatum]()
             
            if !isSellerProfile {
                 K_Type = "2"
                appDelegate.MyAuction = ""
            }else{
                     K_Type = "1"
                appDelegate.MyAuction = ""
                 }
             
            self.callServiceGetSellerActiveAcution(status: isSellerProfile, urlType: getAllUserProduct)
             
         }
         @IBAction func actionOnInProgress(_ sender:Any){
            K_TAG = 159
             if self.btnInProgress.isSelected == false {
                 self.btnInProgress.isSelected = true
                 
                 self.btnActiveAcutions.setTitleColor(.black, for: .normal)
                 self.btnInProgress.setTitleColor(.white, for: .normal)
                 self.btnHistory.setTitleColor(.black, for: .normal)
                 
                 self.btnActiveAcutions.backgroundColor = .white
                 self.btnInProgress.backgroundColor = .black
                 self.btnHistory.backgroundColor = .white
             }else{
                 self.btnInProgress.isSelected = false
                 
                 self.btnActiveAcutions.setTitleColor(.black, for: .normal)
                 self.btnInProgress.setTitleColor(.white, for: .normal)
                 self.btnHistory.setTitleColor(.black, for: .normal)
                 self.btnActiveAcutions.backgroundColor = .white
                 self.btnInProgress.backgroundColor = .black
                 self.btnHistory.backgroundColor = .white
             }
            self.tabIndex = 1
            self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
            self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
            if !isSellerProfile {
                 K_Type = "3"
                appDelegate.MyAuction = "buyerInprogress"
                self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
                 self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserHistoryProduct)
                 }else{
                 K_Type = "3"
                    appDelegate.MyAuction = "sellerInprogress"
                    self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
                self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserProduct)
             }
        
        
        }
         @IBAction func actionOnInHistory(_ sender:Any){
             K_TAG = 160
             if self.btnHistory.isSelected == false {
                 self.btnHistory.isSelected = true
                 
                 self.btnActiveAcutions.setTitleColor(.black, for: .normal)
                 self.btnInProgress.setTitleColor(.black, for: .normal)
                 self.btnHistory.setTitleColor(.white, for: .normal)
                 
                 self.btnActiveAcutions.backgroundColor = .white
                 self.btnInProgress.backgroundColor = .white
                 self.btnHistory.backgroundColor = .black
             }else{
                 self.btnHistory.isSelected = false
                 
                 self.btnActiveAcutions.setTitleColor(.black, for: .normal)
                 self.btnInProgress.setTitleColor(.black, for: .normal)
                 self.btnHistory.setTitleColor(.white, for: .normal)
                 
                 self.btnActiveAcutions.backgroundColor = .white
                 self.btnInProgress.backgroundColor = .white
                 self.btnHistory.backgroundColor = .black
             }
            self.tabIndex = 2
            self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
            self.sellerHistory = [ModelHistorySellerResponseDatum]()
             if !isSellerProfile {
                 K_Type = "2"
                appDelegate.MyAuction = "buyerHistory"
                self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
                self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
                 
             }else{
                 K_Type = "1"
                appDelegate.MyAuction = "sellerHistory"
                self.sellerHistory = [ModelHistorySellerResponseDatum]()
                self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
             }
             
         }
          @IBAction func actionOnSellerProfile(_ sender:Any){
                 self.isSellerProfile = true
             if !self.btnSellerProfile.isSelected {
                 self.btnSellerProfile.isSelected = true
                 self.btnSellerProfile.setTitleColor(.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                 self.btnBuyerProfile.setTitleColor(.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
             }else{
                 self.btnSellerProfile.isSelected = false
                 self.btnSellerProfile.setTitleColor(.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                 self.btnBuyerProfile.setTitleColor(.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
             }
            self.sellerActiveAuction = [ModelSellerActiveAuctionResponseDatum]()
            self.buyerActiveAuction = [ModelBuyerActiveAuctionResponseDatum]()
            self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
            self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
            self.sellerHistory = [ModelHistorySellerResponseDatum]()
            self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
            
            if K_TAG == 158 {
                      K_Type = "1"
                     self.callServiceGetSellerActiveAcution(status: isSellerProfile, urlType: getAllUserProduct)
                 } else if K_TAG == 159 {
                     K_Type = "3"
                     self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserProduct)
             } else if K_TAG == 160 {
                     K_Type = "1"
                    self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
             }
             
             UIView.animate(withDuration: 0.3) {
                 self.constraintLeadingSlideLable.constant = self.btnSellerProfile.frame.origin.x
                 self.view.layoutIfNeeded()
             }
         }
             @IBAction func actionOnBuyerProfile(_ sender:Any){
                 self.isSellerProfile = false
                  if !self.btnBuyerProfile.isSelected {
                     self.btnBuyerProfile.isSelected = true
                     self.btnBuyerProfile.setTitleColor(.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                     self.btnSellerProfile.setTitleColor(.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
                 }else{
                     self.btnSellerProfile.isSelected = false
                     self.btnBuyerProfile.setTitleColor(.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                     self.btnSellerProfile.setTitleColor(.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
                 }
                self.sellerActiveAuction = [ModelSellerActiveAuctionResponseDatum]()
                self.buyerActiveAuction = [ModelBuyerActiveAuctionResponseDatum]()
                self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
                self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
                self.sellerHistory = [ModelHistorySellerResponseDatum]()
                self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
                 
                if K_TAG == 158 {
                         K_Type = "2"
                        self.callServiceGetSellerActiveAcution(status: isSellerProfile, urlType: getAllUserProduct)
                 } else if K_TAG == 159 {
                         K_Type = "3"
                        self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserHistoryProduct)
                 } else if K_TAG == 160 {
                         K_Type = "2"
                        self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
                 }
                    UIView.animate(withDuration: 0.3) {
                     self.constraintLeadingSlideLable.constant = self.btnBuyerProfile.frame.origin.x
                     self.view.layoutIfNeeded()
                 }

             }
        
         func callServiceGetInProgressSellerProfile(status:Bool,urlType:String) {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
         let parameter: [String: Any] = ["type":K_Type,
                                            "language": MyDefaults().language ?? AnyObject.self,
                                            "user_id": LoggedInUser.shared.id! ,
                                            "latitude":LoggedInUser.shared.latitude!,
                                            "lognitude":LoggedInUser.shared.longitude!]
            print(parameter)
            HTTPService.callForPostApi(url:urlType , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                        debugPrint(response)
                      //  HideHud()
                        if response.count != nil {
                            let status = response["responseCode"] as! Int
                            let message = response["message"] as! String
                            if status == 200  {
                                if !self.isSellerProfile {
                                    let response = ModelinProgressBuyer.init(fromDictionary: response as! [String : Any])
                                            if response.responseData.count > 0{
                                            self.inprogressBuyer = response.responseData
                                            self.collectionView.isHidden = false
                                            self.collectionView.reloadData()
                                            }else{
                                            self.collectionView.isHidden = true
                                                                       }
                                }else{
                                    let response = ModelinProgress.init(fromDictionary: response as! [String : Any])
                                        if response.responseData.count > 0{
                                            self.inProgressSeller = response.responseData
                                               self.collectionView.isHidden = false
                                               self.collectionView.reloadData()
                                        }else{
                                            self.collectionView.isHidden = true
                                    }
                                }
                                } else if status == 500 {
                                    self.collectionView.isHidden = true
                                   // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                            }
                            }else{
                            self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                        }
                    }
       
        }
        func callServiceGetRepostHistorySeller(index:Int) {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
           let parameter: [String: Any] = ["language": MyDefaults().language ?? AnyObject.self,
                                            "product_id": self.sellerHistory[index].productId!,
                                            "user_id":LoggedInUser.shared.id!]
               print(parameter)
            HTTPService.callForPostApi(url:getSellerHistoryRepostAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                           debugPrint(response)
                         //  HideHud()
                           if response.count != nil {
                               let status = response["responseCode"] as! Int
                               let message = response["message"] as! String
                               if status == 200  {
                                self.K_Type = "1"
                                self.sellerHistory = [ModelHistorySellerResponseDatum]()
                                self.callServiceGetHistory(status: self.isSellerProfile, urlType: getAllUserHistoryProduct)
                                   
                                   self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                   
                               } else if status == 500 {
                                       self.collectionView.isHidden = true
                                       self.showErrorPopup(message: message, title: ALERTMESSAGE)
                               }
                               }else{
                               self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                           }
                       
               }
          }
        func callServiceGetHistory(status:Bool,urlType:String) {
           print(urlType)
            
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
          let parameter: [String: Any] = ["type":K_Type,
                                             "language": MyDefaults().language ?? AnyObject.self,
                                             "user_id": LoggedInUser.shared.id! ,
                                             "latitude":LoggedInUser.shared.latitude!,
                                             "lognitude":LoggedInUser.shared.longitude!]
             print(parameter)
            HTTPService.callForPostApi(url:urlType , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                         debugPrint(response)
                       //  HideHud()
                         if response.count != nil {
                             let status = response["responseCode"] as! Int
                             let message = response["message"] as! String
                             if status == 200  {
                                 if !self.isSellerProfile {
                                     let response = ModelHistoryBuyerProfile.init(fromDictionary: response as! [String : Any])
                                             if response.responseData.count > 0{
                                             self.BuyerHistory = response.responseData
                                             self.collectionView.isHidden = false
                                             self.collectionView.reloadData()
                                             }else{
                                             self.collectionView.isHidden = true
                                                                        }
                                 }else{
                                     let response = ModelHistorySellerProfile.init(fromDictionary: response as! [String : Any])
                                         if response.responseData.count > 0{
                                             self.sellerHistory = response.responseData
                                                self.collectionView.isHidden = false
                                                self.collectionView.reloadData()
                                         }else{
                                             self.collectionView.isHidden = true
                                     }
                                 }
                                 
                                 
                                 
                      } else if status == 500 {
                                     self.collectionView.isHidden = true
                                    // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                             }
                             }else{
                             self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                         }
                     
             }
        
         }
        func callServiceGetChangeStaus(orderId: String) {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
          let parameter: [String: Any] = [
                                             "language": MyDefaults().language ?? AnyObject.self,
                                             "order_id":orderId]
            print(parameter)
            HTTPService.callForPostApi(url:getMakeOrderCompltedAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                         debugPrint(response)
                       //  HideHud()
                         if response.count != nil {
                             let status = response["responseCode"] as! Int
                             let message = response["message"] as! String
                             if status == 200  {
//                                 if !self.isSellerProfile {
//                                     let response = ModelinProgressBuyer.init(fromDictionary: response as! [String : Any])
//                                             if response.responseData.count > 0{
//                                             self.inprogressBuyer = response.responseData
//                                             self.collectionView.isHidden = false
//                                             self.collectionView.reloadData()
//                                             }else{
//                                             self.collectionView.isHidden = true
//                                                                        }
//                                 }else{
//                                     let response = ModelinProgress.init(fromDictionary: response as! [String : Any])
//                                         if response.responseData.count > 0{
//                                             self.inProgressSeller = response.responseData
//                                                self.collectionView.isHidden = false
//                                                self.collectionView.reloadData()
//                                         }else{
//                                             self.collectionView.isHidden = true
//                                     }
//                                 }
                              
                              
                                if (MyDefaults().language ?? "") as String ==  "en"{
                                    self.showMessage(index: 0, Message: "Deal_Completed_Item_Moved_to_History".LocalizableString(localization: "en"),title:"Deal_completed_Auction".LocalizableString(localization: "en"))
                                } else{
                                    self.showMessage(index: 0, Message: "Deal_Completed_Item_Moved_to_History".LocalizableString(localization: "da"),title:"Deal_completed_Auction".LocalizableString(localization: "da"))
                                }
                                
                                 
                                 
                      } else if status == 500 {
                                     self.collectionView.isHidden = true
                                    // self.showErrorPopup(message: message, title: ALERTMESSAGE)
                             }
                             }else{
                             self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                         }
                     
             }
        
         }
        func callServiceDeleteAPI(index:Int) {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
                  let parameter: [String: Any] = [
                                                     "language": MyDefaults().language ?? AnyObject.self,
                                                     "product_id":self.sellerActiveAuction[index].productId!]
                    
                    
                   print(parameter)
            HTTPService.callForPostApi(url:deleteProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                                 debugPrint(response)
                               //  HideHud()
                                 if response.count != nil {
                                     let status = response["responseCode"] as! Int
                                     let message = response["message"] as! String
                                     if status == 200  {
       
                                        // self.showMessage(index: 0, Message: "Deal Completed,Item Moved to History",title:"Deal Completed")
                                        self.sellerActiveAuction.remove(at: index)
                                       // let indexPath = IndexPath(item: index, section: 0)
                                        self.collectionView.reloadData()
                                        self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                         
                              } else if status == 500 {
                                             self.collectionView.isHidden = true
                                             self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                     }
                                     }else{
                                     self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                                 }
                             
                     }
                
                 }
        func callServiceBidCancel(index:Int) {
            var loading = ""
            if (MyDefaults().language ?? "") as String ==  "en"{
                loading = "Loading".LocalizableString(localization: "en")
            } else{
              loading = "Loading".LocalizableString(localization: "da")
            }
                   let parameter: [String: Any] = [ "language": MyDefaults().language ?? AnyObject.self,
                                                    "bid_id":self.buyerActiveAuction[index].bidId!]
            print(parameter)
            HTTPService.callForPostApi(url:getBidCancelAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                                  debugPrint(response)
                                //  HideHud()
                                  if response.count != nil {
                                      let status = response["responseCode"] as! Int
                                      let message = response["message"] as! String
                                      if status == 200  {
                                        self.buyerActiveAuction.remove(at: index)
                                        self.collectionView.reloadData()
                                        self.showErrorPopup(message: message, title: ALERTMESSAGE)

                               } else if status == 500 {
                                              self.collectionView.isHidden = true
                                              self.showErrorPopup(message: message, title: ALERTMESSAGE)
                                      }
                                      }else{
                                      self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                                  }

                      }

                  }
        func showMessage(index:Int,Message: String,title:String) {
            let commonAlert = CommonAlertViewController()
            commonAlert.delegate = self
            commonAlert.index = index
            commonAlert.showActionAlertView(title: title, message: Message, vc: self)
        }
        func deleteSellerProfile(index:Int,Message: String,title:String) {
            let commonAlert = CommonPopupAlert()
            commonAlert.delegate = self
           // commonAlert.index = index
            commonAlert.indexSelection = index
            commonAlert.showAlertPopUp(title: title, message: Message, vc: self)
        }


}
extension MyAuctionVC : alertDelegate,getSelectRateNowDelegate,alertpopUpDelegate,getSelecteTabs,getSelectMapCoordinate,delegatetShowAllBidAcceptrequest {
    func delegatSelectAllategoryAccept() {
        self.senderInprogressBuyer()
    }
    
    func delegatSelectCodinateofMap(latitude: String, longitude: String, distance: String, isMapSelected: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func delegateSelectTabs(getTile: String, selecteTab: Bool) {
        
        if !selecteTab  {
            if getTile == "activeSellerProfile" {
                
            } else if getTile == "inprogressSellerProfile" {
                
            } else if getTile == "historySellerProfile" {
        
            }
        } else{
            if getTile == "activeBuyerProfile" {
                
            } else if getTile == "inprogressBuyerProfile" {
               // self.senderInprogressBuyer()
            } else if getTile == "historyBuyerProfile" {
        
            }
        }
    }
    func okActionPopUp(controller: UIViewController, index: Int, VC: String) {
        if VC == "" {
            self.callServiceDeleteAPI(index: index)
        }else  if VC == "duplicate" {
                    let vc = Util.loadViewController(fromStoryboard: "DuplicateVC", storyboardName: "Home") as? DuplicateVC
                   vc?.productId = self.sellerActiveAuction[index].productId
                   vc?.objActiveAuction = self.sellerActiveAuction[index]
                   vc?.titleName = "Duplicate Auction"
                   self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func cancelActionPopUp(controller: UIViewController){
        
    }
   func delegatRateNot() {
    self.tabBarController?.tabBar.isHidden = false
    self.moveOnHistory()
    }
    func delegatCancelRateView(){
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func okAction(controller: UIViewController, index: Int) {
        
        self.moveOnHistory()
    }
    
    func cancelAction(controller: UIViewController) {
        
    }
    func moveOnHistory()  {
        K_TAG = 160
      if self.btnHistory.isSelected == false {
          
          self.btnHistory.isSelected = true
          self.btnActiveAcutions.setTitleColor(.black, for: .normal)
          self.btnInProgress.setTitleColor(.black, for: .normal)
          self.btnHistory.setTitleColor(.white, for: .normal)
          self.btnActiveAcutions.backgroundColor = .white
          self.btnInProgress.backgroundColor = .white
          self.btnHistory.backgroundColor = .black
      }else{
          self.btnHistory.isSelected = false
          self.btnActiveAcutions.setTitleColor(.black, for: .normal)
          self.btnInProgress.setTitleColor(.black, for: .normal)
          self.btnHistory.setTitleColor(.white, for: .normal)
          self.btnActiveAcutions.backgroundColor = .white
          self.btnInProgress.backgroundColor = .white
          self.btnHistory.backgroundColor = .black
      }
     self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
     self.sellerHistory = [ModelHistorySellerResponseDatum]()
      if !isSellerProfile {
          K_Type = "2"
         self.BuyerHistory = [ModelHistoryBuyerResponseDatum]()
         self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
          
      }else{
          K_Type = "1"
         self.sellerHistory = [ModelHistorySellerResponseDatum]()
         self.callServiceGetHistory(status: isSellerProfile, urlType: getAllUserHistoryProduct)
      }
    }
    func moveToInProgress()  {
//        if (MyDefaults().language ?? "") as String ==  "en"{
//                self.changeLanguage(strLanguage: "en")
//            } else{
//                self.changeLanguage(strLanguage: "da")
//            }
        K_TAG = 159
           
        self.btnActiveAcutions.setTitleColor(.black, for: .normal)
        self.btnInProgress.setTitleColor(.white, for: .normal)
        self.btnHistory.setTitleColor(.black, for: .normal)
        
        self.btnActiveAcutions.backgroundColor = .white
        self.btnInProgress.backgroundColor = .black
        self.btnHistory.backgroundColor = .white
        
        self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
            self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
            self.isSellerProfile = false
                K_Type = "3"
                 
                 self.btnBuyerProfile.setTitleColor(.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
                self.btnSellerProfile.setTitleColor(.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
            UIView.animate(withDuration: 0.3) {
            self.constraintLeadingSlideLable.constant = self.btnBuyerProfile.frame.origin.x
            self.view.layoutIfNeeded()
        }
        self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
        self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserHistoryProduct)
    }
    func senderInprogressBuyer(){
        K_TAG = 159
     if self.btnInProgress.isSelected == false {
         self.btnInProgress.isSelected = true
         
         self.btnActiveAcutions.setTitleColor(.black, for: .normal)
         self.btnInProgress.setTitleColor(.white, for: .normal)
         self.btnHistory.setTitleColor(.black, for: .normal)
         
         self.btnActiveAcutions.backgroundColor = .white
         self.btnInProgress.backgroundColor = .black
         self.btnHistory.backgroundColor = .white
     }else{
         self.btnInProgress.isSelected = false
         
         self.btnActiveAcutions.setTitleColor(.black, for: .normal)
         self.btnInProgress.setTitleColor(.white, for: .normal)
         self.btnHistory.setTitleColor(.black, for: .normal)
         self.btnActiveAcutions.backgroundColor = .white
         self.btnInProgress.backgroundColor = .black
         self.btnHistory.backgroundColor = .white
     }
   
    self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
    self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
        if !isSellerProfile {
         K_Type = "3"
         self.inprogressBuyer = [ModelinProgressBuyerResponseDatum]()
         self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserHistoryProduct)
         }else{
         K_Type = "3"
        self.inProgressSeller = [ModelInProgressSellerResponseDatum]()
        self.callServiceGetInProgressSellerProfile(status: isSellerProfile, urlType: getAllUserProduct)
     }
    }
    func changeLanguage(strLanguage:String) {
        
        self.btnSellerProfile.setTitle("What_i_Sell".LocalizableString(localization: strLanguage), for: .normal)
        self.btnBuyerProfile.setTitle("WHAT_I_BUY".LocalizableString(localization: strLanguage), for: .normal)
        self.btnActiveAcutions.setTitle("My_Auctions".LocalizableString(localization: strLanguage), for: .normal)
        self.btnInProgress.setTitle("In_progress".LocalizableString(localization: strLanguage), for: .normal)
        self.btnHistory.setTitle("History".LocalizableString(localization: strLanguage), for: .normal)
        
        self.lblNODATAFOUND.text = "No_Record_Found".LocalizableString(localization: strLanguage)
        self.txtSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
        
        }
    
}

