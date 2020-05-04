//
//  LegoSet.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
//import RealmSwift
struct LegoSet : Codable {
    var setID : Int = 0
    var number : String = ""
    var name : String = ""
    var year : Int = 0
    
    var theme : String = ""
    var themeGroup : String = ""
    var subtheme : String? = ""
    var category : String = ""
    var released : Bool = true
    var pieces : Int = 0
    let minifigs : Int?
    let image : LegoSetImage
    let bricksetURL : String
    let collection : LegoSetCollection
    let rating : Float
    let instructionsCount : Float
}

struct LegoSetImage : Codable {
    var thumbnailURL : String
    var imageURL : String
}
struct LegoSetCollection : Codable {
    let owned : Bool
    let wanted : Bool
    let qtyOwned : Int
    let rating : Float
    var notes = ""
}

