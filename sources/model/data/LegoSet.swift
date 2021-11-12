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
    
    let currentlocale = Locale.current
    
    switch Locale(identifier: currentlocale.regionCode!).identifier {
    case "ca":
        f.currencyCode = "CAD"
        break
    case "us":
        f.currencyCode = "USD"
        break
    case "gb":
        f.currencyCode = "GBP"
        break
    default:
        f.currencyCode = "EUR"
    }
    return f
}()
class LegoSet : Lego, Hashable {
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
    
    var pricePerPiece : String? {
        switch Locale(identifier: Locale.current.regionCode!).identifier {
        case "ca", "us","gb":
            return currencyFormatter.string(for: pricePerPieceFloat)
        default:
            currencyFormatter.currencyCode = "EUR"
            return currencyFormatter.string(for: pricePerPieceFloat)
        }
    }
    
    var pricePerPieceFloat: Float {
        guard let piec = pieces, piec != 0 else {return 0}
        return priceFloat / Float(piec)
    }
    
    var priceFloat : Float {
           let currentlocale = Locale.current
           switch Locale(identifier: currentlocale.regionCode!).identifier {
           case "ca":
               return LEGOCom["CA"]?.retailPrice ?? 0
           case "us":
               return LEGOCom["US"]?.retailPrice ?? 0
           case "gb":
               return LEGOCom["UK"]?.retailPrice ?? 0
           default:
               return LEGOCom["DE"]?.retailPrice ?? 0
           }
       }
    
    
    var additionalImages : [LegoSetImage]?
    var instrucctions : [LegoInstruction]?

    
    static func == (lhs: LegoSet, rhs: LegoSet) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(setID)
        hasher.combine(category)
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
            || barcode?.UPC?.contains(search) ?? false
        
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

extension Array where  Element:LegoSet {
    var qtyOwned : Int {
        return self.compactMap { return $0.collection.qtyOwned}.reduce(0, +)
    }
    var qtyWanted : Int {
        return self.compactMap { return $0.collection.wanted ? 1 : 0}.reduce(0, +)
    }
    var priceOwned : Float {
        return self.compactMap { return Float($0.collection.qtyOwned) * $0.priceFloat}.reduce(0, +)
    }
}

struct LegoSetImage : Codable,Equatable {
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

struct LegoInstruction : Codable,Equatable {
    let URL : String
    let description : String
}

struct LegoBarCode : Codable {
    let EAN : String?
    let UPC : String?
}
