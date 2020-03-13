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
    private var arrDistanceRange = ["5", "10", "25", "50", "100", "All".localiz()]
    private var locManager = CLLocationManager()
    private var latitude = 0.0
    private var longitude = 0.0
    private var selectedIndex = 5

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if arrDistanceRange.contains(appDelegate.distance) {
            for i in 0..<arrDistanceRange.count {
                if arrDistanceRange[i] == appDelegate.distance {
                    selectedIndex = i
                    break
                }
            }
        }
        
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
        navigationController?.popViewController(animated: true)
    }

}

// MARK: CLLocationManagerDelegate
extension FilterVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
            self.mapviewLocation.setRegion(region, animated: true)
            
            ReverseGeocoding.geocode(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: { (placeMark, completeAddress, error) in
                
                if let placeMark = placeMark, let completeAddress = completeAddress {
                    print(placeMark)
                    self.lblCurrentAddress.text = completeAddress
                }
                else {
                    // do something with the error
                }
            })
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
        
        if indexPath.item == 5 {
            cell?.lblDistanceRange.text = arrDistanceRange[indexPath.item]
            cell?.viewDevider.isHidden = true
        }
        else {
            cell?.lblDistanceRange.text = "\(arrDistanceRange[indexPath.item]) \("km".localiz())"
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
                self.lblFilterType.text = "All auctions".localiz()
                appDelegate.distance = ""
            }
            else {
                self.lblFilterType.text = "\(self.arrDistanceRange[indexPath.item]) \("km".localiz())"
                appDelegate.distance = self.arrDistanceRange[indexPath.item]
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

class ReverseGeocoding {
    
    static func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, _ completeAddress: String?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, nil, error)
                return
            }
            
            let completeAddress = getCompleteAddress(placemarks)
            
            completion(placemark, completeAddress, nil)
        }
    }
    
    static private func getCompleteAddress(_ placemarks: [CLPlacemark]?) -> String {
        guard let placemarks = placemarks else {
            return ""
        }
        
        let place = placemarks as [CLPlacemark]
        if place.count > 0 {
            let place = placemarks[0]
            var addressString : String = ""
            if place.thoroughfare != nil {
                addressString = addressString + place.thoroughfare! + ", "
            }
            if place.subThoroughfare != nil {
                addressString = addressString + place.subThoroughfare! + ", "
            }
            if place.locality != nil {
                addressString = addressString + place.locality! + ", "
            }
            if place.postalCode != nil {
                addressString = addressString + place.postalCode! + ", "
            }
            if place.subAdministrativeArea != nil {
                addressString = addressString + place.subAdministrativeArea! + ", "
            }
            if place.country != nil {
                addressString = addressString + place.country!
            }
            return addressString
        }
        return ""
    }
}
