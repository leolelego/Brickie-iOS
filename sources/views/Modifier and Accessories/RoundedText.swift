//
//  RoundedText.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI
extension Text {
    var roundText : some View {
        
        self
            .font(.system(.subheadline, design: .rounded))
                  .fontWeight(.bold)
                  .foregroundColor(Color.background)
                  .padding(.vertical, 6)
                  .padding(.horizontal, 6)
                  .background(Color.backgroundAlt)
                  .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
                  .shadow(color: Color.backgroundAlt.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
    var pill : some View {
        self.font(.footnote).bold()
            .padding(8)
            .foregroundColor(.backgroundAlt)
            .background(Circle().strokeBorder(Color.backgroundAlt, lineWidth: 2))
    }
}
