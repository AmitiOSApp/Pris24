//
//  EditPostCollectionViewCell.swift
//  Repoush
//
//  Created by mac  on 29/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit

class EditPostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblCategoryName : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var btnCategory : UIButton!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
      
       }
    func reloadCategoryData(categoryImage:String,isSelected:Bool)  {
        self.configureCellEditPost(cell: self, image: categoryImage, isSelected: isSelected)
    }
    func configureCellEditPost(cell:EditPostCollectionViewCell,image:String,isSelected:Bool)  {
                
        if Util.isValidString(image) {
                   let imageUrl = image
                   let url = URL.init(string: imageUrl)
                    cell.imgView.kf.indicatorType = .activity
                    cell.imgView.kf.indicator?.startAnimatingView()
                   let resource = ImageResource(downloadURL: url!)
                   KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                       switch result {
                       case .success(let value):
                           cell.imgView.image = value.image
                       case .failure( _):
                           cell.imgView.image = UIImage(named: "dummy_post")
                       }
                       cell.imgView.kf.indicator?.stopAnimatingView()
                   }
               }
               else {
                   cell.imgView.image = UIImage(named: "dummy_post")
               }
    }
}

