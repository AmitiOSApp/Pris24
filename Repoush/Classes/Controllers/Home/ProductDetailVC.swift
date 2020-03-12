//
//  ProductDetailVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 2/26/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewProductImage: UICollectionView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgviewUser: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var lblOriginalPrice: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblSelling: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblDiescount: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblProductDetails: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblRatingValue: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var viewGender: UIView!

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewRateReview: UIView!
    @IBOutlet weak var imgviewUserReview: UIImageView!
    @IBOutlet weak var lblReviewUsername: UILabel!
    @IBOutlet weak var lblRatingCount: UILabel!
    @IBOutlet weak var tblReview: UITableView!
    
    @IBOutlet weak var viewReviewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewAgeHgtConst: NSLayoutConstraint!
    @IBOutlet weak var viewProductDetailHgtConst: NSLayoutConstraint!

    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    var arrProductImage = NSMutableArray()
    private var timer: Timer?
    private var timeCounter: Int = 0
    private var arrRatingList = NSMutableArray()

    var timeIntervalInSecond: TimeInterval? {
        didSet {
            startTimer()
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tblReview.rowHeight = UITableView.automaticDimension
        tblReview.estimatedRowHeight = 80

        setProductDetail()
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRateReview_Action(_ sender: UIButton) {
        viewBG.isHidden = false
        viewRateReview.isHidden = false
    }
    
    @IBAction func btnCross_Action(_ sender: UIButton) {
        viewBG.isHidden = true
        viewRateReview.isHidden = true
    }

    // MARK: - Private Methods
    private func setProductDetail() {
        
        lblProductName.text = dictProduct["selling"] as? String
        lblSelling.text = dictProduct["selling"] as? String
        lblUsername.text = "By :- \(Util.createUsername(dictProduct))"
        lblReviewUsername.text = Util.createUsername(dictProduct)
        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        lblDiescount.text = "\(dictProduct["discount"] ?? "0.0")% off"
        lblBrand.text = dictProduct["brand"] as? String
        lblCondition.text = dictProduct["product_condition"] as? String
        lblPickupLocation.text = dictProduct["address"] as? String
        lblReviewCount.text = "\(dictProduct["review"] ?? "0.0") REVIEWS"
        lblRatingValue.text = "\(dictProduct["rating"] ?? "0")"
        lblRatingCount.text = "\(dictProduct["rating"] ?? "0")"

        let strSize = dictProduct["size"] as? String
        if !Util.isValidString(strSize ?? "") {
            viewSize.isHidden = true
        }
        else {
            lblSize.text = strSize
        }

        let strAge = dictProduct["age"] as? String
        if !Util.isValidString(strAge ?? "") {
            viewAgeHgtConst.constant = 0.0
        }
        else {
            lblAge.text = "\(strAge ?? "") Y"
        }
        
        let strGender = dictProduct["gender"] as? String
        if !Util.isValidString(strGender ?? "") {
            viewGender.isHidden = true
        }
        else {
            lblGender.text = strGender
        }
        
        let strDescription = dictProduct["description"] as? String
        if !Util.isValidString(strDescription ?? "") {
            viewProductDetailHgtConst.constant = 0.0
        }
        else {
            lblProductDetails.text = strDescription
        }

        var distance = 0.0
        if let temp = Double("\(dictProduct["distance"] ?? 0.0)") {
            distance = temp
        }
        distance = Double(distance).rounded(2)
        btnDistance.setTitle("\(distance) km", for: .normal)

        let timeInSecond = dictProduct["time_left_in_second"] as? Int
        
        if timeInSecond != 0 {
            timer?.invalidate()
            timeIntervalInSecond = TimeInterval(timeInSecond!)
        }

        if Util.isValidString(dictProduct["user_image"] as! String) {
            
            let imageUrl = dictProduct["user_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            imgviewUser.kf.indicatorType = .activity
            imgviewUser.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imgviewUser.image = value.image
                    self.imgviewUserReview.image = value.image
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                    self.imgviewUserReview.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            self.imgviewUser.image = UIImage(named: "dummy_user")
            self.imgviewUserReview.image = UIImage(named: "dummy_user")
        }
        
        if let arrTemp = dictProduct["product_image"] as? NSArray {
            arrProductImage = NSMutableArray(array: arrTemp)
            collectionViewProductImage.reloadData()
        }
        pageControl.numberOfPages = arrProductImage.count
                
        if let temp = dictProduct["rating_list"] as? NSArray {
            arrRatingList = NSMutableArray(array: temp)
        }
        
        var count = arrRatingList.count
        
        if arrRatingList.count > 4 {
            count = 4
        }
        viewReviewHgtConst.constant = CGFloat((count * 80) + 75)
        
        tblReview.reloadData()

    }
    
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
        
        lblTimer.text = "\(temp)"
        
        timeCounter -= 1
    }

    private func swipeCellToRight(_ index: NSInteger) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionViewProductImage.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: true)
    }
    
    private func swipeCellToLeft(_ index: NSInteger) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionViewProductImage .scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: true)
    }

    // MARK: - UITapGestureRecognizer Methods
    @objc func handleSwipeLeft(_ sender: UISwipeGestureRecognizer? = nil) {
        
        var indexPath = IndexPath()
        
        let tapLocation = sender!.location(in: collectionViewProductImage)
        indexPath = collectionViewProductImage.indexPathForItem(at: tapLocation)!
        
        var swipeLeft = (indexPath as NSIndexPath).row
        
        if swipeLeft == 0 { // Check if left swipe count is 0 than return
            return
        }
        swipeLeft = (indexPath as NSIndexPath).row - 1
        
        pageControl.currentPage = swipeLeft
        
        // Perform change collectionview frame method to Left
        swipeCellToLeft(swipeLeft)
    }
    
    @objc func handleSwipeRight(_ sender: UISwipeGestureRecognizer? = nil) {
        
        var indexPath = IndexPath()
        
        let tapLocation = sender!.location(in: collectionViewProductImage)
        indexPath = collectionViewProductImage.indexPathForItem(at: tapLocation)!
        
        var swipeRight = (indexPath as NSIndexPath).row
        
        if swipeRight == arrProductImage.count - 1 {
            return
        }
        swipeRight = (indexPath as NSIndexPath).row + 1
        
        pageControl.currentPage = swipeRight
        
        // Perform change collectionview frame method to Right
        swipeCellToRight(swipeRight)
    }

}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ProductDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as? ProductImageCell
        
        let dictProductImage = arrProductImage[indexPath.item] as? NSDictionary
        
        if Util.isValidString(dictProductImage!["product_image"] as! String) {
            
            let imageUrl = dictProductImage!["product_image"] as! String
            
            let url = URL.init(string: imageUrl)
            
            cell?.imgviewProduct.kf.indicatorType = .activity
            cell?.imgviewProduct.kf.indicator?.startAnimatingView()
            
            let resource = ImageResource(downloadURL: url!)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    cell?.imgviewProduct.image = value.image
                case .failure( _):
                    cell?.imgviewProduct.image = UIImage(named: "dummy_user")
                }
                cell?.imgviewProduct.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            cell?.imgviewProduct.image = UIImage(named: "dummy_user")
        }

        // Add left swipe |UITapGestureRecognizer| to swipe matched home
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductDetailVC.handleSwipeRight(_:)))
        leftSwipeGesture.delegate = self
        leftSwipeGesture.numberOfTouchesRequired = 1
        leftSwipeGesture.direction = UISwipeGestureRecognizer.Direction.left
        cell?.contentView.addGestureRecognizer(leftSwipeGesture)
        
        // Add rightSwipeGesture swipe |UITapGestureRecognizer| to swipe matched home
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(ProductDetailVC.handleSwipeLeft(_:)))
        rightSwipeGesture.delegate = self
        rightSwipeGesture.numberOfTouchesRequired = 1
        rightSwipeGesture.direction = UISwipeGestureRecognizer.Direction.right
        cell?.contentView.addGestureRecognizer(rightSwipeGesture)

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ProductDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRatingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell
        cell?.selectionStyle = .none
        
        let dictReview = arrRatingList[indexPath.row] as? NSDictionary
        
        cell?.lblUsername.text = Util.createUsername(dictReview!)
        cell?.lblReview.text = dictReview!["feedback_message"] as? String
        
        cell?.ratingBar.value = 0.0
        if let temp = dictReview!["rating"] as? String {
            if Util.isValidString(temp) {
                cell?.ratingBar.value = CGFloat(Double(temp)!)
            }
        }

        var feedbackDate = ""
        
        if let temp = dictReview!["feedback_date"] as? String {
            let tempDate = Util.getDateFromString(temp, sourceFormat: "yyyy-MM-dd HH:mm:ss", destinationFormat: "yyyy-MM-dd HH:mm:ss.SSS")
            
            feedbackDate = Util.relativeDateStringForDate(tempDate)
            
            if feedbackDate != "Just now" {
                feedbackDate = "\(feedbackDate) ago"
            }
        }
        cell?.lblDate.text = feedbackDate
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
