//
//  BrickieEntity.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import WidgetKit

struct RandomWidgetEntry : TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    let legoSet:LegoSet
    
    static let placeHolder = RandomWidgetEntry(date: Date(), configuration: ConfigurationIntent(), legoSet: LegoSet(withFigs: true))
                                
}


