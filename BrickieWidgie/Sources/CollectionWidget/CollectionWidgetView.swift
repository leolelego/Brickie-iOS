//
//  WidgetStateView.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CollectionWidgetView : View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: CollectionWidgetProvider.Entry
    var body: some View {
        switch widgetFamily {
        case .systemSmall,.systemMedium,.systemLarge,.systemExtraLarge:
            CollectionWidgetViewSmall(entry: entry)
        @unknown default:
            CollectionWidgetViewSmall(entry: entry)

        }
    }
}

struct BrickieWidgie_Previews: PreviewProvider {
    static var previews: some View {
        CollectionWidgetView(entry: CollectionWidgetEntry.placeHolder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
