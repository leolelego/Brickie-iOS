//
//  LegoTheme.swift
//  Brickie
//
//  Created by Léo on 04/01/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import Foundation

class LegoSubTheme : Lego, Hashable {
    /*
     {
       "theme": "Ninjago",
       "subtheme": "Airjitzu",
       "setCount": 7,
       "yearFrom": 2015,
       "yearTo": 2016
     },
     */
    let theme : String
    let subtheme : String
    let setCount : Int
    let yearFrom : Int
    let yearTo : Int

    static func == (lhs: LegoSubTheme, rhs: LegoSubTheme) -> Bool {
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
