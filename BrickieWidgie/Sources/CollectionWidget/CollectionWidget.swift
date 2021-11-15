//
//  BrickieWidgie.swift
//  BrickieWidgie
//
//  Created by Léo on 11/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
struct CollectionWidget: Widget {
    let kind: String = "CollectionWidget"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: CollectionWidgetProvider()) { entry in
            CollectionWidgetView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("widget.collection")
        .description("widget.collection.description")
        
    }
}

