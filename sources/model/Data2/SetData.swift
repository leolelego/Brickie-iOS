//
//  SetData.swift
//  Brickie
//
//  Created by Léo on 07/10/2024.
//  Copyright © 2024 Homework. All rights reserved.
//

import Foundation
import SwiftData

@Model
final class SetData : Codable {
    #Unique<SetData>([\.setID])
   var setID: Int
    var number : String = ""
    var name : String = ""
    var year : Int = 0
    
    init(setID: Int, number: String, name: String, year: Int) {
        self.setID = setID
        self.number = number
        self.name = name
        self.year = year
    }
    
    enum CodingKeys: CodingKey {
        case setID, name, number, year
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.setID = try container.decode(Int.self, forKey: .setID)
        self.number = try container.decode(String.self, forKey: .number)
        self.name = try container.decode(String.self, forKey: .name)
        self.year = try container.decode(Int.self, forKey: .year)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setID, forKey: .setID)
        try container.encode(number, forKey: .number)
        try container.encode(name, forKey: .name)
        try container.encode(year, forKey: .year)
    }
}
