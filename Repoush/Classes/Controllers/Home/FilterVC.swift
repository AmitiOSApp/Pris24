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
    @IBOutlet weak var lblCurrentAddress: UILabel!
    @IBOutlet weak var lblFilterType: UILabel!
    @IBOutlet weak var collectionviewFilterRange: UICollectionView!

    // MARK: - Property initialization
    private var arrDistanceRange = ["km 5", "km 10", "km 25", "km 50", "km 100", "All"]
    private var locManager = CLLocationManager()
    private var latitude = 0.0
    private var longitude = 0.0
    private var selectedIndex = 5

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // For use in foreground
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Action Methods
    @IBAction func btnBack_Action(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectAddress_Action(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func btnShowItems_Action(_ sender: UIButton) {
        
    }

}

// MARK: CLLocationManagerDelegate
extension FilterVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 13, longitudeDelta: 13))
            self.mapviewLocation.setRegion(region, animated: true)
        }
        locManager.stopUpdatingLocation()
    }
    
}

// MARK: - GMSAutocompleteViewControllerDelegate
extension FilterVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        
        forwardGeocoding(address: place.formattedAddress!)
        
        self.lblCurrentAddress.text = place.formattedAddress!
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            let placemarkCount = placemarks?.count
            
            if placemarkCount! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                
                self.latitude = coordinate!.latitude
                self.longitude = coordinate!.longitude
            }
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension FilterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDistanceRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? FilterCell
        
        cell?.lblDistanceRange.text = arrDistanceRange[indexPath.item]
        
        if indexPath.item == 5 {
            cell?.viewDevider.isHidden = true
        }
        else {
            cell?.viewDevider.isHidden = false
        }
        
        if indexPath.item == selectedIndex {
            cell?.viewSelect.isHidden = false
        }
        else {
            cell?.viewSelect.isHidden = true
        }
        
        cell?.selectRangeHandler = {
            self.selectedIndex = indexPath.item
            self.collectionviewFilterRange.reloadData()
            
            if indexPath.item == 5 {
                self.lblFilterType.text = "All auction"
            }
            else {
                self.lblFilterType.text = self.arrDistanceRange[indexPath.item]
            }
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
