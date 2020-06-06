//
//  SearchField.swift
//  BrickSet
//
//  Created by Work on 10/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    @Binding var isActive : Bool
    @EnvironmentObject var config : Configuration
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large).foregroundColor(.background)
            ZStack(alignment: .leading) {

            if searchText.isEmpty {
                if config.connection == .unavailable {
                    Text("search.placeholderoffline").foregroundColor(.gray)

                } else {
                    Text("search.placeholder").foregroundColor(.gray)

                }
                
                }

            TextField("", text: $searchText)
                .foregroundColor(Color.background)
                .font(.headline)
                .accentColor(.red)
            }
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                    self.isActive = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.headline)
                        .foregroundColor(.background)
                        .imageScale(.large)
                }.buttonStyle(BorderlessButtonStyle()).transition(.opacity)
            }

        }
        .padding(8)
        .background(Color.backgroundAlt)
        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
