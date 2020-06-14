//
//  Lego.swift
//  BrickSet
//
//  Created by Work on 17/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import Foundation

protocol Lego : ObservableObject, Codable , Equatable, Identifiable {
    
//    var name : String? { get set }
//    var category : String? { get set }
    
    func match(_ search:String) -> Bool
    func matchString(_ search:String) -> Bool
}

extension Lego {
    
    func match(_ search:String) -> Bool {
        let splits = search.lowercased().split(separator: " ")
        for split in splits {
            if matchString(String(split)) == true {
                return true
            }
        }
        return false
    }
//    func hash(into hasher: inout Hasher) {
//         hasher.combine(name)
//         hasher.combine(category)
//     }
//
//    func compareThing1<T: Identifiable>(_ thing1: T, against thing2: T) -> Bool {
//        return true
//    }
}
