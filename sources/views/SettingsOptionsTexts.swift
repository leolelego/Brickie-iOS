//
//  SettingsOptionsTexts.swift
//  Brickie
//
//  Created by Léo on 04/02/2023.
//  Copyright © 2023 Homework. All rights reserved.
//

import SwiftUI

struct SettingsOptionsTexts: View {
    var title : LocalizedStringKey
    var sub : LocalizedStringKey
    var body: some View {
        VStack(alignment: .leading){
            Text(title).font(.body)
            Text(sub).font(.caption2).foregroundColor(.secondary)
        }
    }
}

struct SettingsOptionsTexts_Previews: PreviewProvider {
    static var previews: some View {
        SettingsOptionsTexts(title: "settings.options.reset", sub: "settings.options.resetsub")
    }
}
