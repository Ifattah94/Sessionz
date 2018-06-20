//
//  Flag.swift
//  Sessionz
//
//  Created by C4Q on 5/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
struct Flags: Codable {
    let flagID: String
    //    let userID: String
    let flaggedBy: String //userID of poster
    let userFlagged: String //userID of person being flagged
    let flagMessage: String //users reasoning for flagging
    
    func flagsToJSON() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: [])
    }
}
