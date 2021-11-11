////
////  Minifigure.swift
////  BrickSet
////
////  Created by Work on 10/05/2020.
////  Copyright © 2020 LEOLELEGO. All rights reserved.
////
//
import Foundation
import CoreData

protocol LegoCoreData {
    static func updateOrCreate(_ json:[[String : Any]])
    
}
typealias LegoCoreDataArray = [LegoCoreData]
class LegoMinifigCD : NSManagedObject, LegoCoreData /*, Lego */  {
    

    public var minifigNumberStr: String {
        minifigNumber ?? "Unknown"
    }

    var bricksetURL : String { return "https://brickset.com/minifigs/\(minifigNumberStr)" }
////
////    static func == (lhs: LegoMinifigCD, rhs: LegoMinifigCD) -> Bool {
////        return lhs.minifigNumber == rhs.minifigNumber
////    }
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(name)
////        hasher.combine(minifigNumber)
////        hasher.combine(category)
////    }
////

////
////
    func matchString(_ search: String) -> Bool {
         let matched = name?.lowercased().contains(search) ?? false
             //|| category?.lowercased().contains(search) ?? false
             || minifigNumberStr.lowercased().contains(search)
         return matched
     }
    var nameUI : String {
        guard let str = name?.components(separatedBy: " - ").first else {return minifigNumberStr}
        return str
    }
    var subNames : [String] {
        guard var components = name?.components(separatedBy: " - ") else {return []}
        components.removeFirst()
        return components

    }
    var theme : String {
        guard let str = category?.components(separatedBy: " / ").first else {return ""}
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
        return "https://www.bricklink.com/ML/\(minifigNumberStr).jpg"
    }
    var tumbnailUrl : String {
        return "https://img.bricklink.com/ItemImage/MT/0/\(minifigNumberStr).t1.png"
    }

}

extension LegoMinifigCD {
    enum CodingKeys: String {
            case minifigNumber
            case ownedInSets
            case ownedLoose
            case ownedTotal
            case wanted
            case name
            case category
        }
    static func updateOrCreate(_ json:[[String : Any]]){

        for item in json {
            if let id = item["minifigNumber"] as? String {
                let request = fetchRequest()
                request.predicate = NSPredicate(format: "minifigNumber = %@", id)
                
                if let existingObj = (try? PersistenceController.shared.container.viewContext.fetch(request))?.first{
                    existingObj.update(from: item)

                                        

                } else {
                    create(from: item)
                }
                
            }
        }
        try? PersistenceController.shared.container.viewContext.save()

    }
    static func create(from: [String:Any]){
        let managedObjectContext = PersistenceController.shared.container.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "LegoMinifigCD", in: managedObjectContext)
        else {
            fatalError("Failed to decode LegoMinifigCD")

        }
        let item = LegoMinifigCD(entity: entity, insertInto: managedObjectContext)
        log("Create NEW Fig: \(self)")
        item.update(from: from)

    }
    func update(from: [String:Any]){
//        objectWillChange.send()
        self.name = from[CodingKeys.name.rawValue] as? String
        self.category = from[CodingKeys.category.rawValue] as? String
        self.minifigNumber = from[CodingKeys.minifigNumber.rawValue] as? String
        self.ownedInSets = from[CodingKeys.ownedInSets.rawValue] as? Int16 ?? 0
        self.ownedLoose = from[CodingKeys.ownedLoose.rawValue] as? Int16 ?? 0
        self.ownedTotal = from[CodingKeys.ownedTotal.rawValue] as? Int16 ?? 0
        self.wanted = from[CodingKeys.wanted.rawValue] as? Bool ?? false



        log("Updating Fig: \(self)")
    }
}
////
//extension LegoMinifigCD : Identifiable {
//    var id: String {minifigNumber}
//}
////extension LegoMinifig{
////
////}
