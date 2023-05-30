//
//  LegoTheme.swift
//  Brickie
//
//  Created by Léo on 04/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import Foundation

class LegoTheme : Lego, Hashable {
    let theme : String
    let setCount : Int
    let subthemeCount : Int
    let yearFrom : Int
    let yearTo : Int
    
//    var subThemes = [LegoTheme.Subtheme]()

    static func == (lhs: LegoTheme, rhs: LegoTheme) -> Bool {
        lhs.theme == rhs.theme
    }
    
    func matchString(_ search: String) -> Bool {
        search.lowercased() == theme.lowercased()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(theme)
        hasher.combine(yearFrom)
        hasher.combine(yearTo)
    }
    
    
    
}

extension LegoTheme {
    class Subtheme : Lego, Hashable {
        let theme : String
        let subtheme : String
        let setCount : Int
        let yearFrom : Int
        let yearTo : Int

        static func == (lhs: Subtheme, rhs: Subtheme) -> Bool {
            lhs.theme == rhs.theme && lhs.subtheme == rhs.subtheme
        }
        
        func matchString(_ search: String) -> Bool {
            search.lowercased() == theme.lowercased()
            || search.lowercased() == subtheme.lowercased()
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(theme)
            hasher.combine(yearFrom)
            hasher.combine(yearTo)
        }
        
    }
}
