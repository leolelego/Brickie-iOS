//
//  Minifigure.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
class LegoMinifig : Lego , Hashable{
 
    let minifigNumber : String
    var ownedInSets : Int = 0
    var ownedLoose : Int = 0
    var ownedTotal : Int = 0
    var wanted : Bool = false
    var name : String?
    var category : String?
    var notes : String?  // Notes from API directly
    var bricksetURL : String { return "https://brickset.com/minifigs/\(minifigNumber)" }
    
    static func == (lhs: LegoMinifig, rhs: LegoMinifig) -> Bool {
        return lhs.minifigNumber == rhs.minifigNumber
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(minifigNumber)
        hasher.combine(category)
    }
    
    func update(from: LegoMinifig){
        objectWillChange.send()
        ownedInSets = from.ownedInSets
        ownedLoose = from.ownedLoose
        ownedTotal = from.ownedTotal
        wanted = from.wanted
    }

    
    func matchString(_ search: String) -> Bool {
         let matched = name?.lowercased().contains(search) ?? false
             || category?.lowercased().contains(search) ?? false
             || minifigNumber.lowercased().contains(search)
             || notes?.lowercased().contains(search) ?? false
         return matched
     }
    var nameUI : String {
        guard let str = name?.components(separatedBy: " - ").first else {return minifigNumber}
        return str
    }
    var subNames : [String] {
        guard var components = name?.components(separatedBy: " - ") else {return []}
        components.removeFirst()
        return components
        
    }
    var theme : String {
        guard let str = category?.components(separatedBy: " / ").first else {return ""}
        //str.remove(at: str.endIndex)
        return str
    }
    var subthemes : [String] {
        guard var components = category?.components(separatedBy: " / ") else {return []}
        
        components.removeFirst()
        return components
        
    }
    var subtheme : String {
        return subthemes.first ?? ""
    }
    
    var imageUrl : String {
        return "https://www.bricklink.com/ML/\(minifigNumber).jpg"
    }
    var tumbnailUrl : String {
        return "https://img.bricklink.com/ItemImage/MT/0/\(minifigNumber).t1.png"
    }
    
    init(){
        minifigNumber = "col359"
        name = "Breakdancer - Minifigure Only Entry"
        category = "Collectible Minifigures / Series 20 Minifigures"
        
    }
    
    
}

extension LegoMinifig : Identifiable {
    var id: String {minifigNumber}
}

