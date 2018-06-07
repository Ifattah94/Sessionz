//
//  UserProfile.swift
//  Sessionz
//
//  Created by C4Q on 5/17/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
struct UserProfile: Codable{
    let userID: String
    let displayName: String
    var team: String?
    let image: String?
    var flags: Int
    var isBanned: Bool
    var console: String?
    var onlineProfile: String? 
    
    
    
    
    
    //trying to convert the parrot object into json data and add to database
    func convertToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
