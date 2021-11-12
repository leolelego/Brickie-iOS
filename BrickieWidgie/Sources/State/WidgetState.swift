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
struct WidgetState: Widget {
    let kind: String = "WidgetState"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetStateView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Collection")
        .description("Display Your Collection")
        
    }
}

