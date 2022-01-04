//
//  LegoTheme.swift
//  Brickie
//
//  Created by Léo on 04/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import Foundation

class LegoTheme : Lego, Hashable {
    /*
     {
       "theme": "Nexo Knights",
       "setCount": 107,
       "subthemeCount": 12,
       "yearFrom": 2016,
       "yearTo": 2018
     },
     */
    let theme : String
    let setCount : Int
    let subthemeCount : Int
    let yearFrom : Int
    let yearTo : Int

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
