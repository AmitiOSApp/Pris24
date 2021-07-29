//
//  BuyerMultipleReviewPopUpVC.swift
//  Repoush
//
//  Created by mac  on 28/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit

class BuyerMultipleReviewPopUpVC: UIViewController {
   @IBOutlet var tblView: UITableView!
   @IBOutlet var floatRatingView: FloatRatingView!
   @IBOutlet var lblReviews: UILabel!
   @IBOutlet var lblRatings: UILabel!
   @IBOutlet var lblName: UILabel!
    var ratingList = [ModelBuyerReviewRatingList]()
    var rating = ""
    var userId = ""
    var OtherUserId = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        floatRatingView.delegate = self
//        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
//        floatRatingView.type = .halfRatings
        // Do any additional setup after loading the view.
       
        self.lblRatings.text = String(format: "%.2f",rating.toDouble()! as CVarArg)
        self.lblName.text = name
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
  
     
    @IBAction func actionCross(_ Sender:Any){
        self.dismiss(animated: true, completion: nil)
       }
    }

extension BuyerMultipleReviewPopUpVC : UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return ratingList.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell : BuyerMultipleRatingTableViewCell?
    cell = tableView.dequeueReusableCell(withIdentifier: "BuyerMultipleRatingTableViewCell", for: indexPath) as? BuyerMultipleRatingTableViewCell
    cell?.lblName.text = self.ratingList[indexPath.row].firstName + " " + self.ratingList[indexPath.row].lastName
    cell?.lblMessgae.text = self.ratingList[indexPath.row].feedbackMessage
    
    let date = self.convertDateFormater24format(self.ratingList[indexPath.row].feedbackDate)
    cell?.lblDate.text = date[1] + " - " + date[0]
   
    if let rating =  self.ratingList[indexPath.row].rating {
        cell?.floatRatingView.delegate = self
        cell?.floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        cell?.floatRatingView.type = .halfRatings
        cell?.floatRatingView.rating = Double(rating) ?? 0.0
    }
//    var frame = tableView.frame
//    frame.size.height = tableView.contentSize.height
//    self.tblView.frame = frame
//
//    self.tblView.reloadData()
//    self.tblView.layoutIfNeeded()
//    self.tblView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
//    return cell!
  return cell!
    }
}
extension BuyerMultipleReviewPopUpVC: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
        self.rating = String(format: "%.2f", self.floatRatingView.rating)
   
    }
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
        self.rating = String(format: "%.2f", self.floatRatingView.rating)
    }
    
}
class BuyerMultipleRatingTableViewCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblMessgae: UILabel!
    @IBOutlet var floatRatingView: FloatRatingView!
}
