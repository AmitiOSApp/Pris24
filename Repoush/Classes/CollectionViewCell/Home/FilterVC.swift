//
//  FilterVC.swift
//  Repoush
//
//  Created by Ravi Sendhav on 3/4/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol getSelectMapCoordinate {
    func delegatSelectCodinateofMap(latitude: String, longitude: String ,distance: String, isMapSelected: Bool)
}
class FilterVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var mapviewLocation: MKMapView!
    @IBOutlet weak var lblCurrentAddress: UILabel!
    @IBOutlet weak var lblTitleNav: UILabel!
    @IBOutlet weak var btnShowItem: UIButton!
    @IBOutlet weak var lblFilterType: UILabel!
   
    
    
    @IBOutlet weak var lblBlue5KM: UILabel!
    @IBOutlet weak var lblBlue10KM: UILabel!
    @IBOutlet weak var lblBlue25KM: UILabel!
    @IBOutlet weak var lblBlue50KM: UILabel!
    @IBOutlet weak var lblBlue100KM: UILabel!
    @IBOutlet weak var lblBlueAllKM: UILabel!
    
    
    @IBOutlet weak var lbl5km: UILabel!
    @IBOutlet weak var lbl10km: UILabel!
    @IBOutlet weak var lbl25km: UILabel!
    @IBOutlet weak var lbl50km: UILabel!
    @IBOutlet weak var lbl100km: UILabel!
    @IBOutlet weak var lblAllkm: UILabel!
    
    var isSelectedMap : Bool = false
   // @IBOutlet weak var collectionviewFilterRange: UICollectionView!
   
    var delagate: getSelectMapCoordinate!
   // var isSelecteKm = false
    
    // MARK: - Property initialization
   // private var arrDistanceRange = ["5", "10", "25", "50", "100", "All".localiz()]
    

    
    var arrDistanceRange = [[String: Any]]()
    private var locManager = CLLocationManager()
    var circle:MKCircle!
    private var latitude = ""
    private var longitude = ""
    private var selectedIndex = 5
    
//    var radiusLatitude = ""
//    var radiusLongitude = ""
    var strRidus = ""
    var locationStatus = "..."
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(self.strRidus)
        
        self.lblBlue5KM.isHidden = true
        self.lblBlue10KM.isHidden = true
        self.lblBlue25KM.isHidden = true
        self.lblBlue50KM.isHidden = true
        self.lblBlue100KM.isHidden = true
        self.lblBlueAllKM.isHidden = false
        
        
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
        }
        if (MyDefaults().language ?? "") as String ==  "en"{
            self.changeLanguage(strLanguage: "en")
        } else{
            self.changeLanguage(strLanguage: "da")
        }
        self.locationConfig()

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationUpdatedLocation(notification:)), name: Notification.Name("NotificationIdentifierLocationUpdated"), object: nil)
        
    }
    func locationConfig(){
        self.locManager.delegate = self
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.requestAlwaysAuthorization()
    }
    @objc func methodOfReceivedNotificationUpdatedLocation(notification: Notification) {
        self.locationOpen()
       }
    func changeLanguage(strLanguage:String) {
            self.btnShowItem.setTitle("show_items".LocalizableString(localization: strLanguage), for: .normal)
            self.lblTitleNav.text = "Filter".LocalizableString(localization: strLanguage)
            self.lblFilterType.text = "All_Auction".LocalizableString(localization: strLanguage)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.setInitialRadius()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.locationOpen()
    }
    func locationOpen()  {
        self.locManager.delegate = self
        self.locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied {
            self.locManager.delegate = self
            self.locManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            
        self.locManager.startUpdatingLocation()
            }else{
                if (MyDefaults().language ?? "") as String ==  "en"{
                    self.permissionGranted(title: "Location Services Disabled!", message: "Please enable Location Based Services for better results! We promise to keep your location private", okay: "ok")
                    } else{
                    self.permissionGranted(title: "Location Services Disabled!", message: "Please enable Location Based Services for better results! We promise to keep your location private", okay: "ok")
                }
                   
                self.locManager.startUpdatingLocation()
                
                return
                }
    
    }
    
    open class Reachability {
            class func isLocationServiceEnabled() -> Bool {
                if CLLocationManager.locationServicesEnabled() {
                    switch(CLLocationManager.authorizationStatus()) {
                        case .notDetermined, .restricted, .denied:
                        return false
                        case .authorizedAlways, .authorizedWhenInUse:
                        return true
                        default:
                        print("Something wrong with Location services")
                        return false
                    }
                } else {
                        print("Location services are not enabled")
                        return false
                  }
                }
             }
    func permissionGranted(title: String, message: String,okay:String)  {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okay, style: UIAlertAction.Style.default) {
               UIAlertAction in
               NSLog("OK Pressed")
          //  UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
           
            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
                            UIApplication.shared.open(url, completionHandler: .none)
                        }
        }
            alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - Action Methods
   @IBAction func btnSelectAddress_Action(_ sender: UIButton) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    @IBAction func btnShowItems_Action(_ sender: UIButton) {
       // navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
//        print(self.strRidus)
//        print(self.latitude)
//        print(self.longitude)
        if delagate != nil {
            self.delagate.delegatSelectCodinateofMap(latitude: self.latitude, longitude: self.longitude, distance: self.strRidus, isMapSelected: true)
        }
        self.arrDistanceRange = Utility.getFilterArray()
        
  }

}

// MARK: CLLocationManagerDelegate
extension FilterVC: CLLocationManagerDelegate,MKMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
            self.latitude =  String(format: "%7f", location.coordinate.latitude)    //location.coordinate.latitude
            self.longitude = String(format: "%7f", location.coordinate.longitude)   //location.coordinate.longitude
            if let userLocation = locManager.location?.coordinate {
                let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
               // mapView.setRegion(viewRegion, animated: false)
              //   self.mapviewLocation.setRegion(viewRegion, animated: true)
               //  self.mapviewLocation.showsUserLocation = true
                let initialLocation = CLLocation(latitude: Double(self.latitude) ?? 0.0, longitude: Double(self.longitude) ?? 0.0)
               // self.centerMapOnLocation(location: initialLocation, radius: 0.0)
               self.mapviewLocation.delegate = self
                if !isSelectedMap {
                   self.loadOverlayForRegionWithLatitude(latitude: Double(self.latitude) ?? 0.0, andLongitude: Double(self.longitude) ?? 0.0, radius: (self.strRidus).doubleValue)
                    
                 
                 //   self.loadOverlayForRegionWithLatitude(latitude: 55.676098, andLongitude: 12.568337, radius: 10.0)
                }
               
            }
            
            
           // self.mapviewLocation.setRegion(region, animated: true)

            ReverseGeocoding.geocode(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: { (placeMark, completeAddress, error) in
                if let placeMark = placeMark, let completeAddress = completeAddress {
                    print(placeMark)
                    self.lblCurrentAddress.text = completeAddress
                    
                    let location = CLLocation(latitude: location.coordinate.latitude , longitude: location.coordinate.longitude)
                    
                   // self.setGeoOrigin(location: location, index: 0, lalatitude : location.coordinate.latitude, lolocation.coordinate.longitude)
                    self.setGeoOrigin(location: location, index: 0, latitude:  location.coordinate.latitude, longitude:  location.coordinate.longitude)
                }
                else {
                    // do something with the error
                }
            })
        }
        locManager.stopUpdatingLocation()
    }
    
    func setGeoOrigin(location : CLLocation,index:Int,latitude : Double , longitude : Double ) {
//        let geoCoder = CLGeocoder()
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//
//                // Place details
//                var placeMark: CLPlacemark!
//            placeMark = placemarks?.first
//
//                // Location name
//                if let locationName = placeMark.location {
//                    print(locationName)
//                }
//                // Street address
//                if let street = placeMark.thoroughfare {
//                    print(street)
//                }
//                // City
//                if let city = placeMark.locality {
//                    print(city)
//                }
//                // State
//                if let state = placeMark.administrativeArea {
//                    print(state)
//                }
//                // Zip code
//                if let zipCode = placeMark.postalCode {
//                    print(zipCode)
//                }
//                // Country
//                if let country = placeMark.country {
//                    print(country)
//                }
//            print(placeMark.postalCode)
//            print(placemarks)
//            })
   
    
        self.getAddressFromLatLong(latitude: latitude, longitude: longitude)
    
    }
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&AIzaSyDGK6hZzj4wC-eCCLnFf8VKdNdtnvkc3S8"

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            let address = results[0]["formatted_address"] as? String
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "postal_code") {
                                        let pincode = component["long_name"] as? String
                                    }
                                    if (temp[0] == "locality") {
                                        let city = component["long_name"] as? String
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        let state = component["long_name"] as? String
                                    }
                                    if (temp[0] == "country") {
                                        let country = component["long_name"] as? String
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func centerMapOnLocation(location: CLLocation,radius:Double) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        DispatchQueue.main.async {
            let circle = MKCircle(center: location.coordinate, radius: radius as CLLocationDistance)
            self.mapviewLocation.addOverlay(circle)
            self.mapviewLocation.setRegion(region, animated: true)
          //  self.mapviewLocation.showsUserLocation = true
            
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer  {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    func getRadius(centralLocation: CLLocation) -> Double{
        let topCentralLat:Double = centralLocation.coordinate.latitude -  self.mapviewLocation.region.span.latitudeDelta/2
        let topCentralLocation = CLLocation(latitude: topCentralLat, longitude: centralLocation.coordinate.longitude)
        let radius = centralLocation.distance(from: topCentralLocation)
        return radius / 1000.0 // to convert radius to meters
    }
    func setMapFocus(centerCoordinate: CLLocationCoordinate2D, radiusInKm radius: CLLocationDistance)
    {
        let diameter = radius * 1000
        let region: MKCoordinateRegion = MKCoordinateRegion(center: locManager.location!.coordinate, latitudinalMeters: diameter, longitudinalMeters: diameter)
        self.mapviewLocation.setRegion(region, animated: true)
        }
    
    func removeCircle() {
        let overlays = self.mapviewLocation.overlays
        self.mapviewLocation.removeOverlays(overlays)
    }
    
    func zoomForAllOverlays() {
        
        let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        guard let initial = self.mapviewLocation.overlays.first?.boundingMapRect else { return }
        let mapRect = self.mapviewLocation.overlays
            .dropFirst()
            .reduce(initial) { $0.union($1.boundingMapRect) }
        self.mapviewLocation.setVisibleMapRect(mapRect, edgePadding: insets, animated: true)
    }
    @IBAction func actionOn5KM(_ sender:Any){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlue5KM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = false
                            self.lblBlue10KM.isHidden = true
                            self.lblBlue25KM.isHidden = true
                            self.lblBlue50KM.isHidden = true
                            self.lblBlue100KM.isHidden = true
                            self.lblBlueAllKM.isHidden = true

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlue5KM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        Utility.setFilterkilometer(data: ["kilometer":"5"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "5")
        
    }
    @IBAction func actionOn10KM(_ sender:Any){
   
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlue10KM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = true
                            self.lblBlue10KM.isHidden = false
                            self.lblBlue25KM.isHidden = true
                            self.lblBlue50KM.isHidden = true
                            self.lblBlue100KM.isHidden = true
                            self.lblBlueAllKM.isHidden = true

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlue10KM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        Utility.setFilterkilometer(data: ["kilometer":"10"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "10")
        
    }
    @IBAction func actionOn25KM(_ sender:Any){
        
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlue25KM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = true
                            self.lblBlue10KM.isHidden = true
                            self.lblBlue25KM.isHidden = false
                            self.lblBlue50KM.isHidden = true
                            self.lblBlue100KM.isHidden = true
                            self.lblBlueAllKM.isHidden = true

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlue25KM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        Utility.setFilterkilometer(data: ["kilometer":"25"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "25")
    }
    @IBAction func actionOn50KM(_ sender:Any){
   
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlue50KM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = true
                            self.lblBlue10KM.isHidden = true
                            self.lblBlue25KM.isHidden = true
                            self.lblBlue50KM.isHidden = false
                            self.lblBlue100KM.isHidden = true
                            self.lblBlueAllKM.isHidden = true

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlue50KM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        
        Utility.setFilterkilometer(data: ["kilometer":"50"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "50")
    }
    @IBAction func actionOn100KM(_ sender:Any){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlue100KM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = true
                            self.lblBlue10KM.isHidden = true
                            self.lblBlue25KM.isHidden = true
                            self.lblBlue50KM.isHidden = true
                            self.lblBlue100KM.isHidden = false
                            self.lblBlueAllKM.isHidden = true

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlue100KM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        Utility.setFilterkilometer(data: ["kilometer":"100"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "100")
    }
    @IBAction func actionOnAllKM(_ sender:Any){
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblBlueAllKM.alpha = 0.0
                }, completion: {
                    finished in

                    if finished {
                        //Once the label is completely invisible, set the text and fade it back in
                            self.lblBlue5KM.isHidden = true
                            self.lblBlue10KM.isHidden = true
                            self.lblBlue25KM.isHidden = true
                            self.lblBlue50KM.isHidden = true
                            self.lblBlue100KM.isHidden = true
                            self.lblBlueAllKM.isHidden = false

                        // Fade in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                            self.lblBlueAllKM.alpha = 1.0
                        }, completion: nil)
                    }
            })
        if (MyDefaults().language ?? "") as String ==  "en"{
            //self.changeLanguage(strLanguage: "en")
            self.lblAllkm.text = "All".LocalizableString(localization: "en")
        } else{
            //self.changeLanguage(strLanguage: "da")
            self.lblAllkm.text = "All".LocalizableString(localization: "da")
        }
        
        Utility.setFilterkilometer(data: ["kilometer":"all"])
        self.makeradiusOnMap(tag: 0, selected: true, range: "")
    }
        func loadOverlayForRegionWithLatitude(latitude: Double, andLongitude longitude: Double ,radius: Double ) {
    
            print(latitude)
            print(longitude)
            print(radius)
            self.removeCircle()
            let diameter = radius * 1000
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            //2
            circle = MKCircle(center: coordinates, radius: diameter)
            //3
            self.mapviewLocation.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
            //4
            self.mapviewLocation.delegate = self
            self.mapviewLocation.addOverlay(circle)
            self.zoomForAllOverlays()
    
        }
        func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
            let circle = MKCircle(center: coordinate, radius: radius)
            self.mapviewLocation.addOverlay(circle)
        }
    
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
            // make sure this is true because that means the user updated the radius
                if let circle = self.circle {
                   // after the mapView finishes add the circle to it
                self.mapviewLocation.addOverlay(circle)
                }
            }
    func makeradiusOnMap(tag:Int,selected:Bool,range:String) {
       print(range)
        if range == "" {
            self.strRidus = ""
        }
        else if range == "100" {
            self.strRidus = "100"
        }
        else if range == "50" {
            self.strRidus = "50"
        }
        else if range == "25" {
            self.strRidus = "25"
        }
        else if range == "10" {
            self.strRidus = "10"
        }
        else if range == "5" {
            self.strRidus = "5"
        }
        self.isSelectedMap = true
if (locManager.location?.coordinate) != nil {
    self.loadOverlayForRegionWithLatitude(latitude: Double(self.latitude) ?? 0.0, andLongitude: Double(self.longitude) ?? 0.0 , radius: (self.strRidus).doubleValue)
        }
    }
    func setInitialRadius()  {
        let data = Utility.getFilterKilometer()
        print(data)
        let kilometer = data["kilometer"] as? String
        print(kilometer)
        print("Location services are not enabled")
        
        
//        switch CLLocationManager.authorizationStatus() {
//            case .notDetermined:
//               // Request when-in-use authorization initially
//               break
//            case .restricted, .denied:
//                if (MyDefaults().language ?? "") as String ==  "en"{
//                    self.permissionGranted(title: "Location Permission Required", message: "Please enable location permissions in settings.", okay: "ok")
//                } else{
//                    self.permissionGranted(title: "Location Permission Required", message: "Please enable location permissions in settings.", okay: "ok")
//            }
//               break
//            case .authorizedWhenInUse, .authorizedAlways:
//               // Enable location features
//                locManager.startUpdatingLocation()
//               break
//        @unknown default: break
//            
//        }

            // 4
        locManager.delegate = self
        locManager.startUpdatingLocation()
        
        
        if kilometer == "5" {
            self.lblBlue5KM.isHidden = false
            self.lblBlue10KM.isHidden = true
            self.lblBlue25KM.isHidden = true
            self.lblBlue50KM.isHidden = true
            self.lblBlue100KM.isHidden = true
            self.lblBlueAllKM.isHidden = true
            self.strRidus = "5"
        } else if kilometer == "10" {
            self.lblBlue5KM.isHidden = true
            self.lblBlue10KM.isHidden = false
            self.lblBlue25KM.isHidden = true
            self.lblBlue50KM.isHidden = true
            self.lblBlue100KM.isHidden = true
            self.lblBlueAllKM.isHidden = true
            self.strRidus = "10"
        } else if kilometer == "25" {
            self.lblBlue5KM.isHidden = true
            self.lblBlue10KM.isHidden = true
            self.lblBlue25KM.isHidden = false
            self.lblBlue50KM.isHidden = true
            self.lblBlue100KM.isHidden = true
            self.lblBlueAllKM.isHidden = true
            self.strRidus = "25"
        } else if kilometer == "50" {
            self.lblBlue5KM.isHidden = true
            self.lblBlue10KM.isHidden = true
            self.lblBlue25KM.isHidden = true
            self.lblBlue50KM.isHidden = false
            self.lblBlue100KM.isHidden = true
            self.lblBlueAllKM.isHidden = true
            self.strRidus = "50"
        } else if kilometer == "100" {
            self.lblBlue5KM.isHidden = true
            self.lblBlue10KM.isHidden = true
            self.lblBlue25KM.isHidden = true
            self.lblBlue50KM.isHidden = true
            self.lblBlue100KM.isHidden = false
            self.lblBlueAllKM.isHidden = true
            self.strRidus = "100"
        } else if kilometer == "All" {
            self.lblBlue5KM.isHidden = true
            self.lblBlue10KM.isHidden = true
            self.lblBlue25KM.isHidden = true
            self.lblBlue50KM.isHidden = true
            self.lblBlue100KM.isHidden = true
            self.lblBlueAllKM.isHidden = false
            self.strRidus = ""
        }
//        if (locManager.location?.coordinate) != nil {
//            self.loadOverlayForRegionWithLatitude(latitude: locManager.location!.coordinate.latitude as CLLocationDegrees, andLongitude: locManager.location!.coordinate.longitude as CLLocationDegrees , radius:(self.strRidus).doubleValue)
//                }
    }
    
    }

// MARK: - GMSAutocompleteViewControllerDelegate
extension FilterVC: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
       // print("Place address full: \(String(describing: place.formattedAddress.))")
        print("Place attributions: \(String(describing: place.attributions))")
        self.isSelectedMap = true
       
        forwardGeocoding(address: place.formattedAddress!)
        self.lblCurrentAddress.text = place.formattedAddress!
        DispatchQueue.main.async {
              //self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        
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
                let country = placemark?.country
                let postalCode = placemark?.postalCode
                let locality = placemark?.locality
                let subLocality = placemark?.subLocality
                let coordinate = location?.coordinate
                self.latitude =  String(format: "%7f",coordinate!.latitude)    //location.coordinate.latitude
                self.longitude = String(format: "%7f",coordinate!.longitude)
               
                
                print(self.latitude)
                 print(self.longitude)
                 self.loadOverlayForRegionWithLatitude(latitude: Double(self.latitude) ?? 0.0, andLongitude: Double(self.longitude) ?? 0.0 , radius: (self.strRidus).doubleValue)
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
//     func isLocationServiceEnabled(controller: UIViewController) -> Bool {
//
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//        self.showAlert(controller: controller)
//    return false
//    case .authorizedAlways, .authorizedWhenInUse:
//    return true
//    default:
//        print("Something wrong with Location services")
//        self.showAlert(controller: controller)
//    return false
//    }
//    } else {
//        print("Location services are not enabled")
//        self.showAlert(controller: controller)
//    return false
//    }
//    }
//    func showAlert(controller: UIViewController){
//
//    //You could show an alert like this.
//    let alertController = UIAlertController(title: "Location Services Disabled", message: "App requires your location in order to show you tools near your location. Your location will not be tracked or shared for any other purpose. Please accept in-order to proceed with user signup.\n Enable location go to Settings > App > Location", preferredStyle: .alert)
//    let OKAction = UIAlertAction(title: "Cancel", style: .default,
//    handler: {
//    (alert: UIAlertAction!) -> Void in
//    // Localize.update(language: language)
//    })
//    let CancelAction = UIAlertAction(title: "Setting", style: .default,handler: {
//    (alert: UIAlertAction!) -> Void in
//
//    if let bundleId = Bundle.main.bundleIdentifier,
//    let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
//    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }
//
//    } )
//    alertController.addAction(OKAction)
//    alertController.addAction(CancelAction)
//    OperationQueue.main.addOperation {
//
//    controller.present(alertController, animated: true,
//    completion:nil)
//    }
//    }
    
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

extension String {
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
}
