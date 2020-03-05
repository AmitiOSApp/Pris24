//
//  FilterVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/4/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import MapKit

class FilterVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapviewLocation: MKMapView!
    @IBOutlet weak var lblCurrentAddress: MKMapView!
    @IBOutlet weak var lblFilterType: UILabel!
    @IBOutlet weak var collectionviewFilterRange: UICollectionView!

    // MARK: - Property initialization
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        
    }
    
    @IBAction func btnSelectAddress_Action(_ sender: UIButton) {
        
    }
    
    @IBAction func btnShowItems_Action(_ sender: UIButton) {
        
    }

}
