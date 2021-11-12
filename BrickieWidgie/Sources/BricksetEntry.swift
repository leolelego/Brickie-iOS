//
//  BrickieEntity.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import WidgetKit

struct BricksetEntry : TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let setsOwned : Int
    let setsWanted : Int
    let figsOwned : Int
    let figsWanted : Int
    
    static let placeHolder = BricksetEntry(date: Date(), configuration: ConfigurationIntent(),setsOwned: 0,setsWanted: 0,figsOwned: 0,figsWanted: 0)
    
}


