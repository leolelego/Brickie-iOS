//
//  Minifigure.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
class LegoMinifig : Codable,Equatable,Hashable {
    let minifigNumber : String
    var ownedInSets : Int = 0
    var ownedLoose : Int = 0
    var ownedTotal : Int = 0
    var wanted : Int = 0
    var name : String = "Dumny"
    var category : String = "Dumny"
    static func == (lhs: LegoMinifig, rhs: LegoMinifig) -> Bool {
        return lhs.minifigNumber == rhs.minifigNumber
    }
    func hash(into hasher: inout Hasher) {
       hasher.combine(name)
       hasher.combine(minifigNumber)
       hasher.combine(category)
     }
}

extension LegoMinifig : Identifiable {
    var id: String {minifigNumber}
}
