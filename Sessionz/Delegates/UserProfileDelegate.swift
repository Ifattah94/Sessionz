//
//  UserProfileDelegate.swift
//  Sessionz
//
//  Created by C4Q on 5/31/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserProfileDelegate: class {
    func didAddInfoToUser(_ userService: UserProfileService)
    func didFailToAddInfoToUser(_ userService: UserProfileService, error: Error)
}

