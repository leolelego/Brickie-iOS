//
//  Lego.swift
//  BrickSet
//
//  Created by Work on 17/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import Foundation

protocol Lego : ObservableObject, Codable , Equatable, Identifiable {
    func match(_ search:String) -> Bool
    func matchString(_ search:String) -> Bool
}

extension Lego {
    
    func match(_ search:String) -> Bool {
        return matchString(search.lowercased())
//        let splits = search.lowercased().split(separator: " ")
//        for split in splits {
//            if matchString(String(split)) == true {
//                return true
//            }
//        }
//        return false
    }
}
