//
//  UserLocation.swift
//  Sessionz
//
//  Created by C4Q on 6/8/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class UserLocation: NSObject, Codable {
    var locationID: String
    var userID: String
    var longitude: Double
    var latitude: Double
    func toJSON() -> Any {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch  {
            print(error)
            fatalError("Could not encode Spot")
        }
    }
    init(location: CLLocation) {
        self.userID = AuthUserService.manager.getCurrentUser()?.uid ?? "NO UID FOUND"
        self.locationID = ""
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
    }
    init (locationID: String, userID: String, longitude: Double, latitude: Double) {
        self.locationID = locationID
        self.userID = userID
        self.longitude = longitude
        self.latitude = latitude
    }
}

extension UserLocation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return ""
    }
}


