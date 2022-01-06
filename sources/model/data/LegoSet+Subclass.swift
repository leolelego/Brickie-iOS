//
//  LegoSet+Subclass.swift
//  Brickie
//
//  Created by Léo on 06/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import Foundation

extension LegoSet {
    class Dimension : Codable {
        let height : Float?
        let width : Float?
        let depth : Float?
        let weight : Float?
    }
    
    struct Instruction : Codable,Equatable {
        let URL : String
        let description : String
    }
    struct SetImage : Codable,Equatable {
        var thumbnailURL : String?
        var imageURL : String?
    }
    struct Collection : Codable {
        var owned : Bool
        var wanted : Bool
        var qtyOwned : Int
        var rating : Float
        var notes = ""
    }
    struct AgeRange : Codable {
        let min : Int? 
    }
    struct Collections : Codable {
        let ownedBy : Int
        var wantedBy : Int
    }

    struct Prices : Codable {
        let US : Price?
        let UK : Price?
        let CA : Price?
        let DE : Price?
        struct Price : Codable {
            let retailPrice : Float?
        }
    }



    struct BarCode : Codable {
        let EAN : String?
        let UPC : String?
    }
}
