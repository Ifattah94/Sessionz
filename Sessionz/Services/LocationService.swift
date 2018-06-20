//
//  LocationService.swift
//  Sessionz
//
//  Created by C4Q on 6/8/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func userLocationDidUpdate(_ userLocation: CLLocation)
    func userLocationsUpdatedFromFirebase(_ locations: [UserLocation])
    
}

class LocationService: NSObject {
    
    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    static let manager = LocationService()
    private var locationManager: CLLocationManager!
    public var locationServiceDelegate: LocationServiceDelegate!
    private var currentUserLocation: CLLocation?
    
    
    func setDelegate(viewController: LocationServiceDelegate) {
        locationServiceDelegate = viewController
    }
    
    func setUserLocation(_ location: CLLocation) {
        currentUserLocation = location
        
    }
    
    func getUserLocation() -> CLLocation? {
        return currentUserLocation
    }
    
    public func checkForLocationServices() {
        let phoneLocationServicesAreEnabled = CLLocationManager.locationServicesEnabled()
        if phoneLocationServicesAreEnabled {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined: // intial state on first launch
                print("not determined")
                locationManager.requestWhenInUseAuthorization()
            case .denied: // user could potentially deny access
                print("denied")
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways:
                print("authorizedAlways")
            case .authorizedWhenInUse:
                print("authorizedWhenInUse")
            default:
                break
            }
        }
    }
    
    public func addUserLocationsFromFirebaseToMap() {
        UserProfileService.manager.getAllUserLocations { (locations) in
            self.locationServiceDelegate.userLocationsUpdatedFromFirebase(locations)
            
        }
    }
    
    func lookUpAddress(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
    
    
    
}
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("Auth Status changed. Authorized")
        default:
            locationManager.stopUpdatingLocation()
            print("Auth Status changed. No longer allowed")
        }
    }
    
    // Handles user location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        locationServiceDelegate.userLocationDidUpdate(userLocation)
        currentUserLocation = userLocation
        print("Updated locations: \(locations)")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

}
