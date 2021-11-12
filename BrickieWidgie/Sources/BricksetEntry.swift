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
    
    let sets : [LegoSet]
    let minifigs : [LegoMinifig]
    
    static let placeHolder = BricksetEntry(date: Date(), configuration: ConfigurationIntent(),
        sets: [],
        minifigs: []
                                           
                                           
    )
    
}


