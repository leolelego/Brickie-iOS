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
struct WidgetRandomSet: Widget {
    let kind: String = "WidgetRandomSet"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetStateView(entry: entry)
        }
        .configurationDisplayName("Random Set")
        .description("Random Sets in your collection or Searched")
        
    }
}

