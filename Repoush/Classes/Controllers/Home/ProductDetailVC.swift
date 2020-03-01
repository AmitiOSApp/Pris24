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
    @IBOutlet weak var btnTimeLeft: UIButton!
    @IBOutlet weak var lblSelling: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblProductDetails: UILabel!
    @IBOutlet weak var lblPickupLocation: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: - Property initialization
    var dictProduct = NSDictionary()
    var arrProductImage = NSMutableArray()
 
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setProductDetail()
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private Methods
    private func setProductDetail() {
        
        lblProductName.text = dictProduct["selling"] as? String
        lblSelling.text = dictProduct["selling"] as? String
        lblUsername.text = Util.createUsername(dictProduct)
        btnDistance.setTitle("\(dictProduct["distance"] ?? "0.0")", for: .normal)
        lblOriginalPrice.text = "$\(dictProduct["base_price"] ?? "0.0")"
        lblOfferPrice.text = "$\(dictProduct["offer_price"] ?? "0.0")"
        lblBrand.text = dictProduct["brand"] as? String
        lblSize.text = dictProduct["size"] as? String
        lblGender.text = dictProduct["gender"] as? String
        lblCondition.text = dictProduct["product_condition"] as? String
        lblProductDetails.text = dictProduct["description"] as? String
        lblPickupLocation.text = dictProduct["address"] as? String

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
                case .failure( _):
                    self.imgviewUser.image = UIImage(named: "dummy_user")
                }
                self.imgviewUser.kf.indicator?.stopAnimatingView()
            }
        }
        else {
            self.imgviewUser.image = UIImage(named: "dummy_user")
        }
        
        if let arrTemp = dictProduct["product_image"] as? NSArray {
            arrProductImage = NSMutableArray(array: arrTemp)
            collectionViewProductImage.reloadData()
        }
        pageControl.numberOfPages = arrProductImage.count
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
        return CGSize(width: 320, height: 275)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
