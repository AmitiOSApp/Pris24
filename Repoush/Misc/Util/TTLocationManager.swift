//
//  LocationHelper.swift
//  Demo_Test
//

import Foundation
import CoreLocation

protocol TTLocationManagerDelegate {
    func locationUpdated(lat: Double, lon: Double)
}

struct Address {
    //setting them as optional because
    //sometimes the GeoCoder cannot find
    //these from a placemark
    var name: String? = nil
    var postCode: String? = nil
    var locality: String? = nil
    var city: String? = nil
    var country: String? = nil
    var state: String? = nil //could be state or province
    
    func toString() -> String {
        //        if let n = name,
        //            let cty = city,
        //            let ctry = country {
        //            return "\(n), \(cty) (\(ctry))"
        //        }
        return "\(name ?? ""), \(city ?? ""), \(state ?? ""), \(postCode ?? "")"
    }
}

class TTLocationManager: NSObject, CLLocationManagerDelegate  {
    
    static let sharedInstance: TTLocationManager = {
        let instance = TTLocationManager()
        return instance
    } ()
    
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: TTLocationManagerDelegate?
    var locationManagerUpdate:Bool = false

    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManagerUpdate = true
        self.locationManager?.startUpdatingLocation()
    }
    
    @objc func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
        self.locationManagerUpdate = true
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        if self.locationManagerUpdate == true {
            self.locationManagerUpdate = false
            self.perform(#selector(self.stopUpdatingLocation), with: nil, afterDelay: 3)

            // singleton for get last location
            self.lastLocation = location
            
            // use for real time update location
            updateLocation(currentLocation: location)
        }
      
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // do on error
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        print(currentLocation)
        delegate.locationUpdated(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard self.delegate != nil else {
            return
        }
        print("error", error)
    }
}
/*
 Technically we could separate out the Geolocation to it's own
 GeoLocationHelper wrapper class but for this, we will just
 keep it simple
 */
class LocationAddress: NSObject {
    
    class func getCoordinateAddress(lat: Double, lon: Double, completion: @escaping (_ address: Address?) -> ()) {
        let location = CLLocation(latitude: lat, longitude: lon)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                return
            }
            if let placesFound = placemarks {
                // if you want to know more about everything that the CLLPlacemark class
                //offers the checkout the offical docs
                //https://developer.apple.com/documentation/corelocation/clplacemark
                for place in placesFound {
                    var address = Address()
                    address.name = place.name
                    address.city = place.locality
                    address.state = place.administrativeArea
                    address.country = place.country
                    address.postCode = place.postalCode
                    completion(address)
                }
                
            }
        }
    }
}

