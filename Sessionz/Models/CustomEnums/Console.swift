//
//  Console.swift
//  Sessionz
//
//  Created by C4Q on 5/17/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
class Console: Codable {
    var Xbox360 = "Xbox 360"
    var PS4 = "PS4"
    var PC = "PC"
    
    func allConsoles() -> [String] {
        return ["Xbox 360", "PS4", "PC"]
    }
}
