//
//  UserProfile.swift
//  Sessionz
//
//  Created by C4Q on 5/17/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import Firebase

class UserProfile: Codable{
    let userID: String
    let displayName: String
    var team: String?
    let image: String?
    var flags: Int
    var isBanned: Bool
    var console: String?
    var onlineProfile: String? 
    
    
    init(withSnapshot snapshot: NSDictionary) {
        userID = snapshot.value(forKey: "userID") as? String ?? "no userID"
        displayName = snapshot.value(forKey: "displayName") as? String ?? "no display name"
        team = snapshot.value(forKey: "character") as? String ?? "No Character/Team"
        image = snapshot.value(forKey: "image") as? String ?? "No Image"
        flags = snapshot.value(forKey: "flags") as? Int ?? 0
        isBanned = snapshot.value(forKey: "isBanned") as? Bool ?? false
        console = snapshot.value(forKey: "console") as? String ?? "No Console"
        onlineProfile = snapshot.value(forKey: "onlineTag") as? String ?? "No Online Profile"
        
    }
    
    init(withUserID userID: String, displayName: String, team: String?, image: String?, flags: Int, isBanned: Bool, console: String?, onlineProfile: String?) {
        self.userID = userID
        self.displayName = displayName
        self.team = team
        self.image = image
        self.flags = flags
        self.isBanned = isBanned
        self.console = console
        self.onlineProfile = onlineProfile
    }
    
    
    
    
    //trying to convert the parrot object into json data and add to database
    func convertToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
        
    }
}
