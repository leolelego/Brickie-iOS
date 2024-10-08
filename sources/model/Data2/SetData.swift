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
final class SetData : Decodable{
    #Unique<SetData>([\.setID])
    var setID : Int = 0
    var number : String = ""
    var name : String = ""
    var year : Int = 0
    
    var theme : String = ""
    var themeGroup : String? = ""
    var subtheme : String? = ""
    var category : String = ""
    //var released : Bool = true
    var pieces : Int? = 0
    var minifigs : Int?
//    let image : SetImage
    var bricksetURL : String
//    @Relationship(deleteRule: .cascade, inverse: \SetCollection.legoSet)
//    var collection : SetCollection
    
    var rating : Float
    var packagingType : String
    var availability : String
    var instructionsCount : Float
//    let LEGOCom : [String:Prices.Price]
//    let barcode : BarCode?
//    let dimensions : Dimension
//    let ageRange : AgeRange
//    let collections : Collections
    
    var owned : Bool
    var wanted : Bool
    var qtyOwned : Int
    var ownRating : Float
    var notes = ""
    
    init(setID: Int, number: String, name: String, year: Int,theme: String, themeGroup: String?, subtheme: String?, category: String, pieces: Int?, minifigs: Int?, bricksetURL: String, rating: Float, packagingType: String, availability: String, instructionsCount: Float,owned: Bool, wanted: Bool, qtyOwned: Int, ownRating: Float, notes: String) {
        self.setID = setID
        self.number = number
        self.name = name
        self.year = year
        self.theme = theme
        self.themeGroup = themeGroup
        self.subtheme = subtheme
        self.category = category
        self.pieces = pieces
        self.minifigs = minifigs
        self.bricksetURL = bricksetURL
        self.rating = rating
        self.packagingType = packagingType
        self.availability = availability
        self.instructionsCount = instructionsCount
//        self.collection = collection
        self.owned = owned
        self.wanted = wanted
        self.qtyOwned = qtyOwned
        self.ownRating = ownRating
        self.notes = notes
        
    }
    
    enum CodingKeys: CodingKey {
        case setID, name, number, year, theme, themeGroup, subtheme, category, pieces, minifigs, bricksetURL, rating, packagingType, availability, instructionsCount, collection
    }
//    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.setID = try container.decode(Int.self, forKey: .setID)
        self.number = try container.decode(String.self, forKey: .number)
        self.name = try container.decode(String.self, forKey: .name)
        self.year = try container.decode(Int.self, forKey: .year)
        self.theme = try container.decode(String.self, forKey: .theme)
        self.themeGroup = try? container.decode(String.self, forKey: .themeGroup)
        self.subtheme = try? container.decode(String.self, forKey: .subtheme)
        self.category = try container.decode(String.self, forKey: .category)
        self.pieces = try? container.decode(Int.self, forKey: .pieces)
        self.minifigs = try? container.decode(Int.self, forKey: .minifigs)
        self.bricksetURL = try container.decode(String.self, forKey: .bricksetURL)
        self.rating = try container.decode(Float.self, forKey: .rating)
        self.packagingType = try container.decode(String.self, forKey: .packagingType)
        self.availability = try container.decode(String.self, forKey: .availability)
        self.instructionsCount = try container.decode(Float.self, forKey: .instructionsCount)
        let collection = try container.decode(SetCollection.self, forKey: .collection)
        self.owned = collection.owned
        self.wanted = collection.wanted
        self.qtyOwned = collection.qtyOwned
        self.ownRating = collection.rating
        self.notes = collection.notes
        
    }

}

@Model
final class SetCollection : Decodable {
    var owned : Bool
    var wanted : Bool
    var qtyOwned : Int
    var rating : Float
    var notes = ""
    
    init(owned: Bool, wanted: Bool, qtyOwned: Int, rating: Float, notes: String = "") {
        self.owned = owned
        self.wanted = wanted
        self.qtyOwned = qtyOwned
        self.rating = rating
        self.notes = notes
    }
    
    enum CodingKeys: CodingKey {
        case owned, wanted, qtyOwned, rating, notes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        owned = try container.decode(Bool.self, forKey: .owned)
        wanted = try container.decode(Bool.self, forKey: .wanted)
        qtyOwned = try container.decode(Int.self, forKey: .qtyOwned)
        rating = try container.decode(Float.self, forKey: .rating)
        notes = try container.decode(String.self, forKey: .notes)
    }
}

