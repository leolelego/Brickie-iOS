//
//  Minifigure.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import CoreData
class LegoMinifigCD : NSManagedObject, Codable /*, Lego */  {
 
    
    @NSManaged var minifigNumber : String
//    @NSManaged var ownedInSets : Int
//    @NSManaged var ownedLoose : Int
//    @NSManaged var ownedTotal : Int
//    @NSManaged var wanted : Bool
    @NSManaged var name : String?
//    @NSManaged var category : String?
    
    enum CodingKeys: String, CodingKey {
            case minifigNumber
//            case ownedInSets
//            case ownedLoose
//            case ownedTotal
//            case wanted
            case name
//            case category
        }
    
    // MARK: - Decodable
        required convenience init(from decoder: Decoder) throws {
   

            let managedObjectContext = PersistenceController.shared.container.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "LegoMinifigCD", in: managedObjectContext)
            else {
                fatalError("Failed to decode LegoMinifigCD")

            }
            self.init(entity: entity, insertInto: managedObjectContext)

            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.minifigNumber = try container.decodeIfPresent(String.self, forKey: .minifigNumber) ?? "ERR"
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
//            self.role = try container.decodeIfPresent(String.self, forKey: .role)
        }
    // MARK: - Encodable
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(minifigNumber, forKey: .minifigNumber)
        }
//    var bricksetURL : String { return "https://brickset.com/minifigs/\(minifigNumber)" }
//
    static func == (lhs: LegoMinifigCD, rhs: LegoMinifigCD) -> Bool {
        return lhs.minifigNumber == rhs.minifigNumber
    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//        hasher.combine(minifigNumber)
//        hasher.combine(category)
//    }
//
//    func update(from: LegoMinifig){
//        objectWillChange.send()
//        ownedInSets = from.ownedInSets
//        ownedLoose = from.ownedLoose
//        ownedTotal = from.ownedTotal
//        wanted = from.wanted
//    }
//
//
    func matchString(_ search: String) -> Bool {
         let matched = name?.lowercased().contains(search) ?? false
             //|| category?.lowercased().contains(search) ?? false
             || minifigNumber.lowercased().contains(search)
         return matched
     }
//    var nameUI : String {
//        guard let str = name?.components(separatedBy: " - ").first else {return minifigNumber}
//        return str
//    }
//    var subNames : [String] {
//        guard var components = name?.components(separatedBy: " - ") else {return []}
//        components.removeFirst()
//        return components
//
//    }
//    var theme : String {
//        guard let str = category?.components(separatedBy: " / ").first else {return ""}
//        //str.remove(at: str.endIndex)
//        return str
//    }
//    var subthemes : [String] {
//        guard var components = category?.components(separatedBy: " / ") else {return []}
//
//        components.removeFirst()
//        return components
//
//    }
//    var subtheme : String {
//        return subthemes.first ?? ""
//    }
//
//    var imageUrl : String {
//        return "https://www.bricklink.com/ML/\(minifigNumber).jpg"
//    }
//    var tumbnailUrl : String {
//        return "https://img.bricklink.com/ItemImage/MT/0/\(minifigNumber).t1.png"
//    }
//
//    init(){
//        minifigNumber = "col359"
//        name = "Breakdancer - Minifigure Only Entry"
//        category = "Collectible Minifigures / Series 20 Minifigures"
//
//    }
//
    
}
//
extension LegoMinifigCD : Identifiable {
    var id: String {minifigNumber}
}
//extension LegoMinifig{
//
//}
