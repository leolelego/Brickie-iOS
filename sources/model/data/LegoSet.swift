//
//  LegoSet.swift
//  BrickSet
//
//  Created by Work on 02/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
//import RealmSwift
let currencyFormatter : NumberFormatter = {
    let f = NumberFormatter()
    f.numberStyle = .currency
    return f
}()
class LegoSet : Lego {
    var setID : Int = 0
    var number : String = ""
    var name : String = ""
    var year : Int = 0
    
    var theme : String = ""
    var themeGroup : String? = ""
    var subtheme : String? = ""
    var category : String = ""
//    var released : Bool = true
    var pieces : Int? = 0
    let minifigs : Int?
    let image : LegoSetImage
    let bricksetURL : String
    var collection : LegoSetCollection
    let rating : Float
    let instructionsCount : Float
    let LEGOCom : [String:LegoSetPrice]
    let barcode : LegoBarCode?
    var price : String? {
        let currentlocale = Locale.current
        switch Locale(identifier: currentlocale.regionCode!).identifier {
        case "ca":
            return currencyFormatter.string(for: LEGOCom["CA"]?.retailPrice)
        case "us":
            return currencyFormatter.string(for: LEGOCom["US"]?.retailPrice)
        case "gb":
            return currencyFormatter.string(for: LEGOCom["UK"]?.retailPrice)
        default:
            currencyFormatter.currencyCode = "EUR"
            return currencyFormatter.string(for: LEGOCom["DE"]?.retailPrice)
        }
        
        
    }
    
    var additionalImages : [LegoSetImage]?
    var instrucctions : [LegoInstruction]?

    
    static func == (lhs: LegoSet, rhs: LegoSet) -> Bool {
        return lhs.id == rhs.id
    }
 
    
    func update(from: LegoSet){
        objectWillChange.send()
        self.collection = from.collection
    }
    
    func matchString(_ search: String) -> Bool {
        let matched = name.lowercased().contains(search)
            || number.lowercased().contains(search)
            || theme.lowercased().contains(search)
            || themeGroup?.lowercased().contains(search) ?? false
            ||   subtheme?.lowercased().contains(search) ?? false
            || category.lowercased().contains(search)
            || "\(year)".lowercased().contains(search)
            || barcode?.EAN?.contains(search) ?? false
        
        return matched
    }
    
}
extension LegoSet : CustomStringConvertible {
    var description: String {
        return "\(name) - O:\(collection.owned) - W:\(collection.wanted) - Q:\(collection.qtyOwned)"
    }
}
extension LegoSet : Identifiable {
    var id: Int {setID}
}
extension LegoSet : ObservableObject{}



struct LegoSetImage : Codable {
    var thumbnailURL : String?
    var imageURL : String?
}
class LegoSetCollection : Codable {
    var owned : Bool
    var wanted : Bool
    var qtyOwned : Int
    var rating : Float
    var notes = ""
}

struct LegoSetPrices : Codable {
    let US : LegoSetPrice?
    let UK : LegoSetPrice?
    let CA : LegoSetPrice?
    let DE : LegoSetPrice?
}
struct LegoSetPrice : Codable {
    let retailPrice : Float?
}

struct LegoInstruction : Codable {
    let URL : String
    let description : String
}

struct LegoBarCode : Codable {
    let EAN : String?
}
