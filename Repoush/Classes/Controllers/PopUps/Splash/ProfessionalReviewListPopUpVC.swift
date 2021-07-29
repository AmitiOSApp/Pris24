//
//  ProfessionalReviewListPopUpVC.swift
//  Repoush
//
//  Created by Apple on 28/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//


import UIKit
protocol delegateProfessionalReviewlist {
    func getProfessionalReviewlist()
}
class ProfessionalReviewListPopUpVC: UIViewController {
   @IBOutlet var tblView: UITableView!
//   @IBOutlet var floatRatingView: FloatRatingView!
//   @IBOutlet var lblReviews: UILabel!
   @IBOutlet var lblRatings: UILabel!
   @IBOutlet var lblName: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var bgViewConstraint: NSLayoutConstraint!
    var isPersonal = true
    var delagate: delegateProfessionalReviewlist!
   
    var ratingList = [ModelRatingProfessionalList]()
    var rating = ""
    var userId = ""
    var OtherUserId = ""
    var name = ""
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        floatRatingView.delegate = self
//        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
//        floatRatingView.type = .halfRatings
        // Do any additional setup after loading the view.
        
        if isPersonal == true {
            if ratingList.count > 0 {
                self.bgViewConstraint.constant = 440
            }else{
                
            }
        } else{
            self.bgViewConstraint.constant = 92
        }
        self.imgView.sd_setImage(with: URL(string:image), placeholderImage:#imageLiteral(resourceName: "profileuser"))
        self.lblRatings.text = String(format: "%.1f",rating.toDouble()! as CVarArg)
        self.lblName.text = name.capitalizingFirstLetter()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    @IBAction func actionCross(_ Sender:Any){
        self.dismiss(animated: true, completion: nil)
        if self.delagate != nil {
            self.delagate.getProfessionalReviewlist()
        }
        }
    }

extension ProfessionalReviewListPopUpVC : UITableViewDelegate,UITableViewDataSource{
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
    if isPersonal == true {
        return ratingList.count
    } else{
        return ratingList.count
    }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell : BuyerMultipleRatingTableViewCell?
    cell = tableView.dequeueReusableCell(withIdentifier: "BuyerMultipleRatingTableViewCell", for: indexPath) as? BuyerMultipleRatingTableViewCell
    
    if isPersonal == true {
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
    } else{
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
    }
    return cell!
    }
}
extension ProfessionalReviewListPopUpVC: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
//    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
//        self.rating = String(format: "%.2f", self.floatRatingView.rating)
//
//    }
//    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
//        self.lblRatings.text = String(format: "%.2f", self.floatRatingView.rating)
//        self.rating = String(format: "%.2f", self.floatRatingView.rating)
//    }
    
}
