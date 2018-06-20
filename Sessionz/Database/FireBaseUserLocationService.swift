//
//  FireBaseUserLocationService.swift
//  Sessionz
//
//  Created by C4Q on 6/8/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
extension UserProfileService {
    public func newUserLocation(location: UserLocation) {
        if let currentUser = AuthUserService.manager.getCurrentUser() {
        
        let child = self.usersRef.child(currentUser.uid).child("location")
        location.locationID = child.key
        child.setValue(location.toJSON())
        
        }
    }
}
