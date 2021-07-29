//
//  HomeVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 1/24/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import UILoadControl
import MapKit
class HomeVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var collectionViewPost: UICollectionView!
    @IBOutlet weak var collectionCategory: UICollectionView!
    @IBOutlet weak var btnPersonal: UIButton!
    @IBOutlet weak var btnProfessional: UIButton!
    @IBOutlet weak var NORECORDFOUND: UILabel!
     @IBOutlet weak var constraintLeadingSlideLable : NSLayoutConstraint!
    var category = [["category_name":"Category","category_image":"23","created_at":"2020-09-07 16:24:39","id":"1","ordering":"10","status":"1","subcategory_status":"1"]]
    // MARK: - Property initialization
    private var categoryId = ""
    private var subCategoryId = ""
    private var arrProduct = NSMutableArray()
     private var arrayCategory = NSMutableArray()
    private var arrSubcategory = NSMutableArray()
    private var dictProduct = NSDictionary()
    private var locManager = CLLocationManager()
    private var search: String = ""
    private var offerPrice = 0
    private var lastBidAmount = 0
    private var timer: Timer?
    private var timeCounter: Int = 0
    private var latitdude = ""
    private var longitutde = ""
    var refreshControl : UIRefreshControl!
    var isCategory = false
    var isPersonal = true
    let geoCoder = CLGeocoder()
    var personal = [ModelHomePersonalResponseDatum]()
    var professional = [ModelProfessionalResponseDatum]()
    var radiusKm = ""
    var tabIndex : Int = 0
    var pageNumber: Int = 0
    var isLoading:Bool = false
    //var isFirstCallService:Bool = false
    var footerView:CustomFooterView?
    let footerViewReuseIdentifier = "RefreshFooterView"
   
    var timeIntervalInSecond: TimeInterval? {
        didSet {
            startTimer()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.hexStringToUIColor(hex: "#02BBCA"), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:tabBar.frame.height), lineHeight: 2.0)
        self.NORECORDFOUND.isHidden = true
        self.tabBarController?.delegate = self
        self.collectionViewPost.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
        self.collectionViewPost.register(UINib(nibName: "PersonalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PersonalCollectionViewCell")
        self.popUpFilter(isAnimated:false)
        self.txfSearch.delegate = self
        txfSearch.addTarget(self, action: #selector(didTapOnSearch), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationFromDiscountNotification(notification:)), name: Notification.Name("NotificationIdentifierRemoveFilterFronDiscountNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.NotificationIdentifierChnageLanguage(notification:)), name: Notification.Name("NotificationIdentifierChnageLanguage"), object: nil)
        self.collectionViewPost.loadControl = UILoadControl(target: self, action: #selector(loadMore(sender:)))
        self.collectionViewPost.loadControl?.heightLimit = 50.0 //The default is 80.0
        tabIndex  = 100
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
       
         self.latitdude =  String(format: "%7f", currentLocation.coordinate.latitude)    //location.coordinate.latitude
         self.longitutde = String(format: "%7f", currentLocation.coordinate.longitude)
        }
        
        
//        if  isConnectedToInternet() {
//            if tabIndex == 100 {
//                self.isSeletedPerson(isPerson: true)
//            } else{
//                self.isSeletedPerson(isPerson: false)
//            }
//        } else {
//        self.showErrorPopup(message: internetConnetionError, title: alert)
//        }
    
//        self.refreshControl = UIRefreshControl()
//            self.collectionViewPost!.alwaysBounceVertical = true
//            self.refreshControl.tintColor = UIColor.red
//            self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
//            self.collectionViewPost!.addSubview(refreshControl)
    }
    @objc func loadData() {
        self.collectionViewPost!.refreshControl?.beginRefreshing()
       
       stopRefresher()         //Call this to stop refresher
     }

    func stopRefresher() {
        self.collectionViewPost!.refreshControl?.endRefreshing()
     }
    
   
    @objc func methodOfReceivedNotificationFromDiscountNotification(notification: Notification) {
        self.dismiss(animated: false, completion: nil)
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @objc func NotificationIdentifierChnageLanguage(notification: Notification) {
            self.isSeletedPerson(isPerson: true)
        }
    func changeLanguage(strLanguage:String) {
            self.txfSearch.placeholder = "Search".LocalizableString(localization: strLanguage)
            //self.lblNotRegistered.text = "NotregisterdYet".LocalizableString(localization: strLanguage)
        
        self.btnPersonal.setTitle("Personal".LocalizableString(localization: strLanguage).uppercased(), for: .normal)
            self.btnProfessional.setTitle("Professional".LocalizableString(localization: strLanguage).uppercased(), for: .normal)
            self.NORECORDFOUND.text = "No_Record_Found".LocalizableString(localization: strLanguage)
        }
    func popUpFilter(isAnimated:Bool) {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
         let popup : FilterVC = pop.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        // popup.data = response
         // popup.isCategory = true
         popup.delagate = self
        //self.presentOnRoot(with: popup, isAnimated: isAnimated)
       self.navigationController?.pushViewController(popup, animated: false)
    }
    override func viewDidLayoutSubviews() {
//        collectionViewPost.contentInsetAdjustmentBehavior = .never
//        collectionViewPost.contentInset.bottom = collectionView.safeAreaInsets.bottom
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hidesBottomBarWhenPushed = false
        // For use in foreground
        locManager.requestWhenInUseAuthorization()
        self.personal = [ModelHomePersonalResponseDatum]()
        self.professional = [ModelProfessionalResponseDatum]()
        self.pageNumber = 0
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        print(self.tabIndex)
        if  self.isPersonal {
            if  isConnectedToInternet() {
            self.isSeletedPerson(isPerson: true)
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        } else{
            if  isConnectedToInternet() {
            self.isSeletedPerson(isPerson: false)
            } else {
            self.showErrorPopup(message: internetConnetionError, title: alert)
            }
        }
        
        if  isConnectedToInternet() {
            self.getCategoryAPI()
            
        } else{
            self.showErrorPopup(message: internetConnetionError, title: alert)
        }
        
        self.collectionCategory.reloadData()
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
    }

    // MARK: - Action Methods
    func isSeletedPerson(isPerson:Bool)  {
        self.personal = [ModelHomePersonalResponseDatum]()
        self.professional = [ModelProfessionalResponseDatum]()
        self.pageNumber = 0
        if isPerson == true {
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnPersonal.frame.origin.x
               // self.personal = [ModelHomePersonalResponseDatum]()
                self.view.layoutIfNeeded()
            }
            self.tabIndex = 100
            self.isPersonal = true
                self.getProductAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
           
            }else{
            UIView.animate(withDuration: 0.3) {
                self.constraintLeadingSlideLable.constant = self.btnProfessional.frame.origin.x
              //  self.professional = [ModelProfessionalResponseDatum]()
                self.view.layoutIfNeeded()
            }
            self.tabIndex = 200
            
            self.isPersonal = false
            self.getProductAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
                
        }
    }
    @IBAction func actionOnPersonal(_ Sender:UIButton){
        if !self.btnPersonal.isSelected {
            self.btnPersonal.isSelected = true
            self.btnProfessional.isSelected = false
            self.btnPersonal.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnProfessional.setTitleColor(UIColor.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
        }else{
            self.btnPersonal.isSelected = true
            self.btnProfessional.isSelected = false
            self.btnPersonal.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnProfessional.setTitleColor(UIColor.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
            
        }
        self.isSeletedPerson(isPerson: true)
       }
    @IBAction func actionOnSearch(_ Sender:UIButton){
        self.pageNumber = 0
        if isPersonal == true {
            self.getProductSearchAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
         }else{
            self.getProductSearchAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius:self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
        }
        }
    @objc func didTapOnSearch(textField: UITextField) {
        self.pageNumber = 0
       // self.personal = [ModelHomePersonalResponseDatum]()
       
        if self.txfSearch.text!.count > 0 {
         if isPersonal == true {
            self.getProductSearchAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: textField.text!, isMapSelected: false)
          }else{
            self.getProductSearchAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: textField.text!, isMapSelected: false)
         }
    }else{
        self.txfSearch.text = ""
       // self.professional = [ModelProfessionalResponseDatum]()
        if isPersonal == true {
            self.getProductSearchAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
        }  else{
            self.getProductSearchAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
        }
    
    }
    
    }
    @IBAction func actionOnCross(_ Sender:UIButton){
        self.category = [["category_name":"Category","category_image":"23","created_at":"2020-09-07 16:24:39","id":"1","ordering":"10","status":"1","subcategory_status":"1"]]
        self.categoryId = ""
        self.subCategoryId = ""
        if isPersonal == true {
            self.getProductAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
        }  else{
            self.getProductAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
        }
        self.collectionCategory.reloadData()
    }
    @IBAction func actionOnProfessional(_ Sender:UIButton){
        if !self.btnProfessional.isSelected {
            self.btnProfessional.isSelected = true
            self.btnPersonal.isSelected = false
            self.btnProfessional.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnPersonal.setTitleColor(UIColor.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
        }else{
            self.btnProfessional.isSelected = true
            self.btnPersonal.isSelected = false
            self.btnProfessional.setTitleColor(UIColor.hexStringToUIColor(hex: "#02BBCA"), for: .normal)
            self.btnPersonal.setTitleColor(UIColor.hexStringToUIColor(hex: "#7D7D7D"), for: .normal)
            
        }
        self.isSeletedPerson(isPerson: false)
    
    }
    @IBAction func btnFilter_Action(_ sender: UIButton) {
        self.popUpFilter(isAnimated: true)
    }
    @IBAction func btnPlaceBid_Action(_ sender: UIButton) {
        
    }
    // MARK: - Private Methods
    private func startTimer() {
        if let interval = timeIntervalInSecond {
            timeCounter = Int(interval)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    @objc func updateCounter() {
        guard timeCounter >= 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        
        let hours = timeCounter / 3600
        let minutes = timeCounter / 60 % 60
        let seconds = timeCounter % 60
        let temp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
       // lblTime.text = "\(temp)"
        
        timeCounter -= 1
    }

    // MARK: - API Methods
    
    func getProductAPI_Call(userType:String, latitude: String, longitude: String, radius: String , categoryId: String, subCategoryId: String,search:String, isMapSelected: Bool) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["user_type":userType,
                                        "language": MyDefaults().language ?? AnyObject.self,
                                        "user_id": LoggedInUser.shared.id ?? AnyObject.self,
                                        "latitude": latitude,
                                        "lognitude":longitude,
                                        "category_id":categoryId,
                                        "subcategory_id":subCategoryId,
                                        "distance":radius,
                                        "search":search,
                                        "offset":self.pageNumber]
        print(parameter)
        HTTPService.callForPostApi(url:getAllProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                         
                            if self.isPersonal == true {
                                let response = ModelHomePersonal.init(fromDictionary: response as! [String : Any])
                                if response.responseData.count > 0{
                                     self.personal += response.responseData
                                     self.collectionViewPost.isHidden = false
                                     self.isLoading = false
                                    //  self.refreshControl.endRefreshing()
                                     self.pageNumber = self.pageNumber + 1
                                     self.collectionViewPost.reloadData()
                                   }else{
                                     self.collectionViewPost.isHidden = false
                                     self.NORECORDFOUND.isHidden = false
                                    //self.showToast(message: message, font: .systemFont(ofSize: 12.0))
                                     self.collectionViewPost.reloadData()
                                }
                            }else{
                                 let response = ModelProfessional.init(fromDictionary: response as! [String : Any])
                                 if response.responseData.count > 0{
                                     self.professional += response.responseData
                                     self.collectionViewPost.isHidden = false
                                     self.isLoading = false
                                     self.pageNumber = self.pageNumber + 1
                                     // self.isLoading = false
                                     self.collectionViewPost.reloadData()
                                     }else{
                                       // self.isLoading = true
                                     self.collectionViewPost.isHidden = false
                                     self.NORECORDFOUND.isHidden = false
                                       // self.showToast(message: message, font: .systemFont(ofSize: 12.0))
                                     self.collectionViewPost.reloadData()
                                     }
                               }
                                    self.collectionViewPost.loadControl?.endLoading()
                           
                            } else if status == 500 {
                                self.isLoading = true
                                self.collectionViewPost.isHidden = true
                                self.NORECORDFOUND.isHidden = false
                                self.collectionViewPost.loadControl?.endLoading()
                               // self.collectionViewPost.reloadData()
                              
//                                if (MyDefaults().language ?? "") as String ==  "en"{
//                                    self.showErrorPopup(message: "No Record Found", title: ALERTMESSAGE)
//                                } else{
//                                    self.showErrorPopup(message: "Ingen registrering fundet", title: ALERTMESSAGE)
//                                }
                                
                            }
                        }else{
                      //  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
      //  self.getCategoryAPI()
    }
    func getProductSearchAPI_Call(userType:String, latitude: String, longitude: String, radius: String , categoryId: String, subCategoryId: String,search:String, isMapSelected: Bool) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["user_type":userType,
                                        "language": MyDefaults().language ?? AnyObject.self,
                                        "user_id": LoggedInUser.shared.id ?? AnyObject.self,
                                        "latitude": latitude,
                                        "lognitude":longitude,
                                        "category_id":categoryId,
                                        "subcategory_id":subCategoryId,
                                        "distance":radius,
                                        "search":search,
                                        "offset":self.pageNumber]
        print(parameter)
        HTTPService.callForPostApi(url:getAllProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        self.personal = [ModelHomePersonalResponseDatum]()
                        self.professional = [ModelProfessionalResponseDatum]()
                        if status == 200  {
                            
                            if self.isPersonal == true {
                                let response = ModelHomePersonal.init(fromDictionary: response as! [String : Any])
                                if response.responseData.count > 0{
                                    self.personal += response.responseData
                                    self.collectionViewPost.isHidden = false
                                    self.isLoading = false
                                    //  self.refreshControl.endRefreshing()
                                    self.pageNumber = self.pageNumber + 1
                                    self.collectionViewPost.reloadData()
                                   }else{
                                        self.collectionViewPost.isHidden = true
                                        self.NORECORDFOUND.isHidden = false
                                }
                            }else{
                                 let response = ModelProfessional.init(fromDictionary: response as! [String : Any])
                                 if response.responseData.count > 0{
                                     self.professional += response.responseData
                                     self.collectionViewPost.isHidden = false
                                     self.isLoading = false
                                     self.pageNumber = self.pageNumber + 1
                                     self.collectionViewPost.reloadData()
                                   // self.isLoading = false
                                     }else{
                                       // self.isLoading = true
                                        self.collectionViewPost.isHidden = true
                                        self.NORECORDFOUND.isHidden = false
                                     }
                            }
                           // self.scrollToBottomAnimated(animated: true)
                            } else if status == 500 {
                                self.isLoading = true
                                self.collectionViewPost.isHidden = true
                                self.NORECORDFOUND.isHidden = false
                                self.txfSearch.resignFirstResponder()

                               
                            
//                                if (MyDefaults().language ?? "") as String ==  "en"{
//                                    self.showErrorPopup(message: "No Record Found", title: ALERTMESSAGE)
//                                } else{
//                                    self.showErrorPopup(message: "Ingen registrering fundet", title: ALERTMESSAGE)
//                                }
                                
                            }
                        }else{
                      //  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
      //  self.getCategoryAPI()
    }
    func getProductPaggingAPI_Call(userType:String, latitude: String, longitude: String, radius: String , categoryId: String, subCategoryId: String,search:String, isMapSelected: Bool) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["user_type":userType,
                                        "language": MyDefaults().language ?? AnyObject.self,
                                        "user_id": LoggedInUser.shared.id ?? AnyObject.self,
                                        "latitude": latitude,
                                        "lognitude":longitude,
                                        "category_id":categoryId,
                                        "subcategory_id":subCategoryId,
                                        "distance":radius,
                                        "search":search,
                                        "offset":self.pageNumber]
        print(parameter)
        HTTPService.callForPostApi(url:getAllProductAPI , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        
                        if status == 200  {
                            
                            if self.isPersonal == true {
                                let response = ModelHomePersonal.init(fromDictionary: response as! [String : Any])
                                if response.responseData.count > 0{
                                    self.personal += response.responseData
                                    self.collectionViewPost.isHidden = false
                                    self.isLoading = false
                                    //  self.refreshControl.endRefreshing()
                                    self.pageNumber = self.pageNumber + 1
                                    self.collectionViewPost.reloadData()
                                   }else{
                                        self.collectionViewPost.isHidden = true
                                        self.NORECORDFOUND.isHidden = false
                                }
                            }else{
                                 let response = ModelProfessional.init(fromDictionary: response as! [String : Any])
                                 if response.responseData.count > 0{
                                     self.professional += response.responseData
                                     self.collectionViewPost.isHidden = false
                                     self.isLoading = false
                                     self.pageNumber = self.pageNumber + 1
                                     self.collectionViewPost.reloadData()
                                   // self.isLoading = false
                                     }else{
                                       // self.isLoading = true
                                        self.collectionViewPost.isHidden = true
                                        self.NORECORDFOUND.isHidden = false
                                     }
                            }
                           // self.scrollToBottomAnimated(animated: true)
                            } else if status == 500 {
                                self.isLoading = true
                               self.collectionViewPost.isHidden = false
                                self.NORECORDFOUND.isHidden = false
                                self.txfSearch.resignFirstResponder()

                               
                            
//                                if (MyDefaults().language ?? "") as String ==  "en"{
//                                    self.showErrorPopup(message: "No Record Found", title: ALERTMESSAGE)
//                                } else{
//                                    self.showErrorPopup(message: "Ingen registrering fundet", title: ALERTMESSAGE)
//                                }
                                
                            }
                        }else{
                      //  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                
        }
      //  self.getCategoryAPI()
    }
    private func getCategoryAPI() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
    //    if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
    
        let postParams: [String: AnyObject] =
            [
                kAPI_Language   :MyDefaults().language as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.getCategory(postParams), callerObj: self, showHud: true, text: loading) { [weak self] (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                self?.arrProduct.removeAllObjects()
                self?.collectionViewPost.reloadData()
                return
            }
            DLog(message: "\(jsonObj)")
            
            if jsonObj["category_data"].arrayObject != nil {
                let arrTemp = jsonObj["category_data"].arrayObject! as NSArray
                self?.arrayCategory = NSMutableArray(array: arrTemp)
                self?.isCategory = true
                DLog(message: "\(String(describing: self?.arrayCategory))")
            }
            
            DispatchQueue.main.async {
               // self?.collectionViewPost.reloadData()
            }
        }
    }
    private func getSubcategoryAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
           if !isNetworkAvailable { Util.showNetWorkAlert(); return }
           
           let postParams: [String: AnyObject] =
               [
                   kAPI_CategoryId : categoryId as AnyObject,
                   kAPI_Language   : MyDefaults().language as AnyObject,
           ]
           DLog(message: "\(postParams)")
           Networking.performApiCall(Networking.Router.getSubCategory(postParams), callerObj: self, showHud: true, text: loading) { [weak self] (response) -> () in
               
            guard let result = response.result.value else {
                   return
               }
               let jsonObj = JSON(result)
               
               if jsonObj[Key_ResponseCode].intValue == 500 {
                   return
               }
               DLog(message: "\(jsonObj)")
               
               if jsonObj["subcategory_data"].arrayObject != nil {
                   let arrTemp = jsonObj["subcategory_data"].arrayObject! as NSArray
                   self?.arrSubcategory = NSMutableArray(array: arrTemp)
                self?.isCategory = false
               }
               
               DispatchQueue.main.async {
                self?.popUpCategory()
               }
           }
       }
    private func placeBidAPI_Call() {
        var loading = ""
                  if (MyDefaults().language ?? "") as String ==  "en"{
                      loading = "Loading".LocalizableString(localization: "en")
                  } else{
                      loading = "Loading".LocalizableString(localization: "da")
                  }
        if !isNetworkAvailable { Util.showNetWorkAlert(); return }
        
        let postParams: [String: AnyObject] =
            [
                kAPI_UserId     : LoggedInUser.shared.id as AnyObject,
                kAPI_ProductId  : dictProduct["id"] as AnyObject,
                kAPI_BidAmount  : ""  as AnyObject,
                kAPI_Language   : MyDefaults().language as AnyObject,
        ]
        DLog(message: "\(postParams)")
        
        Networking.performApiCall(Networking.Router.placeBid(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
             //   self.viewBG.isHidden = true
               // self.viewPlaceBid.isHidden = true
            }
        }
    }

    private func getProductBidDetailAPI_Call() {
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
        
        Networking.performApiCall(Networking.Router.getProductBidDetail(postParams), callerObj: self, showHud: true, text: loading) { (response) -> () in
            
            guard let result = response.result.value else {
                return
            }
            let jsonObj = JSON(result)
            
            if jsonObj[Key_ResponseCode].intValue == 500 {
                return
            }
            DLog(message: "\(jsonObj)")
            
            DispatchQueue.main.async {
                
                let timeInSecond = jsonObj["time_left_in_second"].int
                
                if timeInSecond != 0 {
                    self.timer?.invalidate()
                    self.timeIntervalInSecond = TimeInterval(timeInSecond!)
                }
//                self.lblOfferPrice.text = "$\(jsonObj["offer_price"].stringValue)"
//                self.lblLastBidAmount.text = "$\(jsonObj["last_bid_amount"].stringValue)"
//                self.lblTotalBid.text = jsonObj["total_bid"].stringValue
//
//                self.offerPrice = jsonObj["offer_price"].intValue
//                self.lastBidAmount = jsonObj["last_bid_amount"].intValue
//
//               // self.viewBG.isHidden = false
//                self.viewPlaceBid.isHidden = false
//                self.txfBidAmount.text = ""
            }
        }
    }
    func popUpCategory() {
        if !isCategory {
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
            let popup : HomeSubCategoryPopUpVC = pop.instantiateViewController(withIdentifier: "HomeSubCategoryPopUpVC") as! HomeSubCategoryPopUpVC
            popup.arrayCategory = self.arrSubcategory
            popup.isCategory = false
            popup.delagate = self
            
            self.presentOnRoot(with: popup, isAnimated: true)
        }else{
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
            let popup : HomeCategoryPopUpVC = pop.instantiateViewController(withIdentifier: "HomeCategoryPopUpVC") as! HomeCategoryPopUpVC
            popup.arrayCategory = self.arrayCategory
             popup.isCategory = true
            popup.delagate = self
            self.presentOnRoot(with: popup, isAnimated: true)
        }
    }
    func scrollToBottomAnimated(animated: Bool) {
            guard self.collectionViewPost.numberOfSections > 0 else{
                return
            }

            let items = self.collectionViewPost.numberOfItems(inSection: 0)
            if items == 0 { return }

            let collectionViewContentHeight = self.collectionViewPost.collectionViewLayout.collectionViewContentSize.height
            let isContentTooSmall: Bool = (collectionViewContentHeight < self.collectionViewPost.bounds.size.height)

            if isContentTooSmall {
                self.collectionViewPost.scrollRectToVisible(CGRect(x: 0, y: collectionViewContentHeight - 1, width: 1, height: 1), animated: animated)
                return
            }

            self.collectionViewPost.scrollToItem(at: NSIndexPath(item: items - 1, section: 0) as IndexPath, at: .bottom, animated: animated)

        }
}
// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionViewPost == collectionView {
//            // return arrProduct.count
//            if isPersonal == true {
//                return personal.count
//            }else{
//                return self.professional.count
//            }
//        }else{
//            return category.count
//        }
   
    
//        if self.arrayAccountList.count > 0  {
//
//                    return self.arrayAccountList.count
//                } else {
//                    TableViewHelper.EmptyMessage(message: "No account found.", viewController: tableView)
//                    return 0
//                }
    
        if collectionViewPost == collectionView {
            
            if isPersonal == true {
                if self.personal.count > 0  {
                    //self.EmptyMessage(message: "", viewController: collectionView)
                   // self.NORECORDFOUND.isHidden = true
                    self.collectionViewPost.isHidden = false
                    return personal.count
                } else{
                  //  self.EmptyMessage(message: "No data found.", viewController: collectionView)
                  //  self.NORECORDFOUND.isHidden = true
                    self.collectionViewPost.isHidden = true
                }
                
               
            }else{
                if self.professional.count > 0  {
                    //self.EmptyMessage(message: "", viewController: collectionView)
                  //  self.NORECORDFOUND.isHidden = true
                    self.collectionViewPost.isHidden = false
                    return professional.count
                } else{
                    //self.EmptyMessage(message: "No data found.", viewController: collectionView)
                   // self.NORECORDFOUND.isHidden = false
                    self.collectionViewPost.isHidden = true
                }
                
               
            }
        } else {
            
            return category.count
            
        }
    return 0
    }
     func EmptyMessage(message:String, viewController:UICollectionView) {
    let rect = CGRect(origin: CGPoint(x: 0,y :200), size: CGSize(width: viewController.frame.size.width, height: viewController.frame.size.height))
    if message != ""{
    let messageLabel = InsetLabel(frame: rect)
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
    messageLabel.sizeToFit()
    viewController.backgroundView = messageLabel;
    }else{
    viewController.backgroundView = nil
    }
    }
    class InsetLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)))
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == self.collectionViewPost {
            if isPersonal {
                let cell: PersonalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalCollectionViewCell", for: indexPath) as! PersonalCollectionViewCell
                    
                if self.personal.count > 0 {
                    cell.lblTitle.text = self.personal[indexPath.row].selling.capitalizingFirstLetter()
                     cell.lblDiscount.text = self.personal[indexPath.row].discount + "% Off"
                     cell.lblOriginalPrice.text =  "Kr " + self.personal[indexPath.row].basePrice
                     cell.lblOfferPrice.text =  "Kr " + self.personal[indexPath.row].offerPrice
                     cell.totalTime = self.personal[indexPath.row].timeLeftInSecond
                     cell.lblName.text =  "By:- " + self.personal[indexPath.row].firstName.capitalizingFirstLetter() + self.personal[indexPath.row].lastName.capitalizingFirstLetter()
                     let location = CLLocation(latitude: (self.personal[indexPath.row].latitude).toDouble() ?? 0.0, longitude: (self.personal[indexPath.row].lognitute).toDouble() ?? 0.0)

                self.setGeoCoordinateOnCell(cell: cell, location: location, index: indexPath.row)
                cell.imgUserProfile.sd_setImage(with: URL(string:self.personal[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "gallery.png"))
                cell.btnPlaceBid.tag = indexPath.item
                 cell.btnPlaceBid.addTarget(self, action: #selector(didTapPlaceBid(_:)), for: .touchUpInside)
                    cell.btnOnimage.tag = indexPath.item
                     cell.btnOnimage.addTarget(self, action: #selector(didTapOnCell(_:)), for: .touchUpInside)
                if self.personal[indexPath.row].productImage.count > 0 {
                  //  self.configureCellSellerPersonalCollectionViewImage(cell: cell, image: self.personal[indexPath.item].productImage[0].productImage, location: location)
                
                    cell.imgPersonal.sd_setImage(with: URL(string:self.personal[indexPath.item].productImage[0].productImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
                }else{
                   // self.configureCellSellerPersonalCollectionViewImage(cell: cell, image: "dummy_post", location: location)
                    cell.imgPersonal.image = #imageLiteral(resourceName: "dummy_post")
                 }
                
                if  LoggedInUser.shared.id  == self.personal[indexPath.row].userId {
                    cell.btnPlaceBid.isHidden = true
                }else{
                    cell.btnPlaceBid.isHidden = false
                }
                cell.btnPersonalProfile.tag = indexPath.item
                cell.btnPersonalProfile.addTarget(self, action: #selector(didTapPersonalProfile(_:)), for: .touchUpInside)
               
                if self.personal[indexPath.row].accountStatus == "1" {
                    cell.lblOnline.text = "Online"
                    cell.lblOnline.textColor = UIColor.hexStringToUIColor(hex: "#4BD935")
                    cell.lblOnlineDot.backgroundColor = UIColor.hexStringToUIColor(hex: "#4BD935")
                } else{
                    cell.lblOnline.text = "Offline"
                    cell.lblOnline.textColor = UIColor.hexStringToUIColor(hex: "#CC0933")
                    cell.lblOnlineDot.backgroundColor = UIColor.hexStringToUIColor(hex: "#CC0933")
                }
                if (MyDefaults().language ?? "") as String ==  "en"{
                    let off = "OFF".LocalizableString(localization: "en")
                    cell.lblDiscount.text = self.personal[indexPath.row].discount + "% " + off
                    cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "en")
                    cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                    cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                    
                    cell.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: "en"), for: .normal)
                    
                } else{
                    let off = "OFF".LocalizableString(localization: "da")
                    cell.lblDiscount.text = self.personal[indexPath.row].discount + "% " + off
                    cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "da")
                    cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                    cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                    cell.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: "da"), for: .normal)
                    
                }
                }
                return cell
            }else{
                 
                let cell: PersonalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalCollectionViewCell", for: indexPath) as! PersonalCollectionViewCell
                    
                if self.professional.count > 0 {
                    
                
                cell.lblTitle.text = self.professional[indexPath.row].selling.capitalizingFirstLetter()
                     cell.lblDiscount.text = self.professional[indexPath.row].discount + "% Off"
                     cell.lblOriginalPrice.text =  "Kr " + self.professional[indexPath.row].basePrice
                     cell.lblOfferPrice.text =  "Kr " + self.professional[indexPath.row].offerPrice
                     cell.totalTime = self.professional[indexPath.row].timeLeftInSecond
                     cell.lblName.text =  "By:- " + self.professional[indexPath.row].companyName.capitalizingFirstLetter() + self.professional[indexPath.row].lastName.capitalizingFirstLetter()
               
                let location = CLLocation(latitude: (self.professional[indexPath.row].latitude).toDouble() ?? 0.0, longitude: (self.professional[indexPath.row].lognitute).toDouble() ?? 0.0)

                self.setGeoCoordinateOnCell(cell: cell, location: location, index: indexPath.row)
                cell.imgUserProfile.sd_setImage(with: URL(string:self.professional[indexPath.row].userImage), placeholderImage:#imageLiteral(resourceName: "gallery.png"))
                cell.btnPlaceBid.tag = indexPath.item
                 cell.btnPlaceBid.addTarget(self, action: #selector(didTapPlaceBid(_:)), for: .touchUpInside)
                    cell.btnOnimage.tag = indexPath.item
                     cell.btnOnimage.addTarget(self, action: #selector(didTapOnCell(_:)), for: .touchUpInside)
                    
                    if self.professional[indexPath.row].productImage.count > 0 {
                      //  self.configureCellSellerPersonalCollectionViewImage(cell: cell, image: self.personal[indexPath.item].productImage[0].productImage, location: location)
                        cell.imgPersonal.sd_setImage(with: URL(string:self.professional[indexPath.item].productImage[0].productImage), placeholderImage:#imageLiteral(resourceName: "dummy_post"))
                      
                    }else{
                       // self.configureCellSellerPersonalCollectionViewImage(cell: cell, image: "dummy_post", location: location)
                        cell.imgPersonal.image = #imageLiteral(resourceName: "dummy_post")
                     }
                    
                   
                    
                  
                    
                if  LoggedInUser.shared.id == self.professional[indexPath.row].userId {
                    cell.btnPlaceBid.isHidden = true
                }else{
                    cell.btnPlaceBid.isHidden = false
                }
                cell.btnPersonalProfile.tag = indexPath.item
                cell.btnPersonalProfile.addTarget(self, action: #selector(didTapPersonalProfile(_:)), for: .touchUpInside)
                if self.professional[indexPath.row].accountStatus == "1" {
                    cell.lblOnline.text = "Online"
                    cell.lblOnline.textColor = UIColor.hexStringToUIColor(hex: "#4BD935")
                    cell.lblOnlineDot.backgroundColor = UIColor.hexStringToUIColor(hex: "#4BD935")
                } else{
                    cell.lblOnline.text = "Offline"
                    cell.lblOnline.textColor = UIColor.hexStringToUIColor(hex: "#CC0933")
                    cell.lblOnlineDot.backgroundColor = UIColor.hexStringToUIColor(hex: "#CC0933")
                }
                if (MyDefaults().language ?? "") as String ==  "en"{
                    let off = "OFF".LocalizableString(localization: "en")
                    cell.lblDiscount.text = self.professional[indexPath.row].discount + "% " + off
                    cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "en")
                    cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "en")
                    cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "en")
                    
                    cell.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: "en"), for: .normal)
                    
                } else{
                    let off = "OFF".LocalizableString(localization: "da")
                    cell.lblDiscount.text = self.professional[indexPath.row].discount + "% " + off
                    cell.timeLeftLoc.text = "TimeLeft".LocalizableString(localization: "da")
                    cell.originalPriceLoc.text = "OriginalPrice".LocalizableString(localization: "da")
                    cell.OfferPriceLoc.text = "OfferPrice".LocalizableString(localization: "da")
                    cell.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: "da"), for: .normal)
                    
                }
                }
                return cell
            }
        
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
            let dictProduct = self.category[indexPath.item]
            if (MyDefaults().language ?? "") as String ==  "en" {
                cell?.lblCategoryName.text = dictProduct["category_name"]?.LocalizableString(localization: "en")
            } else {
                cell?.lblCategoryName.text = dictProduct["category_name"]?.LocalizableString(localization: "da")
            }
           return cell!
    }
    // return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        if isLoading {
//            return CGSize.zero
//        }
//        return CGSize(width: collectionView.bounds.size.width, height: 55)
//    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if self.collectionViewPost == collectionView {
            if elementKind == UICollectionView.elementKindSectionFooter {
                self.footerView?.stopAnimate()
            }
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if self.collectionViewPost == collectionView {
//            if isPersonal == true {
//                if indexPath.row == self.personal.count - 1 &&  !isLoading {  //numberofitem count
//                            updateNextSet()
//                }
//
//            } else {
//                if indexPath.row == self.professional.count - 1 &&  !isLoading {  //numberofitem count
//                            updateNextSet()
//                        }
//            }
//
//
//        }
//    }
   
    @objc private func loadMore(sender: AnyObject?) {
    DispatchQueue.main.asyncAfter(deadline: .now()) {
    
        if self.isPersonal == true {
            self.updateNextSet()
            
        } else {
            self.updateNextSet()
        }}
    }
    
    func updateNextSet(){
           print("On Completetion")
           //requests another set of data (20 more items) from the server.
                   
                        if isPersonal == true {
                           
                            self.getProductAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
                        }  else{
                            
                            self.getProductAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
                        }
                    

    }
   
    
    

    @objc func didTapPersonalProfile(_ sender: UIButton) {
       
        if isPersonal {
            if LoggedInUser.shared.id != nil {
                let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
                let popup : BuyerReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerReviewPopUpVC") as! BuyerReviewPopUpVC
                popup.userId = LoggedInUser.shared.id!
                popup.OtherUserId = self.personal[sender.tag].userId
                self.presentOnRoot(with: popup, isAnimated: true)
            } else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: false)
                } else{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: false)
                }
            }
        } else{
            if LoggedInUser.shared.id != nil {
                let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
                let popup : BuyerReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerReviewPopUpVC") as! BuyerReviewPopUpVC
                popup.userId = LoggedInUser.shared.id!
                popup.OtherUserId = self.professional[sender.tag].userId
                self.presentOnRoot(with: popup, isAnimated: true)
            } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: false)
            } else{
                self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: false)
            }
        }
        }
       }
    func showGuestUser(index:Int,Message: String,title:String,okay:String,cancel:String,isPlaceBid:Bool) {
        let commonAlert = GuestUserAlertViewController()
        commonAlert.delegate = self
        commonAlert.index = index
        commonAlert.isLoginByPlaceBid = isPlaceBid
        commonAlert.ShowAlertWhenUserNotExist(title: title, message: Message, vc: self, Okay: okay, Cancel: cancel)
    }
    
    
    
    @objc func didTapOnCell(_ sender: UIButton) {
                    if isPersonal {
                        //let dictProduct = arrProduct[indexPath.item] as! NSDictionary
                        let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as? ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        if self.personal.count > 0 {
                            vc?.productDetailId = self.personal[sender.tag].id
                        }
                        
                      //  vc?.userId = self.personal[indexPath.item].userId
                        vc?.latitude = self.latitdude
                        vc?.longitutde = self.longitutde
        
        
                        if let aVc = vc {
                            aVc.hidesBottomBarWhenPushed = true
                            show(aVc, sender: nil)
                    }
        
                    }else{
                        //let dictProduct = arrProduct[indexPath.item] as! NSDictionary
                        let vc = Util.loadViewController(fromStoryboard: "ProductDetailVC", storyboardName: "Home") as? ProductDetailVC
                        //vc?.productDetailId = dictProduct["id"] as! String
                        vc?.productDetailId = self.professional[sender.tag].id
                        vc?.latitude = self.latitdude
                        vc?.longitutde = self.longitutde
        
        if let aVc = vc {
                            aVc.hidesBottomBarWhenPushed = true
                            show(aVc, sender: nil)
                    }
        
                    }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     
        
        if self.collectionViewPost == collectionView {

        
        
        }else{
                    
            print(indexPath.item)
            if indexPath.item == 0 {
               self.isCategory = true
                popUpCategory()
            }else{
               self.isCategory = false
                getSubcategoryAPI_Call()
            }
            
        }
    }
    @objc func didTapPlaceBid(_ sender: UIButton) {
   
         if isPersonal {
            if LoggedInUser.shared.id != nil {
                self.callServiceProductBidetail(index: sender.tag)
            } else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: true)
                } else{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: true)
                }
            }
         }else{
            if LoggedInUser.shared.id != nil {
                self.callServiceProfessionalBid(index: sender.tag)
            } else {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: true)
                } else{
                    self.showGuestUser(index: sender.tag, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: true)
                }
            }
        }
        //self.tabBarController?.tabBar.isHidden = true
    }
    func popUpPlaceBid(response:[String:Any],index: Int)  {
        self.tabBarController?.tabBar.isHidden = true
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        let popup : PlacedBidVCPopUp = pop.instantiateViewController(withIdentifier: "PlacedBidVCPopUp") as! PlacedBidVCPopUp
        popup.data = response
        popup.index = index
        // popup.isCategory = true
        popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    func callServiceProductBidetail(index:Int) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        
      let parameter: [String: Any] = ["product_id":self.personal[index].id!,
                                      "language": MyDefaults().language ?? AnyObject.self]
      
      print(parameter)
        print(ProductBidDetail)
        HTTPService.callForPostApi(url:ProductBidDetail , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                //  debugPrint(response)
                //  HideHud()
                  if response.count != nil {
                      let status = response["responseCode"] as! Int
                      let message = response["message"] as! String
                      if status == 200  {
                          let response = response as! [String:Any]
                        self.popUpPlaceBid(response: response, index: index)
                      }  else if status == 500 {
                          self.showErrorPopup(message: message, title: ALERTMESSAGE)
                      }
                      
                  }else{
                    //  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                  }
              }
          }
    func callServiceProfessionalBid(index:Int) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["product_id":self.professional[index].id!,
                                      "language": MyDefaults().language ?? AnyObject.self]
      
      print(parameter)
        print(ProductBidDetail)
        HTTPService.callForPostApi(url:ProductBidDetail , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
               //   debugPrint(response)
                //  HideHud()
                  if response.count != nil {
                      let status = response["responseCode"] as! Int
                      let message = response["message"] as! String
                      if status == 200  {
                          let response = response as! [String:Any]
                        self.popUpPlaceBid(response: response, index: index)
                      }  else if status == 500 {
                          self.showErrorPopup(message: message, title: ALERTMESSAGE)
                      }
                      
                  }else{
                  //    self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                  }
              }
          }
    
    func callServicePlacedService(index:Int,bidAmount:String) {

//        let parameter: [String: Any] = ["product_id":self.personal[index].id!,
//                                          "language": UserLanguage.shared.languageCode!,
//                                          "user_id": LoggedInUser.shared.id!,
//                                          "bid_amount":bidAmount]

          
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        
        var parameter: [String: Any] = [:]
        
        if self.isPersonal {
            parameter =  ["product_id":self.personal[index].id!,
                   "language": MyDefaults().language ?? AnyObject.self,
                   "user_id": LoggedInUser.shared.id!,
                   "bid_amount":bidAmount]
        }else{
            parameter =  ["product_id":self.professional[index].id!,
                   "language": MyDefaults().language ?? AnyObject.self,
                   "user_id": LoggedInUser.shared.id!,
                   "bid_amount":bidAmount]
        }
        print(parameter)
        HTTPService.callForPostApi(url:placeBid , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    //  debugPrint(response)
                    //  HideHud()
                      if response.count != nil {
                          let status = response["responseCode"] as! Int
                          let message = response["message"] as! String
                          if status == 200  {
                              self.showErrorPopup(message: message, title: ALERTMESSAGE)
                          }  else if status == 500 {
                              self.showErrorPopup(message: message, title: ALERTMESSAGE)
                          }

                      }else{
                       //   self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                      }
                  }
              }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               if self.collectionViewPost == collectionView {
                
               let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
               let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
               let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
                if (MyDefaults().language ?? "") as String ==  "en"{
                    return CGSize(width: size, height: 328.0)
                } else{
                    return CGSize(width: size, height: 328.0)
                }
                    
            
            }else{
                let label = UILabel(frame: CGRect.zero)
                let dict = self.category[indexPath.item]
                label.text = dict["name"]
                label.sizeToFit()
                return CGSize(width: label.frame.width + 40, height: 36)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.collectionViewPost == collectionView {

            if isLoading {
                return CGSize.zero
            }
            
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
//         if (MyDefaults().language ?? "") as String ==  "en"{
//            return CGSize(width: size, height: self.collectionViewPost.si)
//         } else{
//
//            return CGSize(width: size, height: 30)
            return CGSize(width: size, height: 30)
         }

        return CGSize(width: 0.0, height: 0.0)
     }
//
//
//        var numberOfRows = self.personal.count / 2;
//        self.collectionView.contentSize = CGSizeMake(self.view.frame.size.width, (numberOfRows * heightOfCell));
//
//
//        return CGSize(width: 0, height: 24.0)
//    }
//
    func setGeoCoordinateOnCell(cell:PersonalCollectionViewCell,location : CLLocation,index:Int) {
        var cityName = ""
        
        if isPersonal {
        
        let kilometer = Double(self.personal[index].distance ?? "")
        let distanceKm =   String(format: "%.2f",kilometer ?? 0)
        cell.lblDistance.text = distanceKm + " km, " + self.personal[index].address
            
         //   cell.lblDistance.text = distanceKm + " km, "

        
        
        } else{
            let kilometer = Double(self.professional[index].distance ?? "")
            let distanceKm =   String(format: "%.2f",kilometer ?? 0)
          //  cell.lblDistance.text = distanceKm + " km," + self.professional[index].city
            cell.lblDistance.text = distanceKm + " km, " + self.professional[index].address
        }
    }
    
func configureCellSellerPersonalCollectionViewImage(cell:PersonalCollectionViewCell,image:String,location : CLLocation)  {
      if Util.isValidString(image) {
          let imageUrl = image
          let url = URL.init(string: imageUrl)
          cell.imgPersonal.kf.indicatorType = .activity
          cell.imgPersonal.kf.indicator?.startAnimatingView()
          let resource = ImageResource(downloadURL: url!)
          KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                       switch result {
                       case .success(let value):
                           cell.imgPersonal.image = value.image
                       case .failure( _):
                         
                           cell.imgPersonal.image = #imageLiteral(resourceName: "dummy_post.png")
                       }
                       cell.imgPersonal.kf.indicator?.stopAnimatingView()
                   }
               }
               else {
                   cell.imgPersonal.image = #imageLiteral(resourceName: "dummy_post.png")
               }
    
    }
}

// MARK: CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        appDelegate.currentLocation = locations.last! as CLLocation
        locManager.stopUpdatingLocation()
    }
    
}
// MARK: UITextFieldDelegate
extension HomeVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txfSearch {
            if string.isEmpty {
                search = String(search.dropLast())
            }
            else {
                search = textField.text! + string
            }
            // Perform Search Product API
           // getProductAPI_Call(userType: <#String#>)
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if self.isPersonal == true {
//            self.personal = [ModelHomePersonalResponseDatum]()
//
//        } else{
//            self.professional = [ModelProfessionalResponseDatum]()
//        }
    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
//        if self.txfSearch == textField {
//            self.pageNumber = 0
//               // self.personal = [ModelHomePersonalResponseDatum]()
//
//                if self.txfSearch.text!.count > 0 {
//                 if isPersonal == true {
//                    self.getProductSearchAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: textField.text!, isMapSelected: false)
//                  }else{
//                    self.getProductSearchAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: textField.text!, isMapSelected: false)
//                 }
//            }else{
//                self.txfSearch.text = ""
//               // self.professional = [ModelProfessionalResponseDatum]()
//                if isPersonal == true {
//                    self.getProductSearchAPI_Call(userType: "1", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
//                }  else{
//                    self.getProductSearchAPI_Call(userType: "2", latitude: latitdude, longitude: longitutde, radius: self.radiusKm, categoryId: categoryId, subCategoryId: subCategoryId, search: "", isMapSelected: false)
//                }
//
//            }
//                return true
//            }
//        self.txfSearch.resignFirstResponder()
//        return false
//        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txfSearch.resignFirstResponder()
        return true
       
        
    }

}
extension HomeVC : getSelectCategory,getSelectSubCategory,getPlaceBid,getSelectMapCoordinate,getUserAppear,gestuserLogin {
    
    
    func delegatCancelPlacedBid(bidAmmount: String, index: Int) {
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func getDelegateGuestUserLogin(index:Int,isPlaceBid:Bool) {
        
        self.dismiss(animated: true, completion: nil)
        if isPlaceBid {
            
        } else {
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
                let popup : BuyerReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerReviewPopUpVC") as! BuyerReviewPopUpVC
        if isPersonal {
            popup.userId = LoggedInUser.shared.id!
            popup.OtherUserId = self.personal[index].userId
              //  popup.delagate = self
        } else{
            popup.userId = LoggedInUser.shared.id!
            popup.OtherUserId = self.professional[index].userId
              //  popup.delagate = self
        }
        self.presentOnRoot(with: popup, isAnimated: true)
        }
    }
    func GetgusetUserAppear(controller: UIViewController,index:Int,isLoginByPlaceBid:Bool) {
        
        let pop = UIStoryboard.init(name: "Main", bundle: nil)
        let popup : LoginVC = pop.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        popup.isGuestUserLogin = true
        popup.index = index
        popup.isPlaceBid = isLoginByPlaceBid
        popup.delagate = self
        popup.isUserLogin = true
        self.presentOnRoot(with: popup, isAnimated: true)
    
    }
    func cancelGuestUser(controller: UIViewController) {
        
//        self.navigationController?.popToRootViewController(animated: true)
//        self.tabBarController?.selectedIndex = 0
//        let storyboard : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let signInVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        let nav = UINavigationController(rootViewController:signInVC)
//      //  nav.navigationController?.navigationBar.isHidden = true
//        nav.setNavigationBarHidden(true, animated: true)
//        let application = UIApplication.shared.delegate as! AppDelegate
//        application.window!.rootViewController = nav
        
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
//        let navigationController = UINavigationController(rootViewController: newViewController)
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        appdelegate.window!.rootViewController = navigationController
        
                
                self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func delegatSelectCodinateofMap(latitude: String, longitude: String, distance: String, isMapSelected: Bool) {
        self.radiusKm = distance
        self.latitdude = latitude
        self.longitutde = longitude
//        self.personal = [ModelHomePersonalResponseDatum]()
//        self.professional = [ModelProfessionalResponseDatum]()
//        self.pageNumber = 0

        
   
       // self.tabBarController?.selectedIndex = 0
        self.tabBarController?.tabBar.isHidden = false
        //self.dismiss(animated: true, completion: nil)
   
        self.navigationController?.popViewController(animated: true)
    }
    func delegatPlacedBid(bidAmmount: String,index:Int) {
        self.dismiss(animated: true, completion: nil)
        if isPersonal {
            self.callServicePlacedService(index: index, bidAmount: bidAmmount)
                   
        }else{
            self.callServicePlacedService(index: index, bidAmount: bidAmmount)
                   
        }
       self.tabBarController?.tabBar.isHidden = false
    }
    
    func delegatSelectSubCategory(array: NSMutableArray) {
        
    let dict = array[0] as! NSDictionary
     
     var dict1 = [String:String]()
     
     dict1 ["category_name"] = dict["subcategory_name"] as? String
     dict1 ["category_image"] = dict["subcategory_image"] as? String
     dict1 ["created_at"] = dict["created_at"] as? String
     dict1 ["id"] = dict["id"] as? String
     dict1 ["category_id"] = dict["category_id"] as? String
     dict1 ["status"] = dict["status"] as? String
   //  dict1 ["subcategory_status"] = dict["subcategory_status"] as? String
        subCategoryId = dict["id"] as? String ?? ""
      //let cateId = dict["id"] as! String
        self.category[1] = dict1
       self.dismiss(animated: true, completion: nil)
        self.collectionCategory.reloadData()
    
    }
    
    func delegatSelectCategory(array:NSMutableArray){
        
        self.category = [[String:String]]()
        let dict = array[0] as! NSDictionary
        print(dict)
        var dict1 = [String:String]()
        
        
        
        dict1 ["category_name"] = dict["category_name"] as? String
        dict1 ["category_image"] = dict["category_image"] as? String
        dict1 ["created_at"] = dict["created_at"] as? String
        dict1 ["id"] = dict["id"] as? String
        dict1 ["ordering"] = dict["ordering"] as? String
        dict1 ["status"] = dict["status"] as? String
        dict1 ["subcategory_status"] = dict["subcategory_status"] as? String
        
         let cateId = dict["id"] as! String
        //categoryId = Int(cateId) ?? 0
        
        categoryId = cateId
        print(categoryId)
       
        
        
        var dict2 = [String:String]()
        
        if (MyDefaults().language ?? "") as String ==  "en" {
            dict2 ["category_name"] = "Sub_Category".LocalizableString(localization: "en")
            dict2 ["category_image"] = ""
            dict2 ["created_at"] = ""
            dict2 ["id"] = ""
            dict2 ["ordering"] = ""
            dict2 ["status"] = ""
            dict2 ["subcategory_status"] = ""
        } else {
            dict2 ["category_name"] = "Sub_Category".LocalizableString(localization: "da")
            dict2 ["category_image"] = ""
            dict2 ["created_at"] = ""
            dict2 ["id"] = ""
            dict2 ["ordering"] = ""
            dict2 ["status"] = ""
            dict2 ["subcategory_status"] = ""
        }
            
    self.category.append(dict1)
        self.category.append(dict2)
       
        
        self.dismiss(animated: true, completion: nil)
        self.collectionCategory.reloadData()
    }

}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

extension HomeVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let tabBarIndex = tabBarController.selectedIndex
            if tabBarIndex == 1 {
                //do your stuff
                
                print("login")
            }
       }}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }

}
