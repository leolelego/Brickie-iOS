//
//  WidgetStateView.swift
//  Brickie
//
//  Created by Léo on 12/11/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RandomWidgetView : View {
    @Environment(\.widgetFamily) private var widgetFamily

    var entry: RandomWidgetProvider.Entry
    var body: some View {
        if entry.legoSet.image.imageURL != nil {
            Image(uiImage: getImage())
                .resizable()
                            .aspectRatio(contentMode: .fit)

        } else {
            Text("No IMage")
        }
//        switch widgetFamily {
//        case .systemSmall,.systemMedium,.systemLarge,.systemExtraLarge:
//            Text("\(entry.legoSet.number )")
//        @unknown default:
//            Text("\(entry.legoSet.number )")
//
//
//        }
    }
    
    func getImage() -> UIImage {
        
        guard let url = URL(string: entry.legoSet.image.imageURL ?? ""),
              let data = try? Data(contentsOf: url)else {
            return UIImage()
        }
        
        
            let img  = UIImage(data: data) ?? UIImage()
        return img
    }
}


struct RandomWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        RandomWidgetView(entry: RandomWidgetEntry.placeHolder)
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
