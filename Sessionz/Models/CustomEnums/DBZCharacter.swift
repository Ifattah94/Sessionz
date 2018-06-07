//
//  DBZCharacter.swift
//  Sessionz
//
//  Created by C4Q on 5/15/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
enum DBZCharacter: String, Codable {
    case Android16 = "Android 16"
    case KidBuu = "Kid Buu"
    case MajinBuu = "Majin Buu"
    case Ginyu = "Ginyu"
    case AdultGohan = "Adult Gohan"
    case TeenGohan = "TeenGohan"
    case GokuSSJ = "Goku SSJ"
    case GokuBlue = "Goku SSGSS"
    case Krillin = "Krillin"
    case Nappa = "Nappa"
    case Cell = "Cell"
    case Piccolo = "Piccolo"
    case Tien = "Tien"
    case Trunks = "Trunks"
    case VegetaSSJ = "Vegeta SSJ"
    case Yamcha = "Yamcha"
    case Android18 = "Android 18"
    case Android21 = "Android 21"
    case GokuBlack = "Goku Black"
    case Hit = "Hit"
    case Beerus = "Beerus"
    case Frieza = "Frieza"
    case Bardock = "Bardock"
    case Broly = "Broly"
    case Gotenks = "Gotenks"
    
    func charName() -> String {
        return self.rawValue
    }
    static func allCharacters() -> [String] {
        return ["Android 16", "Kid Buu", "Majin Buu", "Adult Gohan", "Teen Gohan", "Goku SSJ", "Goku SSGSS", "Krillin", "Nappa", "Cell", "Piccolo", "Tien", "Trunks", "Vegeta SSJ", "Yamcha", "Android 18", "Android 21", "Goku Black", "Hit", "Beerus", "Frieza", "Bardock", "Broly", "Gotenks"]
    }
    
    
}
