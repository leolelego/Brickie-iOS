//
//  Lego.swift
//  BrickSet
//
//  Created by Work on 17/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import Foundation

protocol Lego : ObservableObject, Codable , Equatable, Identifiable {
    
    var name : String { get set }
    var category : String { get set }

}

extension Lego {
    func hash(into hasher: inout Hasher) {
         hasher.combine(name)
         hasher.combine(category)
     }

    func compareThing1<T: Identifiable>(_ thing1: T, against thing2: T) -> Bool {
        return true
    }
}
