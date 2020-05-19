//
//  Minifigure.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
class LegoMinifig : Lego {
    let minifigNumber : String
    var ownedInSets : Int = 0
    var ownedLoose : Int = 0
    var ownedTotal : Int = 0
    var wanted : Bool = false
    var name : String = "Dumny"
    var category : String = "Dumny"
    
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
    
    func match(_ search:String) -> Bool{
        let lower = search.lowercased()
        let matched = name.lowercased().contains(lower)
            || category.lowercased().contains(lower)
        || minifigNumber.lowercased().contains(lower)

        return matched
    }
    
    var theme : String {
        guard let str = category.components(separatedBy: "/").first else {return ""}
        //str.remove(at: str.endIndex)
        return str
    }
    var subtheme : String {
        guard var str = category.components(separatedBy: "/").last else {return ""}
        str.remove(at: str.startIndex)
        return str
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
extension LegoMinifig{
 
}
