//
//  WidgetStateView.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI
import WidgetKit

struct WidgetStateView : View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: Provider.Entry
    var body: some View {
        switch widgetFamily {
        case .systemSmall,.systemMedium,.systemLarge,.systemExtraLarge:
            WidgetStateSmallView(entry: entry)
        @unknown default:
            WidgetStateSmallView(entry: entry)

        }
    }
}

struct BrickieWidgie_Previews: PreviewProvider {
    static var previews: some View {
        WidgetStateView(entry: BricksetEntry.placeHolder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
