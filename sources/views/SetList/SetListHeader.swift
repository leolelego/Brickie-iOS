//
//  SetListHeader.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct HeaderView : View {
    let text: String
    var body: some View {
        
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.textAlternate)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.header)
            .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.leading, -12)
            .padding(.bottom, -28)
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
}
