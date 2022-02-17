//
//  LinkView.swift
//  Brickie
//
//  Created by Léo on 17/02/2022.
//  Copyright © 2022 Homework. All rights reserved.
//

import SwiftUI

struct LinkView: View {
    let title : LocalizedStringKey
    let link : String
    let color : Color
    var body: some View {
        if let url = link.isValidUrl() {
            Link(destination: url) {
                Text(title)
                    .fontWeight(.bold).foregroundColor(Color.black)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(color)
                    .mask(RoundedRectangle(cornerRadius: 12))
                .padding()
            }
        }
        
    }
}
