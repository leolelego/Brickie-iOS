//
//  SetListHeader.swift
//  BrickSet
//
//  Created by Work on 04/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import SwiftUI

struct RoundedText : View {
    let text: String
    var body: some View {
        
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.textAlternate)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.backgroundAlt)
            .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
      
            .shadow(color: Color.backgroundAlt.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
}


struct SetListHeader_Previews: PreviewProvider {
    static var previews: some View {
        RoundedText(text: "Create Expert")
    }
}
