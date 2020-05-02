//
//  LegoSet.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import RealmSwift
class LegoSet : Object {
    @objc dynamic var setID : Int = 0
    @objc dynamic var number : Int = 0
    @objc dynamic var name = ""
    @objc dynamic var year : Int = 0
    
    @objc dynamic var theme = ""
    @objc dynamic var themeGroup = ""
    @objc dynamic var  category = ""
    @objc dynamic var released : Bool = true
    @objc dynamic var pieces : Int = 0
    @objc dynamic var  minifigs : Int = 0
    @objc dynamic var bricksetURL = ""
    
    @objc dynamic var rating : Float = 0
    @objc dynamic var instructionsCount : Float = 0
    
    @objc dynamic var collection: LegoSetCollection?
    override static func primaryKey() -> String? {
        return "id"
    }
}

class LegoSetCollection : Object {
    @objc dynamic var owned : Bool = true
    @objc dynamic var wanted : Bool = true
    @objc dynamic var qtyOwned : Int = 0
    @objc dynamic var rating : Float = 0
    @objc dynamic var notes = ""
}

