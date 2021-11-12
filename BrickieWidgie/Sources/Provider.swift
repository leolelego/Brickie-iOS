//
//  Provider.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import WidgetKit
import Intents
import SwiftUI

let store = Store()

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> BricksetEntry {
        BricksetEntry.placeHolder
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (BricksetEntry) -> ()) {
        let entry = BricksetEntry.placeHolder
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<BricksetEntry>) -> ()) {

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = BricksetEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
        print("items\( store.minifigs.count)")
        let entry = BricksetEntry(date: Date(), configuration: ConfigurationIntent(),
                                  sets:store.sets
                                  ,minifigs: store.minifigs)

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
