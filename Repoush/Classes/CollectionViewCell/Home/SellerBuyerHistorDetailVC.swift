//
//  SellerBuyerHistorDetailVC.swift
//  Repoush
//
//  Created by Apple on 17/11/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import ImageSlideshow
protocol getSelecteTabsHistory {
    func delegateSelectTabsHistory(getTile:String,selecteTab:Bool)
}
class SellerBuyerHistorDetailVC: UIViewController
{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNavTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblKmOnMap: UILabel!
    @IBOutlet weak var lblOriginalPriceLoc: UILabel!
    @IBOutlet weak var lblOfferPriceLoc: UILabel!
    @IBOutlet weak var lblEhatYouSellingLoc: UILabel!
    @IBOutlet weak var lblConditionLoc: UILabel!
    @IBOutlet weak var lblCategoryLoc: UILabel!
    @IBOutlet weak var lblSubcategoryLoc: UILabel!
    @IBOutlet weak var lblProductDetailLoc: UILabel!
   @IBOutlet weak var lblCondtionsHightConstaints: NSLayoutConstraint!
    @IBOutlet weak var lblPickUpLocationLoc: UILabel!
    @IBOutlet weak var lblTimeLeftLoc: UILabel!
    
    @IBOutlet weak var lblProductDetail: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnPlaceBid: UIButton!
    @IBOutlet weak var btnQuestion: UIButton!
    
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var OfferPrice: UILabel!
    @IBOutlet weak var lblDisccount: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblSelling: UILabel!
    
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    //@IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
     @IBOutlet weak var lblName: UILabel!
     @IBOutlet weak var viewPlaceBid: UIView!
    @IBOutlet weak var viewPlaceBidConstraintHight: NSLayoutConstraint!
    @IBOutlet var slideshow: ImageSlideshow!
    var thisWidth:CGFloat = 0
    @IBOutlet weak var viewBG: UIView!
    var productImage = [ModelProductImage]()
    var productProperty = [ModelProductProperty]()
    var ratingList = [ModelRatingList]()
    var countdownTimer = Timer()
    var releaseDate: NSDate?
    var timeCounter: Int = 0
    var slecteTabs = ""
    var isSelectedTabs = false
    //var delagate: getSelecteTabs!
    var responseData : ModelResponseDatum!
    var productDetailId = ""
    var userId = ""
    var latitude = ""
    var longitutde = ""

    // MARK: - View Life Cycle
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
          
            print(latitude)
            print(longitutde)
            
            self.tblView.isHidden = true
            if  isConnectedToInternet() {
                    callServiceProductDetail()
        
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
    func callServiceProductDetail() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
      
        let parameter: [String: Any] = ["product_id":productDetailId,
                                        "language": MyDefaults().language ?? "",
                                        "user_id": LoggedInUser.shared.id ?? "" ,
                                        "latitude":latitude,
                                        "lognitude":longitutde]
        
        print(parameter)
        HTTPService.callForPostApi(url:productDetail , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            let response = ModelProductDetail.init(fromDictionary: response as! [String : Any])
                            self.tblView.isHidden = false
                            self.responseData = response.responseData
                            self.productImage = response.responseData.productImage
                            self.productProperty = response.responseData.productProperty
                            self.slideImagePicker()
                            self.setUI()
                        }  else if status == 500 {
                            self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        
                    }else{
                        if (MyDefaults().language ?? "") as String ==  "en"{
                         ///   self.showErrorPopup(message: "serverNotFound".LocalizableString(localization: "en"), title: ALERTMESSAGE)
                        } else {
                          //  self.showErrorPopup(message: "serverNotFound".LocalizableString(localization: "da"), title: ALERTMESSAGE)
                        }
                        
                    }
                }
            }
    
    func slideImagePicker()  {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.hexStringToUIColor(hex: "02BBCA")
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        pageControl.backgroundColor = .clear
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
     
        var sdWebImageSource = [SDWebImageSource]()
        print(self.productImage.count)
        for items in self.productImage {
             let webImage = [SDWebImageSource(urlString: items.productImage)!]
            sdWebImageSource.append(contentsOf: webImage)
        }
        print(sdWebImageSource.count)
        slideshow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(SellerBuyerHistorDetailVC.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    func setUI() {
        self.lblTitle.text = responseData.selling.capitalizingFirstLetter()
       
        if responseData.firstName.isEmpty {
            self.lblName.text = "By :- " + responseData.selling.capitalizingFirstLetter()
        } else{
            self.lblName.text = "By :- " + responseData.firstName.capitalizingFirstLetter() + " " + responseData.lastName.capitalizingFirstLetter()
        }
        
       
        let ratings = Double(self.responseData.rating)
       
        if ratings == 0 {
            self.lblRating.text = "0.0"
        } else{
            self.lblRating.text = String(format: "%.1f",ratings!)
        }
        if let review = responseData.review{
            if review == 0 {
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.lblReview.text = "0" + "Reviews".LocalizableString(localization: "en")
                } else{
                    self.lblReview.text = "0" + "Reviews".LocalizableString(localization: "da")
                }
                
            }else{
                if (MyDefaults().language ?? "") as String ==  "en"{
                self.lblReview.text = String(review) + "Reviews".LocalizableString(localization: "en")
            } else{
                self.lblReview.text = String(review) + "Reviews".LocalizableString(localization: "da")
            }
            
            }
        }
      if let distance = self.responseData.distance{
            print(distance)
         let map =  String(format: "%.2f", distance)
            print(map)
        self.lblKmOnMap.text = map + " Km"
        }
       
        
        self.lblOriginalPrice.text = "Kr " + responseData.basePrice
        self.OfferPrice.text = "Kr " + responseData.offerPrice
        
        self.lblAddress.text = responseData.userAddress
       
        if responseData.descriptionField.isEmpty {
            self.tbleViewHeaderHight(height: 549)
        }else{
            self.lblProductDetail.text = responseData.descriptionField
            self.tbleViewHeaderHight(height: 567)
        }
        
        self.lblSelling.text = responseData.selling
      //  self.lblBrand.text = responseData.brand
        
        if responseData.productCondition.isEmpty {
            self.tbleViewHeaderHight(height: 549)
            self.lblCondtionsHightConstaints.constant = 0
            self.lblCondition.isHidden = true
        }else{
            self.lblCondition.text = responseData.productCondition
            self.tbleViewHeaderHight(height: 567)
        }
        
        self.lblCategory.text = responseData.categoryName
        self.imgProfile.sd_setImage(with: URL(string:self.responseData.userImage), placeholderImage:#imageLiteral(resourceName: "gallery"))
        self.lblSubCategory.text = responseData.subcategoryName
        if LoggedInUser.shared.id ?? "" == self.responseData.userId {
            self.viewPlaceBid.isHidden = true
            self.viewPlaceBidConstraintHight.constant = 0
           self.tbleViewHeaderHight(height: 567)
        }else{
            self.viewPlaceBid.isHidden = false
            self.viewPlaceBidConstraintHight.constant = 42
            self.tbleViewHeaderHight(height: 567)
        }
        if let temp = Double("\(String(describing: self.responseData.distance))") {
                    print(temp)
                }
        timeCounter = Int(self.responseData.timeLeftInSecond)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
       if  let questionCount = responseData.commentCount {
            let countQu = String(questionCount)
            self.lblQuestions.text =  countQu
            self.lblQuestions.text = "(" + "\(countQu)" + ")"
           
            
        }
        
        if self.productProperty.count > 0 {
            self.tblView.delegate = self
            self.tblView.dataSource = self
            self.tblView.reloadData()
        }
    
                if (MyDefaults().language ?? "") as String ==  "en"{
                    let off = "OFF".LocalizableString(localization: "en")
                    self.lblDisccount.text = responseData.discount + " % " +  off
                   // self.changeLanguage(strLanguage: "en")
                } else{
                    let off = "OFF".LocalizableString(localization: "da")
                    self.lblDisccount.text = responseData.discount + " % " + off
                    //self.changeLanguage(strLanguage: "da")
                }
    
    }
    func changeLanguage(strLanguage:String) {
           
        self.btnShare.setTitle("Share".LocalizableString(localization: strLanguage), for: .normal)
        self.btnPlaceBid.setTitle("Place_Bid".LocalizableString(localization: strLanguage), for: .normal)
        self.btnQuestion.setTitle("Questions".LocalizableString(localization: strLanguage), for: .normal)
        self.lblReview.text = "Reviews".LocalizableString(localization: strLanguage)
        self.lblNavTitle.text = "Auction_Detail".LocalizableString(localization: strLanguage)
        self.lblEhatYouSellingLoc.text = "What_Are_You_Selling".LocalizableString(localization: strLanguage)
        self.lblConditionLoc.text = "Condition".LocalizableString(localization: strLanguage)
        self.lblCategoryLoc.text = "Category".LocalizableString(localization: strLanguage)
        self.lblSubcategoryLoc.text = "Sub_category".LocalizableString(localization: strLanguage)
        
        self.lblOriginalPriceLoc.text = "OriginalPrice".LocalizableString(localization: strLanguage)
        self.lblOfferPriceLoc.text = "OfferPrice".LocalizableString(localization: strLanguage)
        self.lblTimeLeftLoc.text = "TimeLeft".LocalizableString(localization: strLanguage)
        self.lblProductDetailLoc.text = "Product_Detail".LocalizableString(localization: strLanguage)
        self.lblPickUpLocationLoc.text = "PICK_Location".LocalizableString(localization: strLanguage)
        
        
        }
    
    func tbleViewHeaderHight(height:Float) {
//        if let headerView = self.tblView.tableHeaderView {
//            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//                var headerFrame = headerView.frame
//
//                // If we don't have this check, viewDidLayoutSubviews() will get
//                // repeatedly, causing the app to hang.
//                if height != headerFrame.size.height {
//                    headerFrame.size.height = height
//                    headerView.frame = headerFrame
//                    self.tblView.tableHeaderView = headerView
//                }
//            }
        self.tblView.tableHeaderView?.frame.size = CGSize(width:tblView.frame.width, height: CGFloat(height))
        //self.tblView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: -20, right: 0);
    }
    
       @objc func updateCounter() {
            guard timeCounter >= 0 else {
                countdownTimer.invalidate()
              //  countdownTimer = nil
                return
            }
    
            let hours = timeCounter / 3600
            let minutes = timeCounter / 60 % 60
            let seconds = timeCounter % 60
            let temp = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    
            lblTimeLeft.text = "\(temp)"
            timeCounter -= 1
        }
    func callServiceProductBidetail() {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
        let parameter: [String: Any] = ["product_id":productDetailId,
                                        "language": MyDefaults().language ?? AnyObject.self]
        
        print(parameter)
        HTTPService.callForPostApi(url:ProductBidDetail , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                    debugPrint(response)
                  //  HideHud()
                    if response.count != nil {
                        let status = response["responseCode"] as! Int
                        let message = response["message"] as! String
                        if status == 200  {
                            let response = response as! [String:Any]
                            self.bidDetailPopUp(response: response)
                        }  else if status == 500 {
                            self.showErrorPopup(message: message, title: ALERTMESSAGE)
                        }
                        
                    }else{
                       // self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                    }
                }
            }
    func callServicePlacedService(bidAmount:String) {
        var loading = ""
        if (MyDefaults().language ?? "") as String ==  "en"{
            loading = "Loading".LocalizableString(localization: "en")
        } else{
          loading = "Loading".LocalizableString(localization: "da")
        }
      let parameter: [String: Any] = ["product_id":productDetailId,
                                      "language": MyDefaults().language ?? AnyObject.self,
                                      "user_id": LoggedInUser.shared.id!,
                                      "bid_amount":bidAmount]
      
      print(parameter)
        HTTPService.callForPostApi(url:placeBid , parameter: parameter, authtoken: "", showHud: true, text: loading, VC: self) { (response) in
                  debugPrint(response)
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
                    //  self.showErrorPopup(message: serverNotFound, title: ALERTMESSAGE)
                  }
              }
          }
    func bidDetailPopUp(response:[String:Any]) {
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
            let popup : PlacedBidVCPopUp = pop.instantiateViewController(withIdentifier: "PlacedBidVCPopUp") as! PlacedBidVCPopUp
            popup.data = response
            // popup.isCategory = true
            popup.delagate = self
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    @IBAction func actionOnReview(_ Sender:Any){
        let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
        if LoggedInUser.shared.id != nil {
            let popup : ReviewProductDetailVC = pop.instantiateViewController(withIdentifier: "ReviewProductDetailVC") as! ReviewProductDetailVC
           
            
            if self.responseData.rating ?? ""  ==  "" {
                popup.rating = "0"
            } else{
                popup.rating = self.responseData.rating
            }
            
                popup.delagate = self
                popup.name = self.responseData.firstName + " " +  self.responseData.lastName
                popup.ratingList = self.responseData.ratingList
                self.presentOnRoot(with: popup, isAnimated: true)
        } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: false)
            } else{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: false)
            }
        }
    
    
    }
    @IBAction func actionOnProfile(_ Sender:Any){
        
        if LoggedInUser.shared.id != nil {
            let pop = UIStoryboard.init(name: "PopUp", bundle: nil)
            let popup : BuyerReviewPopUpVC = pop.instantiateViewController(withIdentifier: "BuyerReviewPopUpVC") as! BuyerReviewPopUpVC
            popup.userId = LoggedInUser.shared.id!
            popup.OtherUserId =  self.responseData.userId
            self.presentOnRoot(with: popup, isAnimated: true)
        } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: false)
            } else{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: false)
            }
        }
        
    }
    
//    @IBAction func actionBack(_ Sender:Any){
//
//        if slecteTabs.isEmpty {
//            self.navigationController?.popViewController(animated: true)
//        }else{
//            if self.delagate != nil {
//                self.navigationController?.popViewController(animated: true)
//                self.delagate.delegateSelectTabs(getTile: slecteTabs, selecteTab: isSelectedTabs)
//            }
//        }
//    }
    @IBAction func actionOnShare(_ Sender:Any){
//        let text = "This is the text...."
//        let image = UIImage(named: "Product")
        let myWebsite = NSURL(string: BASE_URL + "/" + self.responseData.userId)
        let shareAll = [myWebsite]
        let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func actionOnQuestion(_ Sender:Any){
//        var productId = ""
//        var userImage = ""
//        var name = ""
   
    let vc = Util.loadViewController(fromStoryboard: "AskQuestionVC", storyboardName: "Home") as? AskQuestionVC
        vc?.productId = self.responseData.id
       
//        if responseData.firstName.isEmpty && responseData.lastName.isEmpty {
//            vc?.name =  responseData.companyName.capitalizingFirstLetter()
//        }else{
//            vc?.name = "By :- " + responseData.firstName.capitalizingFirstLetter() + " " + responseData.lastName.capitalizingFirstLetter()
//        }
            
        vc?.name = responseData.selling.capitalizingFirstLetter()
        for i in 0..<self.productImage.count {
            if i == 0 {
                vc?.userImage = self.productImage[i].productImage
            }
        }
        vc?.sellerId = self.responseData.id
        self.navigationController?.pushViewController(vc!, animated: true)
    
    }
    @IBAction func actionOnPlaceBid(_ Sender:Any){
        
        if LoggedInUser.shared.id != nil {
            self.callServiceProductBidetail()
        } else {
            if (MyDefaults().language ?? "") as String ==  "en"{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "en"), title: "Pris24", okay: "Okay".LocalizableString(localization: "en"), cancel: "Report_Cancel".LocalizableString(localization: "en"), isPlaceBid: false)
            } else{
                self.showGuestUser(index: 0, Message: "Please Login Or Register To Continue".LocalizableString(localization: "da"), title: "Pris24", okay: "Okay".LocalizableString(localization: "da"), cancel: "Report_Cancel".LocalizableString(localization: "da"), isPlaceBid: false)
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
    @IBAction func actionOnOnRating(_ Sender:Any){
        
    }
    

}
    extension SellerBuyerHistorDetailVC : ImageSlideshowDelegate {
        func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        }
    }
//extension ProductDetailVC : UICollectionViewDelegate,UICollectionViewDataSource{
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.productImage.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailCollectionViewCell", for: indexPath)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.section
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        thisWidth = CGFloat(self.frame.width)
//        return CGSize(width: thisWidth, height: self.frame.height)
//    }
//
//}
extension SellerBuyerHistorDetailVC : UITableViewDelegate,UITableViewDataSource,getPlaceBid,delegateReviewProductDetail,getUserAppear,gestuserLogin {
    func getDelegateGuestUserLogin(index: Int, isPlaceBid: Bool) {
        self.callServiceProductDetail()
        self.dismiss(animated: true, completion: nil)
    }
    func delegatCancelPlacedBid(bidAmmount: String, index: Int) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func GetgusetUserAppear(controller: UIViewController, index: Int, isLoginByPlaceBid: Bool) {
        let pop = UIStoryboard.init(name: "Main", bundle: nil)
        let popup : LoginVC = pop.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        popup.isGuestUserLogin = true
        popup.index = index
        popup.isPlaceBid = true
        popup.delagate = self
        popup.isUserLogin = true
        self.presentOnRoot(with: popup, isAnimated: true)
    }
    func cancelGuestUser(controller: UIViewController) {
//        self.navigationController?.popViewController(animated: true)
//        self.tabBarController?.selectedIndex = 0
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
        
               // self.navigationController?.popToRootViewController(animated: true)
                self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    func delegateReviewListProductDetail() {
        
        self.dismiss(animated: true, completion: nil)
    }
    func delegatPlacedBid(bidAmmount: String, index: Int) {
        self.dismiss(animated: true, completion: nil)
        self.callServicePlacedService(bidAmount: bidAmmount)
    }
    
    //  self.delagate.delegatPlacedBid(bidAmmount: self.txtEnterBid.text!, index: index)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.productProperty.count)
        return self.productProperty.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailPropertyTableViewCell", for: indexPath) as? ProductDetailPropertyTableViewCell else { fatalError() }
        cell.lblPropertyName.text = self.productProperty[indexPath.row].propertyName.uppercased()
            cell.lblPropertyValue.text = self.productProperty[indexPath.row].propertyValue
            return cell
        }
}
//class ProductDetailPropertyTableViewCell: UITableViewCell {
//    
//    @IBOutlet weak var lblPropertyName:UILabel!
//    @IBOutlet weak var lblPropertyValue:UILabel!
//    override func awakeFromNib() {
//    
//    }
//}
//class ProductDetailCollectionViewCell: UICollectionViewCell {
//    @IBOutlet weak var imgView:UIImageView!
//    override func awakeFromNib() {
//        
//    }
//}
//extension Float {
//    var clean: String {
//       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
//    }
//}
